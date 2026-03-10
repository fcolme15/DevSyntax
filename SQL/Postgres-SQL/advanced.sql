/* PostgreSQL Advanced Features:
LATERAL joins, recursive CTEs, CROSSTAB/pivot, full-text search, GENERATE_SERIES, TABLESAMPLE */


/*============================================================
//LATERAL JOINS — Correlated subquery in FROM that references earlier tables
// Regular subqueries in FROM cannot see other tables; LATERAL lifts that restriction
// Evaluates the subquery once per row from the left side
============================================================*/

-- Top N per group pattern: get top 3 orders per customer
SELECT c.customer_name, recent.order_date, recent.total
FROM customers AS c
JOIN LATERAL (
    SELECT order_date, total
    FROM orders
    WHERE customer_id = c.id   -- references c from the outer query
    ORDER BY order_date DESC
    LIMIT 3
) AS recent ON true;   -- ON true required when subquery handles the filtering

-- Use LEFT JOIN LATERAL to preserve left-side rows even when subquery returns nothing


/*============================================================
//RECURSIVE CTEs — Iteratively query hierarchical or graph data
// WITH RECURSIVE keeps re-running until no new rows are produced
// Structure: anchor term (base case) UNION ALL recursive term (references CTE itself)
// Covered in detail in 04_subqueries.sql — shown here for context with other advanced patterns
============================================================*/

-- Walk an org chart from employee up to CEO
WITH RECURSIVE org_tree AS (
    SELECT employee_id, first_name, manager_id, 1 AS level
    FROM employees WHERE employee_id = 42
    UNION ALL
    SELECT e.employee_id, e.first_name, e.manager_id, ot.level + 1
    FROM employees AS e
    JOIN org_tree AS ot ON e.employee_id = ot.manager_id
)
SELECT * FROM org_tree ORDER BY level;

-- PostgreSQL 14+: CYCLE clause handles cycle detection automatically
WITH RECURSIVE paths AS (
    SELECT node_id, parent_id FROM graph WHERE node_id = 1
    UNION ALL
    SELECT g.node_id, g.parent_id FROM graph AS g 
    JOIN paths AS p ON g.parent_id = p.node_id
) CYCLE node_id SET is_cycle USING path
SELECT * FROM paths WHERE NOT is_cycle;


/*============================================================
//CROSSTAB / PIVOT TABLES — Rotate rows into columns
// Requires the tablefunc extension: CREATE EXTENSION IF NOT EXISTS tablefunc;
============================================================*/

-- CROSSTAB(source_sql, category_sql) rotates row data into columns
-- source_sql: returns (row_name, category, value)
-- category_sql: returns distinct category values that become output columns
SELECT * FROM CROSSTAB(
    'SELECT department_id, job_title, COUNT(*) FROM employees GROUP BY 1, 2 ORDER BY 1, 2',
    'SELECT DISTINCT job_title FROM employees ORDER BY 1'
) AS ct(department_id INTEGER, engineer BIGINT, designer BIGINT, manager BIGINT);

-- Alternative: manual pivot with CASE (no extension needed, more explicit)
SELECT
    department_id,
    SUM(CASE WHEN job_title = 'Engineer' THEN 1 ELSE 0 END) AS engineers,
    SUM(CASE WHEN job_title = 'Designer' THEN 1 ELSE 0 END) AS designers
FROM employees GROUP BY department_id;


/*============================================================
//FULL-TEXT SEARCH — Search text with ranking, stemming, and relevance
// Uses tsvector (tokenized document) and tsquery (search expression)
============================================================*/

-- TO_TSVECTOR tokenizes and normalizes text for searching
SELECT TO_TSVECTOR('english', 'The quick brown fox jumps over the lazy dog');
-- Result: 'brown':3 'dog':9 'fox':4 'jump':5 'lazi':8 'quick':2

-- TO_TSQUERY creates search patterns: & (AND), | (OR), ! (NOT)
SELECT TO_TSQUERY('english', 'fox & dog');       -- both words required
SELECT PLAINTO_TSQUERY('english', 'quick brown fox');  -- simpler: auto-adds &
SELECT PHRASETO_TSQUERY('english', 'quick brown fox'); -- phrase: words in order

-- @@ operator: does the tsvector match the tsquery?
SELECT * FROM articles
WHERE TO_TSVECTOR('english', title || ' ' || body) @@ TO_TSQUERY('english', 'database & performance');

-- TS_RANK scores relevance (higher = better match)
SELECT title, TS_RANK(TO_TSVECTOR('english', body), TO_TSQUERY('english', 'postgres')) AS rank
FROM articles
WHERE TO_TSVECTOR('english', body) @@ TO_TSQUERY('english', 'postgres')
ORDER BY rank DESC;

-- Performance optimization: precompute tsvector + GIN index
ALTER TABLE articles ADD COLUMN search_vector TSVECTOR
    GENERATED ALWAYS AS (TO_TSVECTOR('english', title || ' ' || body)) STORED;
CREATE INDEX idx_articles_search ON articles USING GIN(search_vector);

SELECT * FROM articles WHERE search_vector @@ TO_TSQUERY('english', 'database');


/*============================================================
//GENERATE_SERIES — Generate sequences of numbers, dates, or timestamps
// Useful for filling gaps in time-series data or building test data
============================================================*/

-- Number sequences
SELECT * FROM GENERATE_SERIES(1, 10);           -- 1 to 10 inclusive
SELECT * FROM GENERATE_SERIES(1, 10, 2);        -- 1, 3, 5, 7, 9 (step by 2)

-- Date/time sequences
SELECT GENERATE_SERIES('2024-01-01'::DATE, '2024-01-31'::DATE, INTERVAL '1 day') AS day;
SELECT GENERATE_SERIES('2024-01-01 00:00'::TIMESTAMP, '2024-01-01 23:00'::TIMESTAMP, INTERVAL '1 hour') AS hour;

-- Fill gaps pattern: LEFT JOIN data against a complete date series
SELECT ds.month, COALESCE(SUM(o.total), 0) AS revenue
FROM GENERATE_SERIES('2024-01-01'::DATE, '2024-12-01'::DATE, INTERVAL '1 month') AS ds(month)
LEFT JOIN orders AS o ON DATE_TRUNC('month', o.order_date) = ds.month
GROUP BY ds.month ORDER BY ds.month;


/*============================================================
//TABLESAMPLE — Random sampling of rows for large tables
// More efficient than ORDER BY RANDOM() LIMIT N on large datasets
============================================================*/

-- BERNOULLI (row-level) — each row independently selected, ~10% probability
SELECT * FROM large_table TABLESAMPLE BERNOULLI(10);

-- SYSTEM (page-level) — faster but less random, samples entire disk pages
SELECT * FROM large_table TABLESAMPLE SYSTEM(10);

-- REPEATABLE with seed for reproducible sampling
SELECT * FROM large_table TABLESAMPLE BERNOULLI(10) REPEATABLE(42);


/*============================================================
//MATERIALIZED VIEWS — Cached query results stored as a table
// Must be manually refreshed to pick up changes in underlying data
============================================================*/

-- Create a materialized view (stores result on disk, fast reads)
CREATE MATERIALIZED VIEW sales_summary AS
SELECT product_id, DATE_TRUNC('month', sale_date) AS month,
       SUM(amount) AS total_sales, COUNT(*) AS sale_count
FROM sales GROUP BY product_id, DATE_TRUNC('month', sale_date);

-- Query the cached result
SELECT * FROM sales_summary WHERE month = '2024-01-01';

-- Refresh to update with current data (blocks reads)
REFRESH MATERIALIZED VIEW sales_summary;

-- Concurrent refresh (allows reads during refresh, requires UNIQUE index)
CREATE UNIQUE INDEX idx_sales_summary_pk ON sales_summary(product_id, month);
REFRESH MATERIALIZED VIEW CONCURRENTLY sales_summary;


/*============================================================
//LISTEN / NOTIFY — Asynchronous pub/sub messaging within PostgreSQL
============================================================*/

LISTEN channel_name;                         -- subscribe to a channel
NOTIFY channel_name, 'message payload';      -- publish a message
-- Applications receive notifications asynchronously, payload limited to ~8KB


/*============================================================
//ADVISORY LOCKS — Application-level locks managed by PostgreSQL
// Useful for distributed locking or coordinating between application instances
============================================================*/

SELECT PG_ADVISORY_LOCK(12345);              -- acquire exclusive lock (blocks until available)
SELECT PG_TRY_ADVISORY_LOCK(12345);          -- try without blocking (returns true/false)
SELECT PG_ADVISORY_UNLOCK(12345);            -- release the lock
-- Locks auto-release when session ends