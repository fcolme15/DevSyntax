/* PostgreSQL Joins & Result Set Combinations:
INNER, LEFT, RIGHT, FULL, CROSS, SELF joins, UNION, INTERSECT, EXCEPT */


/*============================================================
//JOIN SYNTAX — General Form
============================================================*/

-- Explicit JOIN (always prefer over implicit comma-separated FROM)
SELECT e.first_name, d.department_name
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id;

-- USING — shorthand when the join column name is identical in both tables
-- merges the column into one in output (no e.department_id vs d.department_id ambiguity)
SELECT e.first_name, d.department_name
FROM employees AS e
JOIN departments AS d USING (department_id);

-- NATURAL JOIN — auto-joins on ALL identically named columns (fragile, avoid in production)
SELECT * FROM employees NATURAL JOIN departments;


/*============================================================
//INNER JOIN — Only rows with a match on both sides
============================================================*/

-- Rows with no match on either side are excluded entirely
-- INNER is the default keyword — JOIN alone means INNER JOIN
SELECT
    e.employee_id,
    e.first_name,
    d.department_name,
    l.city
FROM employees   AS e
INNER JOIN departments AS d ON e.department_id = d.id
INNER JOIN locations   AS l ON d.location_id   = l.id;


/*============================================================
//LEFT JOIN — All rows from left table, matched rows from right
// Unmatched right-side columns come back as NULL
============================================================*/

SELECT
    e.first_name,
    d.department_name   -- NULL for employees with no matching department
FROM employees   AS e
LEFT JOIN departments AS d ON e.department_id = d.id;

-- Anti-join pattern: find rows with NO match on the right side
-- Works because unmatched rows produce NULL on the right, then WHERE filters to only those
SELECT e.*
FROM employees   AS e
LEFT JOIN departments AS d ON e.department_id = d.id
WHERE d.id IS NULL;


/*============================================================
//RIGHT JOIN — All rows from right table, matched rows from left
// Unmatched left-side columns come back as NULL
============================================================*/

-- Semantically identical to swapping table order and using LEFT JOIN
-- Most teams standardize on LEFT JOIN for consistency
SELECT
    e.first_name,       -- NULL for departments that have no employees
    d.department_name
FROM employees   AS e
RIGHT JOIN departments AS d ON e.department_id = d.id;


/*============================================================
//FULL OUTER JOIN — All rows from both sides
// NULLs fill in wherever there is no match on either side
============================================================*/

SELECT
    e.first_name,
    d.department_name
FROM employees   AS e
FULL OUTER JOIN departments AS d ON e.department_id = d.id;

-- Full outer anti-join: rows that had no match on EITHER side
SELECT e.first_name, d.department_name
FROM employees   AS e
FULL OUTER JOIN departments AS d ON e.department_id = d.id
WHERE e.employee_id IS NULL OR d.id IS NULL;


/*============================================================
//CROSS JOIN — Cartesian product, every row paired with every row
// Produces M × N rows, no ON clause
============================================================*/

SELECT
    sizes.label  AS size,
    colors.label AS color
FROM sizes
CROSS JOIN colors;

-- Useful for generating all combinations, e.g. every product paired with every other
SELECT a.product_id, b.product_id AS paired_with
FROM products AS a
CROSS JOIN products AS b
WHERE a.product_id < b.product_id;  -- < avoids self-pairs and duplicate reversed pairs


/*============================================================
//SELF JOIN — A table joined to itself
// Both sides must be aliased differently to distinguish columns
============================================================*/

-- Traverse a parent-child hierarchy stored in the same table
-- LEFT JOIN used so root-level rows (no manager) still appear with NULL manager
SELECT
    e.first_name AS employee,
    m.first_name AS manager
FROM employees AS e
LEFT JOIN employees AS m ON e.manager_id = m.employee_id;

-- Find all pairs of employees in the same department
-- a.id < b.id prevents (Alice, Bob) and (Bob, Alice) both appearing
SELECT
    a.first_name AS employee_1,
    b.first_name AS employee_2,
    a.department
FROM employees AS a
JOIN employees AS b
  ON a.department  = b.department
 AND a.employee_id < b.employee_id;


/*============================================================
//ON vs WHERE — Critical distinction for outer joins
============================================================*/

-- ON filters BEFORE the join — controls which rows are candidates for matching
-- WHERE filters AFTER the join — can silently convert an OUTER join into an INNER join

-- This LEFT JOIN behaves like an INNER JOIN because WHERE discards the NULL rows
SELECT e.first_name, d.department_name
FROM employees   AS e
LEFT JOIN departments AS d ON e.department_id = d.id
WHERE d.department_name = 'Engineering';   -- NULLs eliminated post-join

-- Correct approach: put the restriction in ON so unmatched employees still appear
SELECT e.first_name, d.department_name   -- NULL for non-Engineering employees
FROM employees   AS e
LEFT JOIN departments AS d
  ON e.department_id   = d.id
 AND d.department_name = 'Engineering';


/*============================================================
//MULTI-CONDITION & NON-EQUI JOINS
============================================================*/

-- Multiple ON conditions — all must be satisfied for a row to match
SELECT o.order_id, p.promotion_name
FROM orders     AS o
JOIN promotions AS p
  ON o.customer_id = p.customer_id
 AND o.order_date BETWEEN p.start_date AND p.end_date;

-- Non-equi join — join on a range or inequality instead of equality
-- Each employee is matched to whichever salary grade bracket their salary falls in
SELECT
    e.first_name,
    e.salary,
    sg.grade_label
FROM employees     AS e
JOIN salary_grades AS sg
  ON e.salary BETWEEN sg.min_salary AND sg.max_salary;


/*============================================================
//LATERAL JOIN — Correlated subquery evaluated per row of the left table
// Right side can reference columns from the left side (regular subqueries cannot)
============================================================*/

-- ON true is required syntax when the subquery itself handles the match condition
-- Use LEFT JOIN LATERAL to preserve left-side rows even when subquery returns nothing
SELECT
    d.department_name,
    top_earner.first_name,
    top_earner.salary
FROM departments AS d
JOIN LATERAL (
    SELECT first_name, salary
    FROM employees
    WHERE department_id = d.id   -- references d.id from the outer left side
    ORDER BY salary DESC
    LIMIT 1
) AS top_earner ON true;


/*============================================================
//UNION — Combine result sets vertically
// All set operations require matching column count and compatible types
// Column names in output come from the first SELECT
============================================================*/

-- UNION removes duplicates across both result sets (adds a dedup step)
SELECT first_name, last_name FROM employees
UNION
SELECT first_name, last_name FROM contractors;

-- UNION ALL keeps all rows including duplicates (faster — no dedup step)
SELECT product_id FROM orders_2023
UNION ALL
SELECT product_id FROM orders_2024;


/*============================================================
//INTERSECT — Rows that appear in BOTH result sets
============================================================*/

-- INTERSECT removes duplicates in the output
SELECT customer_id FROM orders_2023
INTERSECT
SELECT customer_id FROM orders_2024;

-- INTERSECT ALL preserves duplicate rows proportionally across both sets
SELECT product_id FROM warehouse_a
INTERSECT ALL
SELECT product_id FROM warehouse_b;


/*============================================================
//EXCEPT — Rows in the first set that do NOT appear in the second set
============================================================*/

-- EXCEPT removes duplicates in the output
SELECT customer_id FROM customers
EXCEPT
SELECT customer_id FROM orders;   -- customers who have never placed an order

-- EXCEPT ALL preserves duplicates — subtracts occurrences one-for-one
SELECT product_id FROM catalog
EXCEPT ALL
SELECT product_id FROM discontinued;

-- Chaining set operations — INTERSECT binds tighter than UNION/EXCEPT without parens
-- Use parentheses to make precedence explicit
(SELECT id FROM table_a UNION SELECT id FROM table_b)
EXCEPT
SELECT id FROM table_c;


/*============================================================
//JOINING AGGREGATES — Pre-aggregate before joining to avoid row explosion
============================================================*/

-- Joining a raw table to an aggregate subquery is safer than aggregating after joining
-- because joining first can multiply rows before GROUP BY collapses them
SELECT
    d.department_name,
    agg.headcount,
    agg.avg_salary
FROM departments AS d
JOIN (
    SELECT
        department_id,
        COUNT(*)    AS headcount,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS agg ON d.id = agg.department_id;