/*============================================================
//ORDER OF EXECUTION 
============================================================*/

-- SQL Query Execution Order (logical, not physical)
-- 1. FROM / JOIN   — identify source rows, apply join conditions
-- 2. WHERE         — filter individual rows before grouping
-- 3. GROUP BY      — split into groups
-- 4. Aggregates    — computed per group (COUNT, SUM, AVG, etc.)
-- 5. HAVING        — filter groups based on aggregate results
-- 6. SELECT        — project columns and compute aliases
-- 7. DISTINCT      — deduplicate if present
-- 8. UNION/INTERSECT/EXCEPT — combine result sets (if present)
-- 9. ORDER BY      — sort final result (can use SELECT aliases)
-- 10. LIMIT/OFFSET — paginate

-- Key Consequences:
-- - SELECT aliases are NOT available in WHERE or HAVING (they run before SELECT)
-- - ORDER BY CAN use SELECT aliases (PostgreSQL allows this as a convenience)
-- - Window functions run during SELECT (after WHERE/GROUP BY but before ORDER BY)
-- - Subqueries in FROM are evaluated before the outer query's WHERE
-- - CTEs (WITH) are evaluated before the main query starts


/*============================================================
//WINDOW FUNCTION EXECUTION
============================================================*/

-- Window functions execute during the SELECT phase, after:
-- - WHERE has filtered rows
-- - GROUP BY has created groups
-- - HAVING has filtered groups
-- But before:
-- - DISTINCT
-- - ORDER BY (final sort)

-- This is why you can't use window function results in WHERE or HAVING
-- Invalid: SELECT * FROM employees WHERE ROW_NUMBER() OVER (...) = 1
-- Valid: Use a subquery or CTE
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) AS rn
    FROM employees
) WHERE rn = 1;


/*============================================================
//SUBQUERY EXECUTION
============================================================*/

-- Subqueries in WHERE/HAVING: evaluated per row (can be correlated)
SELECT * FROM employees AS e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);

-- Subqueries in FROM: evaluated once before outer query (cannot be correlated)
SELECT * FROM (SELECT * FROM employees WHERE is_active = true) AS active
WHERE salary > 80000;

-- Subqueries in SELECT: evaluated per output row
SELECT first_name, (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) AS order_count
FROM customers AS c;


/*============================================================
//CTE (WITH) EXECUTION
============================================================*/

-- CTEs are evaluated before the main query
-- Non-recursive CTEs: evaluated once, result set is materialized (or inlined by optimizer)
-- Recursive CTEs: evaluated iteratively until no new rows are produced

-- By default, PostgreSQL may inline simple CTEs (treat them like subqueries)
-- Use MATERIALIZED to force independent evaluation
WITH data AS MATERIALIZED (
    SELECT * FROM large_table WHERE expensive_filter = true
)
SELECT * FROM data WHERE another_condition = true;


/*============================================================
//TRANSACTION & LOCK ACQUISITION
============================================================*/

-- Locks are acquired when the statement executes, not at BEGIN
-- FOR UPDATE locks are acquired during the FROM/WHERE phase when rows are identified
-- Locks are held until COMMIT or ROLLBACK

BEGIN;
    SELECT * FROM products WHERE id = 42 FOR UPDATE;  -- lock acquired here
    -- other operations
COMMIT;  -- lock released here


/*============================================================
//QUERY PLANNING vs EXECUTION
============================================================*/

-- PostgreSQL query planner optimizes the logical execution order
-- Physical execution may differ from logical order for performance
-- Use EXPLAIN to see the actual execution plan

EXPLAIN SELECT * FROM employees WHERE salary > 80000 ORDER BY hire_date;
-- Shows: Seq Scan, Index Scan, Sort, Hash Join, etc.

EXPLAIN ANALYZE ...  -- actually runs the query and shows real timing