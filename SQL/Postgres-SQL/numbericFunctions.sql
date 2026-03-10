/* PostgreSQL Numeric Functions:
Rounding, truncation, absolute value, powers, roots, modulo, random, casting */


/*============================================================
//ROUNDING & TRUNCATION
============================================================*/

SELECT
    ROUND(3.14159, 2),          -- 3.14  — round to n decimal places
    ROUND(3.5),                 -- 4     — round to nearest integer (half rounds up)
    ROUND(salary, -3),          -- round to nearest 1000 (negative scale rounds left of decimal)
    TRUNC(3.9),                 -- 3     — truncate toward zero, no rounding
    TRUNC(3.14159, 2),          -- 3.14  — truncate to n decimal places
    CEIL(3.1),                  -- 4     — ceiling: smallest integer >= value
    CEILING(3.1),               -- 4     — alias for CEIL
    FLOOR(3.9)                  -- 3     — floor: largest integer <= value
FROM employees;

-- ROUND on NUMERIC is exact; ROUND on FLOAT may have floating point imprecision
-- Use NUMERIC(p,s) for financial data, not FLOAT/DOUBLE PRECISION


/*============================================================
//ABSOLUTE VALUE, SIGN, FACTORIAL
============================================================*/

SELECT
    ABS(-42),                   -- 42    — absolute value
    ABS(salary - target),       -- distance between two values regardless of direction
    SIGN(-15),                  -- -1    — returns -1, 0, or 1 based on sign of value
    SIGN(0),                    -- 0
    FACTORIAL(5)                -- 120   — 5! (returns NUMERIC)
FROM employees;


/*============================================================
//POWERS, ROOTS, LOGARITHMS
============================================================*/

SELECT
    POWER(2, 10),               -- 1024  — POWER(base, exponent)
    2 ^ 10,                     -- 1024  — ^ operator, same as POWER
    SQRT(144),                  -- 12.0  — square root
    CBRT(27),                   -- 3.0   — cube root
    EXP(1),                     -- 2.718...  — e raised to the power
    LN(2.718),                  -- ~1.0  — natural log (base e)
    LOG(100),                   -- 2.0   — base-10 logarithm
    LOG(2, 64)                  -- 6.0   — LOG(base, value)
FROM metrics;


/*============================================================
//MODULO & INTEGER DIVISION
============================================================*/

SELECT
    MOD(17, 5),                 -- 2     — remainder of integer division
    17 % 5,                     -- 2     — % operator, same as MOD
    17 / 5,                     -- 3     — integer division when both operands are integers
    17.0 / 5,                   -- 3.4   — float division when at least one is non-integer
    DIV(17, 5)                  -- 3     — integer quotient (truncated toward zero)
FROM orders;

-- Common use: check even/odd, bucket rows, paginate manually
SELECT * FROM products WHERE MOD(product_id, 2) = 0;   -- even IDs only


/*============================================================
//AGGREGATE NUMERIC FUNCTIONS
============================================================*/

-- Covered in 03_aggregations.sql: SUM, AVG, MIN, MAX, STDDEV, VARIANCE
-- Additional statistical aggregates:
SELECT
    CORR(height, weight),               -- Pearson correlation coefficient (-1 to 1)
    COVAR_POP(height, weight),          -- population covariance
    COVAR_SAMP(height, weight),         -- sample covariance
    REGR_SLOPE(y_col, x_col),           -- slope of linear regression line
    REGR_INTERCEPT(y_col, x_col),       -- y-intercept of linear regression line
    REGR_R2(y_col, x_col)               -- R-squared (coefficient of determination)
FROM measurements;


/*============================================================
//RANDOM
============================================================*/

SELECT
    RANDOM(),                           -- random float between 0.0 (inclusive) and 1.0 (exclusive)
    FLOOR(RANDOM() * 100)::INT,         -- random integer 0–99
    FLOOR(RANDOM() * (max - min + 1) + min)::INT  AS in_range;  -- random int between min and max

-- SETSEED — set the random number seed for reproducible results (0.0 to 1.0 or -1.0 to 1.0)
SELECT SETSEED(0.42);
SELECT RANDOM();    -- same value every time after the same seed

-- Random sample of rows
SELECT * FROM employees ORDER BY RANDOM() LIMIT 10;
-- Note: ORDER BY RANDOM() is slow on large tables — use TABLESAMPLE for big datasets
SELECT * FROM employees TABLESAMPLE BERNOULLI(10);  -- ~10% of rows, random sample


/*============================================================
//TYPE CASTING — Converting between numeric and other types
============================================================*/

-- :: operator (PostgreSQL shorthand cast)
SELECT
    '42'::INTEGER,
    '3.14'::NUMERIC,
    '3.14'::FLOAT,
    42::TEXT,
    42::NUMERIC(10,2),
    3.9::INTEGER                -- truncates toward zero: → 3 (does NOT round)
FROM orders;

-- CAST (SQL standard syntax, identical result to ::)
SELECT
    CAST('42' AS INTEGER),
    CAST(salary AS NUMERIC(10,2)),
    CAST(employee_id AS TEXT)
FROM employees;

-- Implicit vs explicit casting
-- PostgreSQL will implicitly cast in some contexts (e.g. INTEGER to NUMERIC in math)
-- but requires explicit cast when types are incompatible or ambiguous

-- Safe cast pattern — avoid errors when input may not be castable
-- PostgreSQL does not have TRY_CAST natively; use a function or CASE + regex
SELECT
    CASE WHEN input ~ '^[0-9]+$' THEN input::INTEGER ELSE NULL END AS safe_int
FROM raw_data;

-- Numeric type hierarchy (implicit promotion order, widest wins in expressions)
-- SMALLINT → INTEGER → BIGINT → NUMERIC → REAL → DOUBLE PRECISION
SELECT 1::SMALLINT + 1::BIGINT;   -- result is BIGINT


/*============================================================
//NUMERIC FORMATTING
============================================================*/

-- TO_CHAR for numbers — format a number as a string with a pattern
-- Pattern codes: 9 = digit (suppressed if zero), 0 = digit (always shown),
--                . decimal point, , thousands separator, $ currency, FM removes padding
SELECT
    TO_CHAR(salary,  'FM$999,999.00'),  -- '$85,000.00'
    TO_CHAR(0.75,    'FM90.00%'),        -- '75.00%' (multiply by 100 first if needed)
    TO_CHAR(1234567, 'FM9,999,999')      -- '1,234,567'
FROM employees;

-- TO_NUMBER — parse a formatted string back to numeric
SELECT TO_NUMBER('1,234.56', '9,999.99');   -- 1234.56


/*============================================================
//INFINITY & NaN — Special float values
============================================================*/

SELECT
    'Infinity'::FLOAT,          -- positive infinity
    '-Infinity'::FLOAT,         -- negative infinity
    'NaN'::FLOAT,               -- not a number (result of undefined operations)
    'Infinity'::NUMERIC,        -- NUMERIC also supports Infinity and NaN
    ISFINITE(salary::FLOAT),    -- true if not infinity and not NaN
    salary::FLOAT = 'NaN'::FLOAT  AS is_nan   -- always false! use IS DISTINCT FROM instead
FROM employees;

-- NaN is not equal to itself — use IS DISTINCT FROM to check
SELECT * FROM metrics WHERE value IS DISTINCT FROM 'NaN'::FLOAT;