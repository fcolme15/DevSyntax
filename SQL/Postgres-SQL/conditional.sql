/* PostgreSQL Conditional Logic & Expressions:
CASE, COALESCE, NULLIF, GREATEST, LEAST, NULL handling, type casting */


/*============================================================
//CASE — Conditional expression, returns a value based on conditions
============================================================*/

-- Searched CASE — each WHEN has its own boolean condition (most flexible)
SELECT
    first_name,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'Senior'
        WHEN salary >= 70000  THEN 'Mid'
        WHEN salary >= 50000  THEN 'Junior'
        ELSE 'Entry'                        -- ELSE is optional; omitting returns NULL if no match
    END AS seniority_band
FROM employees;

-- Simple CASE — compares one expression against a list of values
SELECT
    status,
    CASE status
        WHEN 'pending'   THEN 'Awaiting payment'
        WHEN 'confirmed' THEN 'Payment received'
        WHEN 'shipped'   THEN 'On the way'
        WHEN 'cancelled' THEN 'Order cancelled'
        ELSE 'Unknown status'
    END AS status_label
FROM orders;

-- CASE in ORDER BY — custom sort order that doesn't match alphabetical or numeric
SELECT * FROM orders
ORDER BY
    CASE status
        WHEN 'pending'   THEN 1
        WHEN 'confirmed' THEN 2
        WHEN 'shipped'   THEN 3
        WHEN 'cancelled' THEN 4
        ELSE 5
    END;

-- CASE in aggregation — conditional counting without a WHERE clause
-- More composable than FILTER when you need multiple conditions in one SELECT
SELECT
    COUNT(*)                                                        AS total,
    COUNT(CASE WHEN status = 'confirmed' THEN 1 END)               AS confirmed,
    SUM(CASE WHEN status = 'shipped' THEN total_amount ELSE 0 END) AS shipped_revenue
FROM orders;

-- CASE with NULLs — WHEN NULL never matches in a simple CASE (NULL = NULL is false)
-- Use searched CASE with IS NULL instead
SELECT
    CASE
        WHEN manager_id IS NULL THEN 'No manager'
        ELSE manager_id::TEXT
    END AS manager_display
FROM employees;


/*============================================================
//COALESCE — Return the first non-NULL value from a list of arguments
// Evaluates arguments left to right, stops at first non-NULL
// Equivalent to: CASE WHEN a IS NOT NULL THEN a WHEN b IS NOT NULL THEN b ... END
============================================================*/

-- COALESCE(val1, val2, ..., fallback)
SELECT
    COALESCE(nickname, first_name)                      AS display_name,   -- use nickname if set
    COALESCE(phone, mobile, 'No contact info')          AS contact,
    COALESCE(discount, 0)                               AS discount_rate   -- treat NULL as 0
FROM employees;

-- Common use: replace NULLs before arithmetic (NULL in math always produces NULL)
SELECT order_id, quantity * COALESCE(unit_price, 0) AS line_total FROM order_items;

-- COALESCE vs CASE: COALESCE is shorthand for the NULL-check CASE pattern, prefer it


/*============================================================
//NULLIF — Return NULL if two values are equal, otherwise return the first value
// Inverse of COALESCE — used to convert a specific sentinel value back to NULL
============================================================*/

-- NULLIF(value, sentinel)
SELECT
    NULLIF(division_code, 'N/A'),       -- treat 'N/A' string as NULL
    NULLIF(quantity, 0),                -- prevent division by zero: 100 / NULLIF(quantity, 0)
    NULLIF(status, '')                  -- treat empty string as NULL
FROM orders;

-- Safe division pattern — returns NULL instead of division-by-zero error
SELECT revenue / NULLIF(expenses, 0) AS ratio FROM financials;


/*============================================================
//GREATEST / LEAST — Return the largest or smallest value from a list
// NULL-aware: if any argument is NULL, result is NULL (unlike COALESCE)
============================================================*/

-- GREATEST(val1, val2, ...)
-- LEAST(val1, val2, ...)
SELECT
    GREATEST(q1_sales, q2_sales, q3_sales, q4_sales)   AS best_quarter,
    LEAST(q1_sales, q2_sales, q3_sales, q4_sales)       AS worst_quarter,
    GREATEST(updated_at, created_at)                    AS most_recent_activity,
    GREATEST(0, revenue - costs)                        AS non_negative_profit  -- clamp to zero
FROM financials;

-- GREATEST/LEAST work across different but compatible types
SELECT GREATEST('apple', 'banana', 'cherry');   -- 'cherry' (lexicographic)
SELECT LEAST(1::NUMERIC, 2::INT, 3::BIGINT);    -- 1


/*============================================================
//NULL HANDLING — How NULLs behave in expressions and comparisons
============================================================*/

-- NULL propagates through arithmetic and string operations
SELECT NULL + 1,        -- NULL
       NULL || 'text',  -- NULL (use COALESCE to guard)
       NULL = NULL,     -- NULL (not TRUE — use IS NULL / IS NOT NULL)
       NULL IS NULL,    -- TRUE
       NULL IS NOT NULL;-- FALSE

-- IS DISTINCT FROM — NULL-safe equality check (treats NULL as a comparable value)
-- Returns false when both sides are NULL (unlike = which returns NULL)
SELECT * FROM employees
WHERE manager_id IS DISTINCT FROM 42;      -- includes rows where manager_id IS NULL

SELECT * FROM employees
WHERE manager_id IS NOT DISTINCT FROM NULL; -- finds rows where manager_id IS NULL

-- NULLs in aggregate functions: ignored by SUM, AVG, COUNT(col), etc.
-- COUNT(*) counts all rows; COUNT(col) counts only non-NULL values in col

-- NULLs in ORDER BY: sort position controlled by NULLS FIRST / NULLS LAST
SELECT * FROM employees ORDER BY manager_id NULLS LAST;

-- NULLs in UNIQUE constraints: PostgreSQL treats NULLs as distinct in UNIQUE
-- so multiple NULLs are allowed in a UNIQUE column (each NULL is unique)


/*============================================================
//TYPE CASTING — Converting values from one type to another
============================================================*/

-- :: cast operator (PostgreSQL-specific, shorter syntax)
SELECT
    '2024-01-15'::DATE,
    '42'::INTEGER,
    '3.14'::NUMERIC,
    42::TEXT,
    true::INTEGER,          -- 1
    false::INTEGER,         -- 0
    1::BOOLEAN,             -- true
    0::BOOLEAN              -- false
FROM orders LIMIT 1;

-- CAST() — SQL standard syntax, identical result to ::
SELECT
    CAST('42' AS INTEGER),
    CAST(hire_date AS TEXT),
    CAST(salary AS NUMERIC(10,2))
FROM employees;

-- Casting in expressions — required when PostgreSQL can't infer the type
SELECT '2024-01-01'::DATE + INTERVAL '1 month';        -- works: DATE + INTERVAL
SELECT EXTRACT(year FROM '2024-06-15'::DATE);           -- explicit cast for string literal

-- Integer division vs float division — casting changes behavior
SELECT 7 / 2,           -- 3    (integer division — decimal is truncated)
       7 / 2.0,         -- 3.5  (one float operand forces float division)
       7::FLOAT / 2,    -- 3.5  (cast one operand)
       7 / 2::NUMERIC;  -- 3.5

-- Text to number casting — fails if string is not a valid number
-- Use REGEXP or CASE to validate first (PostgreSQL has no native TRY_CAST)
SELECT CASE WHEN raw ~ '^\d+(\.\d+)?$' THEN raw::NUMERIC ELSE NULL END FROM imports;


/*============================================================
//CONDITIONAL EXPRESSIONS IN WHERE & HAVING
============================================================*/

-- CASE in WHERE — rarely needed but valid when logic is complex
SELECT * FROM orders
WHERE CASE
    WHEN customer_type = 'VIP' THEN total > 100
    ELSE total > 500
END;

-- Short-circuit evaluation: PostgreSQL evaluates CASE/COALESCE lazily
-- COALESCE stops at first non-NULL, so later args are not evaluated if earlier ones match
-- CASE stops evaluating WHEN clauses once a match is found