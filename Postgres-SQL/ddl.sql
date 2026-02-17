/* PostgreSQL Data Definition Language:
CREATE, ALTER, DROP, constraints, indexes, sequences, schemas */


/*============================================================
//CREATE TABLE
============================================================*/

CREATE TABLE employees (
    employee_id   SERIAL        PRIMARY KEY,                        -- auto-incrementing integer PK
    first_name    VARCHAR(100)  NOT NULL,
    last_name     VARCHAR(100)  NOT NULL,
    email         TEXT          UNIQUE NOT NULL,
    salary        NUMERIC(10,2) CHECK (salary > 0),                 -- inline check constraint
    department_id INTEGER       REFERENCES departments(id),         -- inline foreign key
    hire_date     DATE          DEFAULT CURRENT_DATE,
    is_active     BOOLEAN       DEFAULT true,
    created_at    TIMESTAMPTZ   DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   DEFAULT NOW()
);

-- CREATE TABLE IF NOT EXISTS — no error if table already exists
CREATE TABLE IF NOT EXISTS audit_log (
    id         BIGSERIAL    PRIMARY KEY,
    event      TEXT         NOT NULL,
    created_at TIMESTAMPTZ  DEFAULT NOW()
);

-- Create table from a query result — copies structure and data, no constraints carried over
CREATE TABLE employees_backup AS
SELECT * FROM employees;

-- Create empty table matching another table's structure
CREATE TABLE employees_staging (LIKE employees INCLUDING DEFAULTS);
-- INCLUDING options: DEFAULTS, CONSTRAINTS, INDEXES, ALL


/*============================================================
//DATA TYPES — Common PostgreSQL types
============================================================*/

-- Numeric
-- SMALLINT          2 bytes, -32768 to 32767
-- INTEGER / INT     4 bytes, ~-2.1B to 2.1B
-- BIGINT            8 bytes, very large integers
-- NUMERIC(p,s)      exact decimal, p=total digits, s=decimal places — use for money
-- REAL              4-byte float, imprecise
-- DOUBLE PRECISION  8-byte float, imprecise
-- SERIAL            auto-increment INTEGER (shorthand for sequence + default)
-- BIGSERIAL         auto-increment BIGINT

-- Text
-- CHAR(n)           fixed-length, padded with spaces
-- VARCHAR(n)        variable-length, max n characters
-- TEXT              unlimited length — preferred in PostgreSQL over VARCHAR without limit

-- Date/Time
-- DATE              calendar date only
-- TIME              time of day only
-- TIMESTAMP         date + time, no timezone
-- TIMESTAMPTZ       date + time, with timezone (stored as UTC) — preferred
-- INTERVAL          duration (e.g. '3 days', '2 hours')

-- Other
-- BOOLEAN           true / false / null
-- UUID              universally unique identifier
-- JSONB             binary JSON — indexed, preferred over JSON for querying
-- JSON              text JSON — preserves whitespace and key order
-- ARRAY             any type can be an array: INTEGER[], TEXT[]
-- BYTEA             binary data


/*============================================================
//CONSTRAINTS — Rules enforced on column values or combinations
============================================================*/

-- Inline constraints (attached to a single column)
CREATE TABLE orders (
    order_id    SERIAL       PRIMARY KEY,
    customer_id INTEGER      NOT NULL,
    status      TEXT         DEFAULT 'pending' CHECK (status IN ('pending','confirmed','shipped','cancelled')),
    total       NUMERIC(10,2) CHECK (total >= 0)
);

-- Table-level constraints (defined after all columns, can span multiple columns)
CREATE TABLE order_items (
    order_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER CHECK (quantity > 0),
    price      NUMERIC(10,2),

    PRIMARY KEY (order_id, product_id),                             -- composite primary key
    FOREIGN KEY (order_id)   REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)     ON DELETE RESTRICT,
    UNIQUE (order_id, product_id),                                  -- composite unique
    CHECK (price > 0)
);

-- Named constraints — naming allows you to reference them in ALTER TABLE later
CREATE TABLE products (
    id       SERIAL PRIMARY KEY,
    sku      TEXT,
    price    NUMERIC(10,2),
    category TEXT,

    CONSTRAINT products_sku_unique     UNIQUE (sku),
    CONSTRAINT products_price_positive CHECK (price > 0),
    CONSTRAINT products_category_valid CHECK (category IN ('electronics','clothing','food'))
);

-- Foreign key actions — what happens to child rows when parent is updated/deleted
-- ON DELETE: RESTRICT (default), CASCADE, SET NULL, SET DEFAULT, NO ACTION
-- ON UPDATE: same options
-- RESTRICT  — prevents the parent delete/update if child rows exist
-- CASCADE   — propagates the delete/update to child rows
-- SET NULL  — sets the FK column to NULL in child rows
-- SET DEFAULT — sets the FK column to its default value in child rows


/*============================================================
//ALTER TABLE — Modify an existing table's structure
============================================================*/

-- Add a column
ALTER TABLE employees ADD COLUMN phone TEXT;
ALTER TABLE employees ADD COLUMN score NUMERIC DEFAULT 0 NOT NULL;

-- Drop a column
ALTER TABLE employees DROP COLUMN phone;
ALTER TABLE employees DROP COLUMN phone CASCADE;  -- also drops dependent objects (views, indexes)

-- Rename a column
ALTER TABLE employees RENAME COLUMN phone TO phone_number;

-- Change column type
ALTER TABLE employees ALTER COLUMN salary TYPE BIGINT;
ALTER TABLE employees ALTER COLUMN code TYPE INTEGER USING code::INTEGER;  -- USING for explicit cast

-- Set / remove a column default
ALTER TABLE employees ALTER COLUMN is_active SET DEFAULT true;
ALTER TABLE employees ALTER COLUMN is_active DROP DEFAULT;

-- Set / remove NOT NULL
ALTER TABLE employees ALTER COLUMN email SET NOT NULL;
ALTER TABLE employees ALTER COLUMN email DROP NOT NULL;

-- Add a named constraint
ALTER TABLE employees ADD CONSTRAINT employees_salary_positive CHECK (salary > 0);
ALTER TABLE employees ADD CONSTRAINT employees_email_unique UNIQUE (email);

-- Drop a constraint by name
ALTER TABLE employees DROP CONSTRAINT employees_salary_positive;

-- Rename a table
ALTER TABLE employees RENAME TO staff;


/*============================================================
//DROP — Remove database objects
============================================================*/

DROP TABLE employees;
DROP TABLE IF EXISTS employees;                 -- no error if table doesn't exist
DROP TABLE employees CASCADE;                   -- also drops dependent views, FK constraints, etc.

DROP DATABASE company_db;
DROP SCHEMA analytics CASCADE;


/*============================================================
//INDEXES — Speed up reads at the cost of slower writes and storage
============================================================*/

-- B-tree index (default) — equality and range queries, most common
CREATE INDEX idx_employees_department ON employees(department_id);

-- Multi-column (composite) index — useful when queries filter on both columns together
-- Column order matters: put the most selective or most-filtered-on column first
CREATE INDEX idx_employees_dept_salary ON employees(department_id, salary);

-- Unique index — enforces uniqueness and speeds up lookups
CREATE UNIQUE INDEX idx_employees_email ON employees(email);

-- Partial index — indexes only rows matching a condition, smaller and faster
CREATE INDEX idx_active_employees ON employees(department_id) WHERE is_active = true;

-- Expression index — index on a computed expression, useful for case-insensitive searches
CREATE INDEX idx_employees_email_lower ON employees(LOWER(email));
-- Query must use the same expression to hit this index: WHERE LOWER(email) = 'user@example.com'

-- GIN index — for JSONB, arrays, and full-text search (indexes all elements inside the value)
CREATE INDEX idx_employee_metadata ON employees USING GIN(metadata);      -- metadata is JSONB
CREATE INDEX idx_tags ON products USING GIN(tags);                         -- tags is TEXT[]

-- GiST index — for geometric types, ranges, and full-text search
CREATE INDEX idx_location ON places USING GiST(coordinates);              -- PostGIS geometry
CREATE INDEX idx_date_range ON bookings USING GiST(tsrange(start_at, end_at));

-- BRIN index — block range index, very small, good for naturally ordered large tables
CREATE INDEX idx_logs_created ON logs USING BRIN(created_at);

-- Concurrent index build — does not lock the table for writes (slower but safe for production)
CREATE INDEX CONCURRENTLY idx_employees_name ON employees(last_name, first_name);

-- Drop an index
DROP INDEX idx_employees_department;
DROP INDEX CONCURRENTLY idx_employees_department;  -- non-blocking drop


/*============================================================
//SEQUENCES — Generate unique numeric values, used by SERIAL
============================================================*/

-- Create a sequence manually
CREATE SEQUENCE order_number_seq START 1000 INCREMENT 5;

-- Use it in a query
SELECT NEXTVAL('order_number_seq');   -- advances and returns next value
SELECT CURRVAL('order_number_seq');   -- returns current value without advancing
SELECT LASTVAL();                     -- returns last value returned by NEXTVAL in this session

-- Alter a sequence
ALTER SEQUENCE order_number_seq RESTART WITH 1;
ALTER SEQUENCE order_number_seq INCREMENT BY 10;

-- Attach a sequence as a column default
ALTER TABLE orders ALTER COLUMN order_number SET DEFAULT NEXTVAL('order_number_seq');


/*============================================================
//SCHEMAS — Namespaces that organize tables within a database
============================================================*/

CREATE SCHEMA analytics;
CREATE SCHEMA IF NOT EXISTS reporting;

-- Create a table inside a specific schema
CREATE TABLE analytics.events (
    id         BIGSERIAL PRIMARY KEY,
    event_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- search_path controls which schema is checked first when no schema is specified
SET search_path TO analytics, public;

DROP SCHEMA analytics;
DROP SCHEMA analytics CASCADE;  -- also drops all tables and objects inside it