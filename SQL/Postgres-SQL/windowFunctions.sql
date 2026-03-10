/* PostgreSQL Window Functions:
ROW_NUMBER, RANK, DENSE_RANK, NTILE, LAG, LEAD, FIRST_VALUE, LAST_VALUE,
NTH_VALUE, PARTITION BY, ORDER BY, frame clauses */


/*============================================================
//WINDOW FUNCTION BASICS — Compute across a set of rows related to the current row
// Unlike aggregates, window functions do NOT collapse rows — every input row gets an output row
============================================================*/

-- General syntax: function(...) OVER (window_definition)
-- window_definition can include: PARTITION BY, ORDER BY, and frame clause

SELECT
    first_name,
    salary,
    department_id,
    AVG(salary) OVER ()                                AS company_avg,        -- no PARTITION = entire table
    AVG(salary) OVER (PARTITION BY department_id)      AS dept_avg,           -- per-department average
    salary - AVG(salary) OVER (PARTITION BY department_id) AS diff_from_dept_avg
FROM employees;


/*============================================================
//PARTITION BY — Divide rows into groups (like GROUP BY but doesn't collapse rows)
// Window function runs independently within each partition
============================================================*/

SELECT
    department_id,
    first_name,
    salary,
    AVG(salary) OVER (PARTITION BY department_id)      AS dept_avg,
    MAX(salary) OVER (PARTITION BY department_id)      AS dept_max,
    COUNT(*)    OVER (PARTITION BY department_id)      AS dept_headcount
FROM employees;

-- Multiple PARTITION BY columns — creates finer-grained partitions
SELECT
    department_id,
    job_title,
    salary,
    AVG(salary) OVER (PARTITION BY department_id, job_title) AS role_avg
FROM employees;


/*============================================================
//ORDER BY within window — Controls the ordering of rows within each partition
// Required for ranking and offset functions (ROW_NUMBER, RANK, LAG, LEAD)
============================================================*/

SELECT
    department_id,
    first_name,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank_in_dept
FROM employees;

-- ORDER BY affects the frame — which rows the window function "sees" for each row
-- Without ORDER BY: window sees all rows in the partition
-- With ORDER BY: window sees rows from partition start up to current row (RANGE UNBOUNDED PRECEDING)


/*============================================================
//ROW_NUMBER — Assign a unique sequential integer to each row within a partition
// Always unique even when ORDER BY values are tied (arbitrary tie-breaking)
============================================================*/

SELECT
    ROW_NUMBER() OVER (ORDER BY salary DESC)                    AS overall_rank,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_rank,
    first_name,
    salary
FROM employees;

-- Common pattern: top N per group using ROW_NUMBER in a subquery
SELECT * FROM (
    SELECT
        department_id,
        first_name,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
) AS ranked
WHERE rn <= 3;   -- top 3 earners per department


/*============================================================
//RANK / DENSE_RANK — Assign rank with tie handling
// RANK: ties get the same rank, next rank skips (1, 2, 2, 4)
// DENSE_RANK: ties get the same rank, next rank is consecutive (1, 2, 2, 3)
============================================================*/

SELECT
    first_name,
    salary,
    RANK()       OVER (ORDER BY salary DESC) AS rank_with_gaps,     -- 1, 2, 2, 4, 5
    DENSE_RANK() OVER (ORDER BY salary DESC) AS rank_no_gaps,       -- 1, 2, 2, 3, 4
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS unique_row_num      -- 1, 2, 3, 4, 5 (breaks ties arbitrarily)
FROM employees;


/*============================================================
//NTILE — Divide rows into N roughly equal buckets (quartiles, percentiles, etc.)
// Useful for splitting data into top/middle/bottom groups
============================================================*/

SELECT
    first_name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile,  -- 1=top 25%, 2=next 25%, etc.
    NTILE(10) OVER (ORDER BY salary DESC) AS salary_decile,
    NTILE(100) OVER (ORDER BY salary DESC) AS salary_percentile
FROM employees;

-- Buckets may differ in size by 1 row if rows don't divide evenly


/*============================================================
//LAG / LEAD — Access values from previous or next rows within the partition
// LAG looks backward, LEAD looks forward
// Useful for computing deltas, streaks, or detecting changes
============================================================*/

-- LAG(column, offset, default) OVER (...)
-- offset: how many rows back (default 1)
-- default: value to return when there is no previous row (default NULL)

SELECT
    order_date,
    total_amount,
    LAG(total_amount, 1) OVER (ORDER BY order_date)           AS prev_order_amount,
    total_amount - LAG(total_amount, 1) OVER (ORDER BY order_date) AS amount_change,
    LEAD(order_date, 1) OVER (ORDER BY order_date)            AS next_order_date,
    order_date - LAG(order_date, 1) OVER (ORDER BY order_date) AS days_since_prev_order
FROM orders;

-- LAG with partition — look back within each group independently
SELECT
    customer_id,
    order_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_by_customer
FROM orders;


/*============================================================
//FIRST_VALUE / LAST_VALUE — Access the first or last value in the window frame
// Frame matters: by default LAST_VALUE only sees up to current row, not the actual last
============================================================*/

SELECT
    department_id,
    first_name,
    salary,
    FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary DESC) AS highest_salary,
    LAST_VALUE(salary)  OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING   -- extend frame to entire partition
    ) AS lowest_salary
FROM employees;

-- Without the frame clause, LAST_VALUE sees only up to the current row due to default frame
-- Default frame with ORDER BY: RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW


/*============================================================
//NTH_VALUE — Access the Nth row's value within the window frame
// NTH_VALUE(column, N) — 1-indexed, N=1 is the first row
============================================================*/

SELECT
    department_id,
    first_name,
    salary,
    NTH_VALUE(salary, 2) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS second_highest_salary
FROM employees;


/*============================================================
//FRAME CLAUSES — Control which rows the window function "sees" for each row
// Syntax: ROWS/RANGE BETWEEN frame_start AND frame_end
// frame_start / frame_end: UNBOUNDED PRECEDING, N PRECEDING, CURRENT ROW, N FOLLOWING, UNBOUNDED FOLLOWING
============================================================*/

-- ROWS vs RANGE:
-- ROWS: physical offset (count actual rows)
-- RANGE: logical offset (based on ORDER BY value — includes ties)

-- Moving average: last 3 rows including current
SELECT
    order_date,
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3day
FROM orders;

-- Running total: all rows from start to current
SELECT
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders;

-- Centered window: 1 before, current, 1 after
SELECT
    day,
    temperature,
    AVG(temperature) OVER (
        ORDER BY day
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS smoothed_temp
FROM weather;

-- RANGE example: include all rows with the same ORDER BY value
SELECT
    salary,
    COUNT(*) OVER (
        ORDER BY salary
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS count_up_to_this_salary
FROM employees;

-- Default frames:
-- No ORDER BY: entire partition (UNBOUNDED PRECEDING TO UNBOUNDED FOLLOWING)
-- With ORDER BY: start of partition to current row (UNBOUNDED PRECEDING TO CURRENT ROW)


/*============================================================
//NAMED WINDOWS — Define a window once, reuse it multiple times
// Improves readability when multiple functions use the same window definition
============================================================*/

SELECT
    department_id,
    first_name,
    salary,
    AVG(salary)  OVER w AS dept_avg,
    MAX(salary)  OVER w AS dept_max,
    RANK()       OVER w AS dept_rank
FROM employees
WINDOW w AS (PARTITION BY department_id ORDER BY salary DESC);

-- Can reference and extend a named window
SELECT
    first_name,
    salary,
    RANK() OVER w,
    LAG(salary) OVER (w ORDER BY hire_date)   -- extends base window w with additional ORDER BY
FROM employees
WINDOW w AS (PARTITION BY department_id);