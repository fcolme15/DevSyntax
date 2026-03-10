/* PostgreSQL Functions, Procedures, & Triggers:
CREATE FUNCTION (SQL and PL/pgSQL), CREATE PROCEDURE, triggers, custom types */


/*============================================================
//SQL FUNCTIONS — Stored queries that return values
// Language SQL: function body is a single SQL statement or expression
// Useful for encapsulating complex queries, Supabase RPC calls, reusable logic
============================================================*/

-- Basic function returning a scalar value
CREATE OR REPLACE FUNCTION get_total_employees()
RETURNS INTEGER AS $$
    SELECT COUNT(*) FROM employees;
$$ LANGUAGE SQL;

-- Call it like any built-in function
SELECT get_total_employees();

-- Function with parameters
CREATE OR REPLACE FUNCTION get_department_headcount(dept_id INTEGER)
RETURNS INTEGER AS $$
    SELECT COUNT(*) FROM employees WHERE department_id = dept_id;
$$ LANGUAGE SQL;

SELECT get_department_headcount(3);

-- Function returning a table (multiple rows, multiple columns)
-- RETURNS TABLE defines the output schema
CREATE OR REPLACE FUNCTION get_high_earners(min_salary NUMERIC)
RETURNS TABLE(
    employee_id INTEGER,
    full_name TEXT,
    salary NUMERIC,
    department_id INTEGER
) AS $$
    SELECT employee_id, first_name || ' ' || last_name, salary, department_id
    FROM employees
    WHERE salary >= min_salary
    ORDER BY salary DESC;
$$ LANGUAGE SQL;

-- Call returns a result set
SELECT * FROM get_high_earners(100000);

-- Function with default parameter values
CREATE OR REPLACE FUNCTION get_recent_orders(days_back INTEGER DEFAULT 7)
RETURNS TABLE(order_id INTEGER, order_date DATE, total NUMERIC) AS $$
    SELECT order_id, order_date, total
    FROM orders
    WHERE order_date >= CURRENT_DATE - days_back;
$$ LANGUAGE SQL;

SELECT * FROM get_recent_orders();     -- uses default: 7 days
SELECT * FROM get_recent_orders(30);   -- override: 30 days


/*============================================================
//PL/PGSQL FUNCTIONS — Procedural language with variables, loops, conditionals
// More powerful than SQL functions, supports complex logic
============================================================*/

-- Basic PL/pgSQL function with variables and IF
CREATE OR REPLACE FUNCTION calculate_bonus(emp_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    emp_salary NUMERIC;
    bonus NUMERIC;
BEGIN
    -- Assign query result to variable
    SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;
    
    -- Conditional logic
    IF emp_salary > 100000 THEN
        bonus := emp_salary * 0.15;
    ELSIF emp_salary > 70000 THEN
        bonus := emp_salary * 0.10;
    ELSE
        bonus := emp_salary * 0.05;
    END IF;
    
    RETURN bonus;
END;
$$ LANGUAGE plpgsql;

SELECT calculate_bonus(42);

-- Loop example: LOOP, WHILE, FOR
CREATE OR REPLACE FUNCTION generate_sequence(n INTEGER)
RETURNS TABLE(num INTEGER) AS $$
DECLARE
    i INTEGER := 1;
BEGIN
    WHILE i <= n LOOP
        num := i;
        RETURN NEXT;  -- add current row to result set
        i := i + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM generate_sequence(10);

-- FOR loop over query results
CREATE OR REPLACE FUNCTION process_orders()
RETURNS VOID AS $$
DECLARE
    ord RECORD;  -- RECORD holds a row from a query
BEGIN
    FOR ord IN SELECT * FROM orders WHERE status = 'pending' LOOP
        -- Process each order
        UPDATE orders SET status = 'processing' WHERE order_id = ord.order_id;
        INSERT INTO audit_log (event) VALUES ('Processing order ' || ord.order_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_orders();

-- EXCEPTION handling: catch and handle errors
CREATE OR REPLACE FUNCTION safe_divide(a NUMERIC, b NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN a / b;
EXCEPTION
    WHEN division_by_zero THEN
        RETURN NULL;  -- or RAISE NOTICE, or handle however needed
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Unexpected error: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

SELECT safe_divide(10, 0);  -- returns NULL instead of error


/*============================================================
//FUNCTION MODIFIERS — Control caching, volatility, and optimization
============================================================*/

-- IMMUTABLE: result never changes for the same inputs (allows aggressive caching)
CREATE OR REPLACE FUNCTION add_numbers(a INTEGER, b INTEGER)
RETURNS INTEGER AS $$
    SELECT a + b;
$$ LANGUAGE SQL IMMUTABLE;

-- STABLE: result is consistent within a transaction but may change between transactions
-- Example: functions using NOW(), CURRENT_DATE
CREATE OR REPLACE FUNCTION get_orders_today()
RETURNS TABLE(order_id INTEGER) AS $$
    SELECT order_id FROM orders WHERE order_date = CURRENT_DATE;
$$ LANGUAGE SQL STABLE;

-- VOLATILE (default): result can change between calls even within the same statement
-- Example: RANDOM(), functions with side effects (INSERT/UPDATE)
CREATE OR REPLACE FUNCTION log_access()
RETURNS VOID AS $$
    INSERT INTO access_log (accessed_at) VALUES (NOW());
$$ LANGUAGE SQL VOLATILE;

-- SECURITY DEFINER: function runs with privileges of the user who created it
-- Useful for controlled access to restricted tables
CREATE OR REPLACE FUNCTION get_sensitive_data()
RETURNS TABLE(id INTEGER, value TEXT)
SECURITY DEFINER  -- runs as the function owner, not the caller
AS $$
    SELECT id, value FROM sensitive_table;
$$ LANGUAGE SQL;


/*============================================================
//PROCEDURES — Like functions but don't return values
// Can COMMIT/ROLLBACK inside the procedure (functions cannot)
// Useful for batch operations, maintenance tasks
============================================================*/

-- CREATE PROCEDURE syntax (PostgreSQL 11+)
CREATE OR REPLACE PROCEDURE archive_old_orders(cutoff_date DATE)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO orders_archive SELECT * FROM orders WHERE order_date < cutoff_date;
    DELETE FROM orders WHERE order_date < cutoff_date;
    COMMIT;  -- allowed in procedures, not in functions
END;
$$;

-- Call with CALL statement
CALL archive_old_orders('2023-01-01');

-- Procedure with transaction control
CREATE OR REPLACE PROCEDURE bulk_update_prices(category TEXT, multiplier NUMERIC)
LANGUAGE plpgsql AS $$
DECLARE
    row_count INTEGER := 0;
BEGIN
    UPDATE products SET price = price * multiplier WHERE product_category = category;
    GET DIAGNOSTICS row_count = ROW_COUNT;  -- number of affected rows
    
    IF row_count > 1000 THEN
        ROLLBACK;  -- undo if too many rows affected
        RAISE EXCEPTION 'Too many rows updated: %', row_count;
    ELSE
        COMMIT;
    END IF;
END;
$$;


/*============================================================
//TRIGGERS — Automatically execute a function in response to table events
// Events: BEFORE/AFTER INSERT, UPDATE, DELETE, TRUNCATE
// Granularity: FOR EACH ROW (once per affected row) or FOR EACH STATEMENT (once total)
============================================================*/

-- Trigger function: must return TRIGGER type, receives special variables (NEW, OLD, TG_OP)
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();  -- NEW is the row being inserted/updated
    RETURN NEW;  -- return the modified row
END;
$$ LANGUAGE plpgsql;

-- Attach trigger to a table
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

-- Now every UPDATE on employees automatically sets updated_at

-- Audit log trigger: log all changes to a table
CREATE OR REPLACE FUNCTION audit_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, operation, new_data)
        VALUES (TG_TABLE_NAME, 'INSERT', ROW_TO_JSON(NEW));
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, operation, old_data, new_data)
        VALUES (TG_TABLE_NAME, 'UPDATE', ROW_TO_JSON(OLD), ROW_TO_JSON(NEW));
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, operation, old_data)
        VALUES (TG_TABLE_NAME, 'DELETE', ROW_TO_JSON(OLD));
    END IF;
    RETURN NULL;  -- AFTER triggers ignore return value
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_employees
    AFTER INSERT OR UPDATE OR DELETE ON employees
    FOR EACH ROW
    EXECUTE FUNCTION audit_changes();

-- Conditional trigger: use WHEN clause to filter which rows fire the trigger
CREATE TRIGGER audit_high_value_orders
    AFTER INSERT ON orders
    FOR EACH ROW
    WHEN (NEW.total > 10000)
    EXECUTE FUNCTION log_high_value_order();

-- BEFORE trigger can prevent the operation by returning NULL
CREATE OR REPLACE FUNCTION prevent_weekend_orders()
RETURNS TRIGGER AS $$
BEGIN
    IF EXTRACT(dow FROM NEW.order_date) IN (0, 6) THEN  -- 0=Sunday, 6=Saturday
        RAISE EXCEPTION 'Cannot create orders on weekends';
        -- Alternative: RETURN NULL to silently skip the insert
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER no_weekend_orders
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION prevent_weekend_orders();


/*============================================================
//TRIGGER VARIABLES — Special values available inside trigger functions
============================================================*/

-- NEW      — the new row (INSERT, UPDATE) — NULL for DELETE
-- OLD      — the old row (UPDATE, DELETE) — NULL for INSERT
-- TG_OP    — operation type: 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE'
-- TG_TABLE_NAME   — name of the table that fired the trigger
-- TG_TABLE_SCHEMA — schema of the table
-- TG_WHEN  — 'BEFORE' or 'AFTER'
-- TG_LEVEL — 'ROW' or 'STATEMENT'


/*============================================================
//DROP & ALTER FUNCTIONS/PROCEDURES/TRIGGERS
============================================================*/

DROP FUNCTION get_total_employees();
DROP FUNCTION IF EXISTS calculate_bonus(INTEGER);  -- include parameter types
DROP PROCEDURE archive_old_orders(DATE);
DROP TRIGGER set_updated_at ON employees;

-- Disable/enable a trigger without dropping it
ALTER TABLE employees DISABLE TRIGGER set_updated_at;
ALTER TABLE employees ENABLE TRIGGER set_updated_at;


/*============================================================
//CUSTOM TYPES — Define reusable composite types
============================================================*/

-- Create a composite type (like a struct)
CREATE TYPE address AS (
    street TEXT,
    city TEXT,
    state TEXT,
    zip TEXT
);

-- Use it in a table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT,
    billing_address address,
    shipping_address address
);

-- Insert with composite type literal
INSERT INTO customers (name, billing_address)
VALUES ('Alice', ROW('123 Main St', 'New York', 'NY', '10001'));

-- Access fields with dot notation
SELECT name, (billing_address).city FROM customers;

-- Create an ENUM type
CREATE TYPE order_status AS ENUM ('pending', 'confirmed', 'shipped', 'cancelled');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    status order_status DEFAULT 'pending'
);

-- Drop a type
DROP TYPE address;
DROP TYPE order_status;


/*============================================================
//DOMAINS — Constrained type aliases
// Like a type with built-in validation
============================================================*/

-- Create a domain: a base type + constraints
CREATE DOMAIN email_address AS TEXT
CHECK (VALUE ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

CREATE DOMAIN positive_number AS NUMERIC
CHECK (VALUE > 0);

-- Use like any type
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email email_address,
    balance positive_number
);

-- Invalid values are rejected
INSERT INTO users (email) VALUES ('invalid-email');  -- ERROR: violates check constraint

DROP DOMAIN email_address;


/*============================================================
//VIEWING FUNCTIONS, PROCEDURES, TRIGGERS
============================================================*/

-- List all functions in a schema
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public';

-- View function definition
\df function_name              -- in psql
SELECT pg_get_functiondef('function_name'::regproc);

-- List triggers on a table
SELECT trigger_name, event_manipulation, action_timing
FROM information_schema.triggers
WHERE event_object_table = 'employees';