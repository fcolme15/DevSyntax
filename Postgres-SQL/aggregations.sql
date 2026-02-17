/* PostgreSQL Aggregations & Grouping:
COUNT, SUM, AVG, MIN, MAX, STRING_AGG, ARRAY_AGG, GROUP BY, HAVING, FILTER, ROLLUP, CUBE */


/*============================================================
//AGGREGATE FUNCTIONS — Collapse multiple rows into a single value
============================================================*/

SELECT
    COUNT(*)                AS total_rows,        -- counts all rows including NULLs
    COUNT(manager_id)       AS non_null_managers, -- counts only non-NULL values
    COUNT(DISTINCT dept_id) AS unique_depts,      -- counts distinct non-NULL values
    SUM(salary)             AS total_payroll,
    AVG(salary)             AS mean_salary,
    MIN(salary)             AS lowest_salary,
    MAX(salary)             AS highest_salary,
    STDDEV(salary)          AS salary_stddev,      -- population: STDDEV_POP, sample: STDDEV_SAMP
    VARIANCE(salary)        AS salary_variance     -- population: VAR_POP, sample: VAR_SAMP
FROM employees;

-- Aggregates ignore NULL values in all functions except COUNT(*)


/*============================================================
//STRING_AGG — Concatenate values from multiple rows into one string
// STRING_AGG(expression, delimiter)
============================================================*/

-- Produces a single comma-separated string of all employee names per department
SELECT
    department_id,
    STRING_AGG(first_name, ', ')                    AS names,
    STRING_AGG(first_name, ', ' ORDER BY first_name) AS names_sorted  -- ORDER BY controls concat order
FROM employees
GROUP BY department_id;


/*============================================================
//ARRAY_AGG — Collect values from multiple rows into a PostgreSQL array
============================================================*/

SELECT
    department_id,
    ARRAY_AGG(salary)                    AS all_salaries,
    ARRAY_AGG(salary ORDER BY salary)    AS sorted_salaries,
    ARRAY_AGG(DISTINCT salary)           AS unique_salaries  -- deduplicate before collecting
FROM employees
GROUP BY department_id;


/*============================================================
//JSON_AGG / JSONB_AGG — Collect rows into a JSON array
// Each row becomes a JSON object element in the array
============================================================*/

SELECT
    department_id,
    JSON_AGG(first_name)                          AS names_json,
    JSON_AGG(row_to_json(employees))              AS full_rows_json,  -- entire row as JSON object
    JSONB_AGG(first_name ORDER BY first_name)     AS names_jsonb_sorted
FROM employees
GROUP BY department_id;


/*============================================================
//BOOL_AND / BOOL_OR — Aggregate boolean columns across rows
============================================================*/

SELECT
    department_id,
    BOOL_AND(is_active)   AS all_active,   -- true only if every row is true
    BOOL_OR(is_active)    AS any_active    -- true if at least one row is true
FROM employees
GROUP BY department_id;


/*============================================================
//GROUP BY — Split rows into groups, aggregate applies per group
============================================================*/

SELECT department_id, COUNT(*) AS headcount
FROM employees
GROUP BY department_id;

-- Group by multiple columns — one result row per unique combination
SELECT department_id, job_title, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id, job_title;

-- GROUP BY with expression — group on computed value, not raw column
SELECT DATE_TRUNC('month', hire_date) AS hire_month, COUNT(*) AS hires
FROM employees
GROUP BY DATE_TRUNC('month', hire_date);

-- Columns in SELECT must either be in GROUP BY or wrapped in an aggregate function
-- This is invalid: SELECT department_id, first_name, COUNT(*) FROM employees GROUP BY department_id
-- first_name is neither grouped nor aggregated


/*============================================================
//HAVING — Filter groups after aggregation (WHERE filters rows before aggregation)
============================================================*/

-- WHERE runs before GROUP BY (filters individual rows)
-- HAVING runs after GROUP BY (filters entire groups based on aggregate result)
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
WHERE is_active = true               -- row-level filter: exclude inactive before grouping
GROUP BY department_id
HAVING AVG(salary) > 75000;          -- group-level filter: only groups where avg salary qualifies

-- HAVING can reference the aggregate expression directly (not the alias)
SELECT department_id, COUNT(*) AS headcount
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 5;


/*============================================================
//FILTER — Apply a condition to a specific aggregate only
// Cleaner than CASE inside an aggregate for conditional counting/summing
============================================================*/

SELECT
    department_id,
    COUNT(*)                                    AS total,
    COUNT(*) FILTER (WHERE salary > 80000)      AS high_earners,     -- counts only rows matching condition
    AVG(salary) FILTER (WHERE is_active = true) AS avg_active_salary,
    SUM(salary) FILTER (WHERE hire_date >= '2023-01-01') AS new_hire_payroll
FROM employees
GROUP BY department_id;


/*============================================================
//ROLLUP — GROUP BY with subtotals and a grand total
// Generates grouping sets from left to right, dropping one level at a time
============================================================*/

-- Produces rows for: (department, job_title), (department), ()
-- NULL in a ROLLUP column means that column was rolled up (subtotal/grand total row)
SELECT
    department_id,
    job_title,
    SUM(salary) AS total_salary
FROM employees
GROUP BY ROLLUP(department_id, job_title)
ORDER BY department_id NULLS LAST, job_title NULLS LAST;


/*============================================================
//CUBE — GROUP BY with all possible subtotal combinations
// Every combination of the listed columns gets its own subtotal row
============================================================*/

-- Produces rows for: (department, job_title), (department), (job_title), ()
-- More combinations than ROLLUP — grows exponentially with column count
SELECT
    department_id,
    job_title,
    SUM(salary) AS total_salary
FROM employees
GROUP BY CUBE(department_id, job_title);


/*============================================================
//GROUPING SETS — Explicit control over which combinations to aggregate
// ROLLUP and CUBE are shorthand for common GROUPING SETS patterns
============================================================*/

-- Manually specify exactly which groupings you want
SELECT
    department_id,
    job_title,
    SUM(salary) AS total_salary
FROM employees
GROUP BY GROUPING SETS (
    (department_id, job_title),   -- combination
    (department_id),              -- department subtotal
    ()                            -- grand total
);

-- GROUPING() function — returns 1 if that column was rolled up in this row, 0 if not
-- Useful for distinguishing a NULL rollup row from a genuine NULL value in data
SELECT
    department_id,
    job_title,
    SUM(salary)             AS total_salary,
    GROUPING(department_id) AS dept_is_rolled_up,   -- 1 on subtotal/grand total rows
    GROUPING(job_title)     AS title_is_rolled_up
FROM employees
GROUP BY ROLLUP(department_id, job_title);