/* PostgreSQL Subqueries & CTEs:
Scalar, column, row, table subqueries, EXISTS, WITH/CTE, recursive CTEs */


/*============================================================
//SUBQUERY TYPES — Making new tables or cols to use in queries
============================================================*/

-- Scalar subquery — appears in SELECT or WHERE, must return exactly one row, one column
-- Column subquery — appears in WHERE with IN/ANY/ALL, returns one column, many rows
-- Row subquery    — appears in WHERE, returns one row, multiple columns
-- Table subquery  — appears in FROM, returns a full result set (must be aliased)


/*============================================================
//SCALAR SUBQUERY — Returns a single value, used inline as an expression
============================================================*/

-- In SELECT: compute a value alongside each row
SELECT
    first_name,
    salary,
    salary - (SELECT AVG(salary) FROM employees) AS diff_from_avg  -- runs once, same value every row
FROM employees;

-- In WHERE: compare against a single computed value
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- In WHERE with a different table: correlated scalar subquery re-runs per outer row
SELECT first_name, department_id
FROM employees AS e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id  -- references outer row's department_id
);


/*============================================================
//COLUMN SUBQUERY — Returns one column, many rows — used with IN, ANY, ALL
============================================================*/

-- IN: row matches if its value appears anywhere in the subquery result
SELECT * FROM employees
WHERE department_id IN (
    SELECT id FROM departments WHERE location = 'New York'
);

-- NOT IN: row matches if its value appears NOWHERE in the subquery result
-- Caution: if the subquery returns any NULL, NOT IN returns no rows at all
-- because NULL comparisons are never definitively false — prefer NOT EXISTS instead
SELECT * FROM employees
WHERE department_id NOT IN (
    SELECT id FROM departments WHERE is_active = false
);

-- ANY: row matches if the comparison is true for at least one value in the subquery
-- = ANY is equivalent to IN
SELECT * FROM products
WHERE price > ANY (SELECT price FROM products WHERE category = 'Budget');

-- ALL: row matches if the comparison is true for every value in the subquery
SELECT * FROM products
WHERE price > ALL (SELECT price FROM products WHERE category = 'Budget');


/*============================================================
//ROW SUBQUERY — Compares against a full row tuple
============================================================*/

-- Compare multiple columns at once as a tuple
SELECT * FROM employees
WHERE (department_id, job_title) = (
    SELECT department_id, job_title
    FROM employees
    WHERE employee_id = 42
);


/*============================================================
//TABLE SUBQUERY — Appears in FROM, treated as a derived table
// Must always be aliased
============================================================*/

SELECT dept_summary.department_id, dept_summary.avg_salary
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_summary
WHERE dept_summary.avg_salary > 70000;

-- Subquery in FROM lets you filter on aggregate results without a CTE
-- Equivalent to using HAVING, but useful when you need to join the aggregated result


/*============================================================
//EXISTS / NOT EXISTS — Test whether a subquery returns any rows at all
// More efficient than IN for large datasets — stops scanning on first match
// Safe with NULLs — avoids the NOT IN / NULL trap
============================================================*/

-- EXISTS: true if the subquery returns at least one row
SELECT * FROM departments AS d
WHERE EXISTS (
    SELECT 1              -- SELECT 1 is conventional — the value doesn't matter, only row existence
    FROM employees AS e
    WHERE e.department_id = d.id
);

-- NOT EXISTS: true if the subquery returns zero rows
-- Preferred over NOT IN when NULLs may be present
SELECT * FROM departments AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees AS e
    WHERE e.department_id = d.id
);

-- Correlated EXISTS: subquery references the outer query's row on each iteration
SELECT * FROM orders AS o
WHERE EXISTS (
    SELECT 1
    FROM order_items AS oi
    WHERE oi.order_id = o.order_id
      AND oi.quantity > 10
);


/*============================================================
//WITH / CTE — Common Table Expression
// Named subquery defined before the main query, improves readability
// Referenced by name like a temporary table, scoped to the single query
============================================================*/

WITH high_earners AS (
    SELECT employee_id, first_name, salary, department_id
    FROM employees
    WHERE salary > 90000
)
SELECT h.first_name, d.department_name
FROM high_earners AS h
JOIN departments  AS d ON h.department_id = d.id;

-- Multiple CTEs — chain them with commas, later CTEs can reference earlier ones
WITH
dept_totals AS (
    SELECT department_id, SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
),
dept_ranks AS (
    SELECT department_id, total_salary,
           RANK() OVER (ORDER BY total_salary DESC) AS salary_rank
    FROM dept_totals       -- references the first CTE
)
SELECT d.department_name, dr.total_salary, dr.salary_rank
FROM dept_ranks    AS dr
JOIN departments   AS d ON dr.department_id = d.id;

-- CTEs vs subqueries: CTEs are not inherently faster — PostgreSQL may inline them
-- Use CTEs for readability; use MATERIALIZED to force independent execution
WITH expensive_calc AS MATERIALIZED (
    SELECT * FROM large_table WHERE complex_condition = true
)
SELECT * FROM expensive_calc WHERE another_filter = true;


/*============================================================
//RECURSIVE CTE — Query hierarchical or graph data iteratively
// WITH RECURSIVE keeps re-running the recursive term until no new rows are produced
============================================================*/

-- Structure: anchor term UNION ALL recursive term
-- Anchor term   — base case, runs once, produces starting rows
-- Recursive term — references the CTE by name, joins against anchor/previous result
-- Terminates    — when the recursive term returns zero new rows

-- Walk an employee → manager hierarchy upward from a starting employee
WITH RECURSIVE org_chain AS (
    -- Anchor: start with one specific employee
    SELECT employee_id, first_name, manager_id, 1 AS depth
    FROM employees
    WHERE employee_id = 42

    UNION ALL

    -- Recursive: join each row's manager_id to find the next level up
    SELECT e.employee_id, e.first_name, e.manager_id, oc.depth + 1
    FROM employees    AS e
    JOIN org_chain    AS oc ON e.employee_id = oc.manager_id  -- walk up one level per iteration
)
SELECT * FROM org_chain ORDER BY depth;

-- CYCLE detection — prevent infinite loops in graph data with cycles
WITH RECURSIVE traversal AS (
    SELECT node_id, neighbor_id, ARRAY[node_id] AS visited
    FROM graph
    WHERE node_id = 1

    UNION ALL

    SELECT g.node_id, g.neighbor_id, t.visited || g.node_id
    FROM graph        AS g
    JOIN traversal    AS t ON g.node_id = t.neighbor_id
    WHERE g.node_id <> ALL(t.visited)   -- stop if we've already visited this node
)
SELECT * FROM traversal;

-- PostgreSQL 14+: built-in CYCLE clause handles cycle detection automatically
WITH RECURSIVE traversal AS (
    SELECT node_id, neighbor_id FROM graph WHERE node_id = 1
    UNION ALL
    SELECT g.node_id, g.neighbor_id
    FROM graph AS g JOIN traversal AS t ON g.node_id = t.neighbor_id
)
CYCLE node_id SET is_cycle USING path   -- is_cycle column becomes true when a cycle is detected
SELECT * FROM traversal WHERE NOT is_cycle;