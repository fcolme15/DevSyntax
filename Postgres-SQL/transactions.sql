/* PostgreSQL Transactions & Concurrency:
BEGIN/COMMIT/ROLLBACK, SAVEPOINT, isolation levels, FOR UPDATE/SHARE, LOCK TABLE, deadlocks */


/*============================================================
//TRANSACTIONS — Group multiple statements into an atomic unit
// Either all statements succeed (COMMIT) or all are undone (ROLLBACK)
============================================================*/

-- Basic transaction structure
BEGIN;
    UPDATE accounts SET balance = balance - 100 WHERE id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;   -- makes all changes permanent

-- ROLLBACK — undo all changes since BEGIN
BEGIN;
    DELETE FROM orders WHERE status = 'pending';
    -- Oh no, wrong query!
ROLLBACK;   -- nothing is deleted

-- START TRANSACTION — synonym for BEGIN, SQL standard syntax
START TRANSACTION;
    INSERT INTO audit_log (event) VALUES ('user_login');
COMMIT;

-- Autocommit mode: by default, every statement is its own transaction
-- SET autocommit = off to require explicit COMMIT (psql setting, not SQL command)


/*============================================================
//SAVEPOINT — Create rollback points within a transaction
// Allows partial rollback without losing the entire transaction
============================================================*/

BEGIN;
    INSERT INTO orders (customer_id, total) VALUES (42, 100);
    SAVEPOINT order_created;

    INSERT INTO order_items (order_id, product_id, quantity) VALUES (1001, 5, 3);
    -- Error in the line item, but we want to keep the order
    ROLLBACK TO SAVEPOINT order_created;   -- undoes the INSERT into order_items only

    INSERT INTO order_items (order_id, product_id, quantity) VALUES (1001, 6, 2);
COMMIT;   -- commits the order and the corrected line item. Releases all savepoints

-- Release a savepoint (frees resources, can no longer rollback to it)
SAVEPOINT sp1;
    -- some work
RELEASE SAVEPOINT sp1;


/*============================================================
//ISOLATION LEVELS — Control how transactions see each other's changes
// Trade-off between consistency and concurrency
// PostgreSQL default: READ COMMITTED
============================================================*/

-- READ UNCOMMITTED — not actually different from READ COMMITTED in PostgreSQL
-- PostgreSQL does not support dirty reads, so this behaves like READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- READ COMMITTED (default) — each statement sees committed data as of statement start
-- Different statements in the same transaction can see different snapshots
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN;
    SELECT balance FROM accounts WHERE id = 1;   -- sees 100
    -- Another transaction commits a change: balance → 150
    SELECT balance FROM accounts WHERE id = 1;   -- now sees 150 (non-repeatable read)
COMMIT;

-- REPEATABLE READ — entire transaction sees a consistent snapshot from transaction start
-- Prevents non-repeatable reads and phantom reads
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN;
    SELECT balance FROM accounts WHERE id = 1;   -- sees 100
    -- Another transaction commits a change: balance → 150
    SELECT balance FROM accounts WHERE id = 1;   -- still sees 100 (repeatable read)
COMMIT;

-- SERIALIZABLE — strictest isolation, emulates serial execution
-- Transactions appear to run one after another with no overlap
-- May throw serialization errors that require retry
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Set isolation level for a single transaction
BEGIN ISOLATION LEVEL REPEATABLE READ;
    -- transaction work here
COMMIT;

-- Set session default isolation level
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;


/*============================================================
//READ/WRITE MODE — Control whether a transaction can modify data
============================================================*/

-- READ ONLY — transaction cannot modify any data (useful for reporting queries)
BEGIN READ ONLY;
    SELECT * FROM sales WHERE year = 2024;
COMMIT;

-- READ WRITE — transaction can modify data (default)
BEGIN READ WRITE;
    UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 42;
COMMIT;


/*============================================================
//FOR UPDATE / FOR SHARE — Row-level locks for concurrent access
// Acquire locks on rows retrieved by a SELECT to prevent other transactions from modifying them
============================================================*/

-- FOR UPDATE — exclusive lock, prevents other transactions from reading or modifying
-- Other SELECT FOR UPDATE or UPDATE/DELETE will block until this transaction commits
BEGIN;
    SELECT * FROM products WHERE id = 42 FOR UPDATE;
    -- Now only this transaction can modify product 42
    UPDATE products SET stock = stock - 1 WHERE id = 42;
COMMIT;

-- FOR SHARE — shared lock, prevents modification but allows other FOR SHARE reads
-- Multiple transactions can hold FOR SHARE on the same rows simultaneously
BEGIN;
    SELECT * FROM orders WHERE id = 100 FOR SHARE;
    -- Other transactions can read, but cannot UPDATE or DELETE this row
COMMIT;

-- NOWAIT — return an error immediately if the lock cannot be acquired
-- Avoids blocking, useful for background jobs that can retry later
BEGIN;
    SELECT * FROM inventory WHERE product_id = 42 FOR UPDATE NOWAIT;
COMMIT;
-- Throws error if another transaction already holds a lock on that row

-- SKIP LOCKED — skip rows that are already locked, process the rest
-- Useful for job queues where multiple workers should grab different rows
BEGIN;
    SELECT * FROM tasks WHERE status = 'pending'
    ORDER BY priority DESC
    LIMIT 10
    FOR UPDATE SKIP LOCKED;
    -- Only returns unlocked rows, skips any that another worker already locked
    UPDATE tasks SET status = 'processing' WHERE id IN (...);
COMMIT;

-- FOR UPDATE OF — lock only rows from specific tables in a join
SELECT o.*, c.name
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.id
WHERE o.status = 'pending'
FOR UPDATE OF o;   -- locks orders rows, not customers


/*============================================================
//LOCK TABLE — Explicit table-level locks
// Rarely needed in practice; row-level locks are usually sufficient
============================================================*/

-- ACCESS SHARE — least restrictive, acquired automatically by SELECT
-- Only conflicts with ACCESS EXCLUSIVE
LOCK TABLE products IN ACCESS SHARE MODE;

-- ROW SHARE — acquired by SELECT FOR UPDATE/SHARE
LOCK TABLE products IN ROW SHARE MODE;

-- ROW EXCLUSIVE — acquired by INSERT, UPDATE, DELETE
LOCK TABLE products IN ROW EXCLUSIVE MODE;

-- SHARE UPDATE EXCLUSIVE — prevents concurrent schema changes (ALTER TABLE, VACUUM)
LOCK TABLE products IN SHARE UPDATE EXCLUSIVE MODE;

-- SHARE — allows concurrent reads but prevents writes
LOCK TABLE products IN SHARE MODE;

-- SHARE ROW EXCLUSIVE — prevents concurrent writes and SHARE locks
LOCK TABLE products IN SHARE ROW EXCLUSIVE MODE;

-- EXCLUSIVE — allows concurrent reads but prevents writes and other EXCLUSIVE locks
LOCK TABLE products IN EXCLUSIVE MODE;

-- ACCESS EXCLUSIVE — most restrictive, blocks all access (acquired by DROP TABLE, TRUNCATE, ALTER TABLE)
LOCK TABLE products IN ACCESS EXCLUSIVE MODE;

-- NOWAIT with LOCK TABLE
LOCK TABLE products IN ACCESS EXCLUSIVE MODE NOWAIT;


/*============================================================
//DEADLOCKS — Two transactions waiting for each other's locks
// PostgreSQL detects deadlocks and aborts one transaction automatically
============================================================*/

-- Example deadlock scenario (two sessions):
-- Session 1:
BEGIN;
    UPDATE accounts SET balance = balance - 10 WHERE id = 1;
    -- waits here
    UPDATE accounts SET balance = balance + 10 WHERE id = 2;
COMMIT;

-- Session 2 (runs concurrently):
BEGIN;
    UPDATE accounts SET balance = balance - 10 WHERE id = 2;
    -- waits here
    UPDATE accounts SET balance = balance + 10 WHERE id = 1;   -- DEADLOCK DETECTED
COMMIT;

-- PostgreSQL aborts one transaction with an error:
-- ERROR:  deadlock detected
-- DETAIL:  Process X waits for ShareLock on transaction Y; blocked by process Z.

-- Avoiding deadlocks:
-- 1. Access tables/rows in a consistent order across all transactions
-- 2. Keep transactions short
-- 3. Use NOWAIT or SKIP LOCKED to fail fast instead of blocking


/*============================================================
//TRANSACTION DURABILITY & PERFORMANCE
============================================================*/

-- SYNCHRONOUS_COMMIT — controls when COMMIT returns
-- on (default): waits for WAL to be flushed to disk (safest, slower)
-- off: returns immediately without waiting for disk flush (faster, small risk of data loss on crash)
SET synchronous_commit = off;   -- session-level setting

-- Asynchronous commit trades durability for speed
-- Committed transactions may be lost if the server crashes before WAL is written
-- Useful for non-critical logging or analytics inserts


/*============================================================
//MONITORING LOCKS & BLOCKING
============================================================*/

-- See all active locks in the database
SELECT * FROM pg_locks;

-- See blocking relationships (which transactions are waiting on which)
SELECT
    blocked.pid         AS blocked_pid,
    blocking.pid        AS blocking_pid,
    blocked.usename     AS blocked_user,
    blocking.usename    AS blocking_user,
    blocked.query       AS blocked_query,
    blocking.query      AS blocking_query
FROM pg_stat_activity AS blocked
JOIN pg_locks AS blocked_locks ON blocked.pid = blocked_locks.pid
JOIN pg_locks AS blocking_locks ON blocked_locks.locktype = blocking_locks.locktype
    AND blocked_locks.database IS NOT DISTINCT FROM blocking_locks.database
    AND blocked_locks.relation IS NOT DISTINCT FROM blocking_locks.relation
    AND blocked_locks.pid != blocking_locks.pid
JOIN pg_stat_activity AS blocking ON blocking_locks.pid = blocking.pid
WHERE NOT blocked_locks.granted;

-- Kill a blocking transaction (requires superuser or pg_signal_backend role)
SELECT PG_CANCEL_BACKEND(pid);      -- attempts to cancel the query gracefully
SELECT PG_TERMINATE_BACKEND(pid);   -- forcibly terminates the session


/*============================================================
//MULTI-VERSION CONCURRENCY CONTROL (MVCC) — How PostgreSQL handles concurrency
// PostgreSQL never locks rows for reads — readers never block writers, writers never block readers
// Each transaction sees a snapshot of the database from when it started (or statement started)
============================================================*/

-- How MVCC works:
-- 1. Every row version is tagged with the transaction ID that created it
-- 2. When a row is updated, PostgreSQL creates a new version (old version stays until vacuumed)
-- 3. Each transaction sees only row versions that were committed before its snapshot
-- 4. Dead row versions are cleaned up by VACUUM

-- MVCC advantages:
-- - High concurrency: readers don't block writers
-- - Consistent snapshots: REPEATABLE READ and SERIALIZABLE work efficiently

-- MVCC trade-offs:
-- - Table bloat: dead row versions accumulate until VACUUM runs
-- - VACUUM overhead: must periodically clean up old versions


/*============================================================
//TWO-PHASE COMMIT — Distributed transactions across multiple databases
// Rarely used in application code; typically handled by transaction coordinators
============================================================*/

-- Prepare a transaction (does not commit yet)
BEGIN;
    UPDATE accounts SET balance = balance - 100 WHERE id = 1;
PREPARE TRANSACTION 'tx_001';

-- Later, commit or rollback the prepared transaction
COMMIT PREPARED 'tx_001';
-- or
ROLLBACK PREPARED 'tx_001';

-- See all prepared transactions
SELECT * FROM pg_prepared_xacts;