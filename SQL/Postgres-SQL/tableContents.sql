/* PostgreSQL Reference Index
   Quick lookup guide for finding syntax across all reference files */


/*============================================================
// FILE 01: BASICS
============================================================*/
-- SELECT basics, column expressions, aliases
-- WHERE clause: comparison operators, BETWEEN, IN, NULL checks
-- LIKE / ILIKE pattern matching
-- Regex operators: ~, ~*, !~, !~*
-- ORDER BY: ASC/DESC, NULLS FIRST/LAST, ordering by expression
-- LIMIT / OFFSET pagination, FETCH syntax
-- DISTINCT: single and multi-column, DISTINCT ON
-- Set operations: UNION, UNION ALL, INTERSECT, EXCEPT
-- Table and column aliasing


/*============================================================
// FILE 02: JOINS
============================================================*/
-- JOIN syntax: explicit vs implicit, USING, NATURAL JOIN
-- INNER JOIN
-- LEFT JOIN, anti-join pattern
-- RIGHT JOIN
-- FULL OUTER JOIN
-- CROSS JOIN (cartesian product)
-- SELF JOIN (hierarchies, pairs)
-- LATERAL JOIN (correlated subqueries in FROM)
-- Multi-condition joins, non-equi joins
-- ON vs WHERE placement (critical for outer joins)
-- Joining aggregates
-- UNION, INTERSECT, EXCEPT (combining result sets)


/*============================================================
// FILE 03: AGGREGATIONS
============================================================*/
-- Aggregate functions: COUNT, SUM, AVG, MIN, MAX, STDDEV, VARIANCE
-- STRING_AGG (concatenate rows)
-- ARRAY_AGG (collect into array)
-- JSON_AGG, JSONB_AGG (collect into JSON)
-- BOOL_AND, BOOL_OR
-- GROUP BY: single/multiple columns, expressions
-- HAVING (filter groups)
-- FILTER clause (conditional aggregation)
-- ROLLUP (subtotals)
-- CUBE (all combinations)
-- GROUPING SETS (explicit combinations)
-- GROUPING() function
-- Order of execution (FROM → WHERE → GROUP BY → HAVING → SELECT)


/*============================================================
// FILE 04: SUBQUERIES
============================================================*/
-- Subquery types: scalar, column, row, table
-- Scalar subqueries in SELECT and WHERE
-- Column subqueries with IN, ANY, ALL
-- EXISTS / NOT EXISTS (safer than NOT IN with NULLs)
-- Table subqueries in FROM
-- Correlated vs non-correlated subqueries
-- WITH / CTE (Common Table Expressions)
-- Multiple CTEs, chaining
-- MATERIALIZED CTEs
-- Recursive CTEs: structure, anchor + recursive term
-- Cycle detection in recursive CTEs
-- CYCLE clause (PostgreSQL 14+)


/*============================================================
// FILE 05: DML (Data Manipulation)
============================================================*/
-- INSERT: single row, multiple rows, from SELECT, DEFAULT values
-- RETURNING clause (get data back from INSERT/UPDATE/DELETE)
-- UPDATE: basic, multiple columns, with subquery, UPDATE...FROM
-- DELETE: basic, DELETE...USING
-- TRUNCATE: fast delete all, RESTART IDENTITY, CASCADE
-- UPSERT: ON CONFLICT DO NOTHING, DO UPDATE
-- EXCLUDED (reference proposed INSERT values in upsert)
-- Conditional upsert with WHERE
-- COPY: bulk import/export from/to files


/*============================================================
// FILE 06: DDL (Data Definition)
============================================================*/
-- CREATE TABLE: columns, data types, defaults
-- Data types: numeric, text, date/time, boolean, UUID, JSON/JSONB, arrays
-- Constraints: PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, NOT NULL
-- Inline vs table-level constraints
-- Named constraints
-- Foreign key actions: CASCADE, RESTRICT, SET NULL, SET DEFAULT
-- ALTER TABLE: add/drop/rename columns, change type, set/drop defaults, set/drop NOT NULL
-- Add/drop constraints
-- Rename table
-- DROP TABLE: basic, IF EXISTS, CASCADE
-- Indexes: B-tree, composite, unique, partial, expression, GIN, GiST, BRIN
-- CREATE INDEX CONCURRENTLY
-- DROP INDEX
-- Sequences: CREATE SEQUENCE, NEXTVAL, CURRVAL, LASTVAL, ALTER SEQUENCE
-- Schemas: CREATE SCHEMA, search_path


/*============================================================
// FILE 07: STRING FUNCTIONS
============================================================*/
-- Concatenation: || operator, CONCAT, CONCAT_WS
-- Case conversion: UPPER, LOWER, INITCAP
-- Length: LENGTH, CHAR_LENGTH, OCTET_LENGTH, BIT_LENGTH
-- ASCII, CHR
-- Substring: SUBSTRING, SUBSTR, LEFT, RIGHT
-- Searching: POSITION, STRPOS, STARTS_WITH
-- Trimming: TRIM, LTRIM, RTRIM, BTRIM
-- Padding: LPAD, RPAD
-- Replacing: REPLACE, OVERLAY, REVERSE, REPEAT, TRANSLATE
-- Splitting: SPLIT_PART, STRING_TO_ARRAY, ARRAY_TO_STRING
-- Formatting: FORMAT, TO_CHAR
-- Regex: ~, ~*, REGEXP_LIKE, REGEXP_REPLACE, REGEXP_MATCH, REGEXP_MATCHES
-- REGEXP_SPLIT_TO_TABLE, REGEXP_SPLIT_TO_ARRAY
-- Encoding: ENCODE, DECODE, CONVERT_FROM, MD5


/*============================================================
// FILE 08: DATE/TIME FUNCTIONS
============================================================*/
-- Current date/time: NOW, CURRENT_TIMESTAMP, CURRENT_DATE, CURRENT_TIME
-- CLOCK_TIMESTAMP vs TRANSACTION_TIMESTAMP
-- Date/time literals and casting
-- INTERVAL: construction, arithmetic
-- MAKE_INTERVAL, MAKE_DATE, MAKE_TIMESTAMP, MAKE_TIMESTAMPTZ
-- DATE_TRUNC: truncate to unit (year, month, day, hour, etc.)
-- EXTRACT / DATE_PART: pull components (year, month, dow, epoch, etc.)
-- AGE: compute intervals between dates
-- Date arithmetic: add/subtract intervals, subtract dates
-- Timezone handling: AT TIME ZONE, SET timezone
-- Parsing: TO_DATE, TO_TIMESTAMP
-- Formatting: TO_CHAR
-- GENERATE_SERIES for date sequences
-- Common patterns: last N days, current month, day of week filters


/*============================================================
// FILE 09: NUMERIC FUNCTIONS
============================================================*/
-- Rounding: ROUND, TRUNC, CEIL, FLOOR
-- Absolute value: ABS, SIGN, FACTORIAL
-- Powers and roots: POWER, ^, SQRT, CBRT, EXP
-- Logarithms: LN, LOG
-- Modulo: MOD, %, DIV
-- Integer vs float division
-- Statistical aggregates: CORR, COVAR_POP, COVAR_SAMP, REGR_SLOPE, REGR_INTERCEPT, REGR_R2
-- RANDOM, SETSEED
-- Type casting: :: operator, CAST()
-- Numeric type hierarchy
-- Formatting: TO_CHAR, TO_NUMBER
-- Special values: Infinity, -Infinity, NaN


/*============================================================
// FILE 10: CONDITIONAL LOGIC
============================================================*/
-- CASE: searched CASE, simple CASE
-- CASE in SELECT, ORDER BY, aggregation
-- COALESCE: return first non-NULL
-- NULLIF: return NULL if values are equal
-- GREATEST / LEAST: largest/smallest from list
-- NULL handling: IS NULL, IS NOT NULL, IS DISTINCT FROM
-- NULL propagation in expressions
-- NULLs in aggregates, ORDER BY, UNIQUE constraints
-- Type casting: :: vs CAST()
-- Casting in expressions, integer vs float division


/*============================================================
// FILE 11: WINDOW FUNCTIONS
============================================================*/
-- Window function basics: OVER clause
-- PARTITION BY (like GROUP BY but doesn't collapse rows)
-- ORDER BY within window
-- ROW_NUMBER, RANK, DENSE_RANK (ranking functions)
-- NTILE (bucketing)
-- LAG / LEAD (access previous/next rows)
-- FIRST_VALUE, LAST_VALUE, NTH_VALUE
-- Frame clauses: ROWS vs RANGE, BETWEEN, PRECEDING, FOLLOWING, CURRENT ROW
-- Default frames with/without ORDER BY
-- Named windows (WINDOW clause)
-- Common patterns: top N per group, running totals, moving averages


/*============================================================
// FILE 12: JSON OPERATIONS
============================================================*/
-- JSON vs JSONB (when to use each)
-- Operators: ->, ->>, #>, #>>
-- Array indexing: 0-based, negative indexing
-- Existence: ?, ?|, ?&
-- Containment: @>, <@
-- JSONPath: @?, @@
-- Building JSON: JSON_BUILD_OBJECT, JSON_BUILD_ARRAY, ROW_TO_JSON, TO_JSON
-- Aggregating: JSON_AGG, JSONB_AGG, JSON_OBJECT_AGG
-- Modifying: JSONB_SET, JSONB_INSERT, || operator, - operator, #- operator
-- JSONB_STRIP_NULLS
-- Extracting: JSONB_EACH, JSONB_EACH_TEXT, JSONB_OBJECT_KEYS
-- JSONB_ARRAY_ELEMENTS, JSONB_TO_RECORD, JSONB_POPULATE_RECORD
-- JSONPath functions: JSONB_PATH_EXISTS, JSONB_PATH_QUERY, JSONB_PATH_QUERY_ARRAY
-- Indexing: GIN index on JSONB, expression indexes
-- Type checking: JSONB_TYPEOF, JSONB_ARRAY_LENGTH, JSONB_PRETTY


/*============================================================
// FILE 13: ARRAY OPERATIONS
============================================================*/
-- Array types and literals
-- ARRAY constructor
-- Indexing: 1-indexed, slicing
-- Operators: ||, =, <>, @>, <@, &&
-- Functions: ARRAY_LENGTH, ARRAY_UPPER, ARRAY_LOWER
-- ARRAY_APPEND, ARRAY_PREPEND, ARRAY_CAT
-- ARRAY_REMOVE, ARRAY_REPLACE
-- ARRAY_POSITION, ARRAY_POSITIONS
-- ARRAY_TO_STRING, STRING_TO_ARRAY
-- ARRAY_AGG (aggregation)
-- UNNEST: expand array to rows, WITH ORDINALITY
-- ANY / ALL: quantified comparisons
-- Containment: @>, <@, &&
-- Indexing: GIN index on arrays
-- Multidimensional arrays (rarely used)


/*============================================================
// FILE 14: ADVANCED FEATURES
============================================================*/
-- LATERAL joins: correlated subqueries in FROM, top N per group
-- Recursive CTEs: hierarchies, graphs, cycle detection
-- CROSSTAB / pivot tables: tablefunc extension, manual pivot with CASE
-- Full-text search: TO_TSVECTOR, TO_TSQUERY, PLAINTO_TSQUERY, PHRASETO_TSQUERY
-- @@ operator, TS_RANK, precomputed tsvector + GIN index
-- GENERATE_SERIES: numbers, dates, timestamps, gap-filling
-- TABLESAMPLE: BERNOULLI, SYSTEM, REPEATABLE
-- Materialized views: CREATE, REFRESH, CONCURRENTLY
-- LISTEN / NOTIFY: pub/sub messaging
-- Advisory locks: PG_ADVISORY_LOCK, PG_TRY_ADVISORY_LOCK, PG_ADVISORY_UNLOCK


/*============================================================
// FILE 15: TRANSACTIONS & CONCURRENCY
============================================================*/
-- BEGIN / COMMIT / ROLLBACK, START TRANSACTION
-- SAVEPOINT: create, rollback to, release
-- Isolation levels: READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE
-- SET TRANSACTION ISOLATION LEVEL
-- READ ONLY / READ WRITE mode
-- FOR UPDATE: exclusive row lock, NOWAIT, SKIP LOCKED
-- FOR SHARE: shared row lock
-- FOR UPDATE OF: lock specific tables in a join
-- LOCK TABLE: table-level locks, lock modes
-- Deadlocks: detection, avoidance strategies
-- SYNCHRONOUS_COMMIT setting
-- Monitoring locks: pg_locks, pg_stat_activity
-- PG_CANCEL_BACKEND, PG_TERMINATE_BACKEND
-- MVCC explanation
-- Two-phase commit: PREPARE TRANSACTION, COMMIT/ROLLBACK PREPARED


/*============================================================
// FILE 16: FUNCTIONS, PROCEDURES, TRIGGERS
============================================================*/
-- SQL functions: CREATE FUNCTION, RETURNS scalar/TABLE
-- Function parameters, default values
-- PL/pgSQL functions: DECLARE, variables, IF/ELSIF/ELSE
-- Loops: LOOP, WHILE, FOR over query results
-- EXCEPTION handling
-- RETURN, RETURN NEXT
-- Function modifiers: IMMUTABLE, STABLE, VOLATILE, SECURITY DEFINER
-- Procedures: CREATE PROCEDURE, CALL, COMMIT/ROLLBACK inside procedures
-- Triggers: CREATE TRIGGER, BEFORE/AFTER, FOR EACH ROW/STATEMENT
-- Trigger functions: RETURNS TRIGGER, NEW, OLD, TG_OP, TG_TABLE_NAME
-- Conditional triggers: WHEN clause
-- Trigger patterns: auto-timestamps, audit logs, validation
-- DROP FUNCTION, DROP PROCEDURE, DROP TRIGGER
-- ALTER TABLE DISABLE/ENABLE TRIGGER
-- Custom types: CREATE TYPE (composite), ENUM, ROW()
-- Domains: CREATE DOMAIN with CHECK constraints
-- Viewing functions/triggers: information_schema, \df, pg_get_functiondef


/*============================================================
// FILE 17: EXECUTION ORDER (if created)
============================================================*/
-- SQL query execution order: FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
-- Why SELECT aliases don't work in WHERE/HAVING
-- Window function execution timing
-- Subquery execution: WHERE vs FROM vs SELECT
-- CTE execution: materialized vs inlined
-- Transaction and lock acquisition timing
-- Query planning vs execution: EXPLAIN, EXPLAIN ANALYZE