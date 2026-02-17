/* PostgreSQL Query Foundations: 
SELECT, WHERE, ORDER BY, LIMIT/OFFSET, DISTINCT */


/*============================================================
//SELECT & COLUMN EXPRESSIONS 
============================================================*/

SELECT
    first_name,
    last_name,
    salary * 1.1          AS adjusted_salary,   -- alias with AS
    department || ' Dept'  AS dept_label,        -- string concat with || -> "*Name* Dept"
    42                     AS literal_number,
    true                   AS literal_bool
FROM employees;

-- Select all columns (avoid in production queries)
SELECT * FROM employees;

/*============================================================
//WHERE — Filtering Rows
============================================================*/

SELECT * FROM employees
WHERE department = 'Engineering'
  AND salary > 80000
  AND hire_date >= '2020-01-01';

-- Comparison operators: =  !=  <>  <  >  <=  >=

-- BETWEEN (inclusive on both ends)
SELECT * FROM employees WHERE salary BETWEEN 60000 AND 100000;

-- IN / NOT IN
SELECT * FROM employees WHERE department IN ('Engineering', 'Design', 'Product');

-- NULL checks — never use = NULL, always IS NULL / IS NOT NULL
SELECT * FROM employees WHERE manager_id IS NULL;
SELECT * FROM employees WHERE manager_id IS NOT NULL;

-- LIKE / ILIKE (ILIKE is case-insensitive, PostgreSQL-specific)
-- Wildcards: % matches any sequence, _ matches single character
SELECT * FROM employees WHERE email LIKE '%@company.com';
SELECT * FROM employees WHERE first_name ILIKE 'jo%';

-- SIMILAR TO — SQL regex (less common, prefer LIKE or ~ for regex)
SELECT * FROM employees WHERE phone SIMILAR TO '[0-9]{3}-[0-9]{4}';

-- Regex operators (PostgreSQL-specific)
-- ~   case-sensitive match    ~*  case-insensitive match
-- !~  case-sensitive no-match !~* case-insensitive no-match
SELECT * FROM employees WHERE last_name ~ '^[A-M]';


/*============================================================
//ORDER BY
============================================================*/

SELECT * FROM employees
ORDER BY department ASC, salary DESC;
-- ASC is default; NULL values sort last in ASC, first in DESC

-- Control NULL sort position explicitly
SELECT * FROM employees ORDER BY manager_id ASC NULLS LAST;
SELECT * FROM employees ORDER BY manager_id DESC NULLS FIRST;

-- Order by column position (1-indexed) — valid but avoid in production
SELECT first_name, last_name, salary FROM employees ORDER BY 3 DESC;

-- Order by expression
SELECT * FROM employees ORDER BY LENGTH(last_name);


/*============================================================
//LIMIT & OFFSET — Pagination
============================================================*/

SELECT * FROM employees ORDER BY salary DESC LIMIT 10;

-- OFFSET skips rows — use with ORDER BY for stable pagination
SELECT * FROM employees ORDER BY employee_id LIMIT 10 OFFSET 20;  -- page 3

-- FETCH (SQL standard equivalent of LIMIT/OFFSET)
SELECT * FROM employees ORDER BY salary DESC
FETCH FIRST 10 ROWS ONLY;

SELECT * FROM employees ORDER BY salary DESC
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;


/*============================================================
//DISTINCT — Deduplicate Rows
============================================================*/

-- Single column: unique departments
SELECT DISTINCT department FROM employees;

-- Multi-column: unique (department, job_title) combinations
SELECT DISTINCT department, job_title FROM employees ORDER BY department;

-- DISTINCT ON (PostgreSQL-specific) — keep one row per distinct expression
-- Returns the first matching row per group (ORDER BY controls which row)
SELECT DISTINCT ON (department)
    department,
    first_name,
    salary
FROM employees
ORDER BY department, salary DESC;  -- highest earner per department

/*============================================================
//MISCELLANEOUS BASICS
============================================================*/

-- Table aliasing
SELECT e.first_name, e.salary
FROM employees AS e           -- AS is optional: FROM employees e
WHERE e.department = 'Sales';

-- Column aliasing in subquery scope
-- Aliases defined in SELECT are NOT available in WHERE (same query level)
-- Use a subquery or CTE if you need to filter on an alias

-- FETCH without OFFSET (first N rows only)
SELECT * FROM logs ORDER BY created_at DESC FETCH FIRST 1 ROW ONLY;

-- Combining DISTINCT with ORDER BY: ORDER BY columns must appear in SELECT
-- when using DISTINCT
SELECT DISTINCT department FROM employees ORDER BY department;
