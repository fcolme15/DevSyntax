/* PostgreSQL Data Manipulation Language:
INSERT, UPDATE, DELETE, UPSERT (ON CONFLICT), TRUNCATE, RETURNING */


/*============================================================
//INSERT — Add rows to a table
============================================================*/

-- Single row
INSERT INTO employees (first_name, last_name, salary, department_id)
VALUES ('Francisco', 'Reyes', 85000, 3);

-- Multiple rows in one statement (more efficient than multiple single inserts)
INSERT INTO employees (first_name, last_name, salary, department_id)
VALUES
    ('Alice',   'Chen',    92000, 1),
    ('Bob',     'Martin',  78000, 2),
    ('Carmen',  'Lopez',   88000, 1);

-- Insert from a SELECT result — column count and types must match
INSERT INTO employees_archive (first_name, last_name, salary, department_id)
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE termination_date IS NOT NULL;

-- Insert with DEFAULT — explicitly use column default instead of providing a value
INSERT INTO employees (first_name, last_name, salary, hire_date)
VALUES ('Dana', 'Kim', 75000, DEFAULT);   -- hire_date uses its table default

-- Insert all defaults (only works if all columns have defaults or are nullable)
INSERT INTO audit_log DEFAULT VALUES;


/*============================================================
//RETURNING — Return data from rows affected by INSERT, UPDATE, or DELETE
// Eliminates the need for a separate SELECT after a write operation
============================================================*/

-- Return the auto-generated ID after insert
INSERT INTO employees (first_name, last_name, salary)
VALUES ('Elena', 'Vasquez', 91000)
RETURNING employee_id;

-- Return multiple columns or the entire inserted row
INSERT INTO employees (first_name, last_name, salary, department_id)
VALUES ('Jin', 'Park', 83000, 2)
RETURNING employee_id, first_name, hire_date;   -- hire_date shows the default that was applied

-- Use RETURNING with UPDATE and DELETE the same way
-- RETURNING * returns all columns of the affected rows


/*============================================================
//UPDATE — Modify existing rows
============================================================*/

-- Basic update with WHERE (always include WHERE unless updating all rows intentionally)
UPDATE employees
SET salary = 95000
WHERE employee_id = 42;

-- Update multiple columns at once
UPDATE employees
SET
    salary      = salary * 1.1,       -- increase by 10%
    job_title   = 'Senior Engineer',
    updated_at  = NOW()
WHERE department_id = 1 AND years_experience >= 3;

-- Update using a subquery in SET — compute the new value from another table
UPDATE employees AS e
SET salary = (
    SELECT AVG(salary) * 1.05
    FROM employees
    WHERE department_id = e.department_id
)
WHERE performance_rating = 'Exceeds';

-- UPDATE with FROM — join another table to drive the update (PostgreSQL-specific syntax)
-- More readable than a correlated subquery when updating from another table
UPDATE employees AS e
SET salary = e.salary * b.raise_multiplier
FROM salary_adjustments AS b             -- b is joined to drive the update values
WHERE e.department_id = b.department_id
  AND b.fiscal_year = 2024;

UPDATE employees AS e
SET department_id = d.id
FROM departments AS d
WHERE d.department_name = 'Engineering'
  AND e.job_title ILIKE '%engineer%';


/*============================================================
//DELETE — Remove rows from a table
============================================================*/

-- Delete with condition
DELETE FROM employees
WHERE termination_date < NOW() - INTERVAL '1 year';

-- Delete all rows (slower than TRUNCATE, but respects triggers and RETURNING)
DELETE FROM temp_imports;

-- DELETE with USING — join another table to identify which rows to delete (PostgreSQL-specific)
-- Equivalent to UPDATE...FROM but for deletes
DELETE FROM order_items AS oi
USING orders AS o
WHERE oi.order_id = o.order_id
  AND o.status = 'cancelled';

-- Delete returning the removed rows
DELETE FROM employees
WHERE department_id = 7
RETURNING employee_id, first_name;


/*============================================================
//TRUNCATE — Remove all rows from a table, much faster than DELETE
// Cannot be used with WHERE — always removes everything
// Does not fire row-level triggers, resets sequences if RESTART IDENTITY used
============================================================*/

TRUNCATE TABLE temp_imports;

-- Truncate and reset the auto-increment sequence back to 1
TRUNCATE TABLE temp_imports RESTART IDENTITY;

-- Truncate multiple tables at once
TRUNCATE TABLE temp_imports, staging_data, load_errors;

-- CASCADE: also truncates tables that have foreign keys pointing to this table
TRUNCATE TABLE departments CASCADE;


/*============================================================
//UPSERT — Insert or update depending on whether a conflict exists
// ON CONFLICT handles duplicate key violations gracefully
============================================================*/

-- DO NOTHING: silently skip the insert if the row already exists
INSERT INTO employees (employee_id, first_name, salary)
VALUES (42, 'Francisco', 90000)
ON CONFLICT (employee_id) DO NOTHING;

-- DO UPDATE: update the existing row when a conflict occurs
-- EXCLUDED refers to the row that was proposed for insert but conflicted
INSERT INTO employees (employee_id, first_name, salary)
VALUES (42, 'Francisco', 90000)
ON CONFLICT (employee_id) DO UPDATE
SET
    first_name = EXCLUDED.first_name,   -- EXCLUDED holds the values from the attempted INSERT
    salary     = EXCLUDED.salary,
    updated_at = NOW();

-- Conditional upsert — only update if a condition is met
INSERT INTO product_prices (product_id, price, updated_at)
VALUES (101, 29.99, NOW())
ON CONFLICT (product_id) DO UPDATE
SET
    price      = EXCLUDED.price,
    updated_at = EXCLUDED.updated_at
WHERE product_prices.price <> EXCLUDED.price;   -- only update if price actually changed

-- ON CONFLICT on a unique constraint name instead of column list
INSERT INTO employees (employee_id, email, first_name)
VALUES (99, 'new@company.com', 'Taylor')
ON CONFLICT ON CONSTRAINT employees_email_key DO UPDATE
SET first_name = EXCLUDED.first_name;

-- Upsert with RETURNING — get the resulting row whether inserted or updated
INSERT INTO employees (employee_id, first_name, salary)
VALUES (42, 'Francisco', 95000)
ON CONFLICT (employee_id) DO UPDATE
SET salary = EXCLUDED.salary
RETURNING employee_id, first_name, salary, xmax = 0 AS was_inserted;
-- xmax = 0 is a PostgreSQL system column trick: 0 means the row was freshly inserted


/*============================================================
//COPY — Bulk import/export between files and tables
// Much faster than INSERT for large datasets
============================================================*/

-- Import from a CSV file (server-side path — file must be accessible to the PostgreSQL server)
COPY employees (first_name, last_name, salary, department_id)
FROM '/data/employees.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL 'NULL');

-- Export query result to a CSV file
COPY (SELECT * FROM employees WHERE is_active = true)
TO '/data/active_employees.csv'
WITH (FORMAT csv, HEADER true);

-- \COPY is the psql client-side version — reads/writes files on your local machine
-- \COPY employees FROM '/local/path/employees.csv' WITH (FORMAT csv, HEADER true)