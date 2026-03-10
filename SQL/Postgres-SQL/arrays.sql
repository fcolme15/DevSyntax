/* PostgreSQL Array Operations:
Array creation, indexing, slicing, operators, functions, UNNEST, ANY/ALL */


/*============================================================
//ARRAY TYPES & LITERALS — PostgreSQL arrays store multiple values of the same type
============================================================*/

-- Declaring array columns
CREATE TABLE products (
    id     SERIAL PRIMARY KEY,
    tags   TEXT[],          -- variable-length text array
    scores INTEGER[],       -- variable-length integer array
    matrix INTEGER[][]      -- multidimensional array (rare in practice)
);

-- Array literals: use curly braces inside quotes, then cast
SELECT
    '{apple,banana,cherry}'::TEXT[],
    '{1,2,3,4,5}'::INTEGER[],
    '{{1,2},{3,4}}'::INTEGER[][]   -- 2D array
FROM products LIMIT 1;

-- ARRAY constructor: preferred for non-literal values
SELECT
    ARRAY[first_name, last_name],
    ARRAY[1, 2, 3, 4],
    ARRAY[1, 2] || ARRAY[3, 4]    -- concatenation
FROM employees;


/*============================================================
//ARRAY INDEXING & SLICING — Arrays are 1-indexed by default
============================================================*/

SELECT
    tags[1],                   -- first element (1-indexed, not 0!)
    tags[2],                   -- second element
    tags[array_length(tags, 1)] AS last_element,  -- last element via length
    tags[1:3],                 -- slice: elements 1, 2, 3 (inclusive on both ends)
    tags[2:]                   -- slice from 2 to end (PostgreSQL 14+)
FROM products;

-- Multidimensional array indexing
SELECT matrix[1][2] FROM products;   -- row 1, column 2

-- Arrays are 1-indexed but you can define custom bounds when constructing (rare)
SELECT '[2:4]={10,20,30}'::INTEGER[];   -- array with custom lower bound 2


/*============================================================
//ARRAY OPERATORS
============================================================*/

SELECT
    ARRAY[1,2,3] || 4,                  -- append element: {1,2,3,4}
    4 || ARRAY[1,2,3],                  -- prepend element: {4,1,2,3}
    ARRAY[1,2] || ARRAY[3,4],           -- concatenate arrays: {1,2,3,4}
    ARRAY[1,2,3] = ARRAY[1,2,3],        -- equality: true
    ARRAY[1,2,3] <> ARRAY[1,2,4],       -- inequality: true
    ARRAY[1,2,3] @> ARRAY[2],           -- contains: does left contain all elements of right?
    ARRAY[2] <@ ARRAY[1,2,3],           -- contained by: is left contained in right?
    ARRAY[1,2,3] && ARRAY[2,4,6]        -- overlap: do the arrays share any elements? (true)
FROM products LIMIT 1;


/*============================================================
//ARRAY FUNCTIONS
//Following are examples to really make changes need to use update
//Ex: UPDATE products 
//////SET tags = ARRAY_APPEND(tags, 'new_tag') 
//////WHERE id = 42;
============================================================*/

-- ARRAY_LENGTH — number of elements in a dimension (dimension is 1-indexed)
SELECT
    ARRAY_LENGTH(tags, 1),             -- length of first dimension (most common)
    ARRAY_LENGTH(matrix, 2)            -- length of second dimension
FROM products;

-- ARRAY_UPPER / ARRAY_LOWER — upper/lower bound of a dimension (1-indexed by default)
SELECT ARRAY_UPPER(ARRAY[10,20,30], 1);   -- 3
SELECT ARRAY_LOWER(ARRAY[10,20,30], 1);   -- 1

-- ARRAY_APPEND / ARRAY_PREPEND — add an element to the end/start
SELECT
    ARRAY_APPEND(ARRAY[1,2,3], 4),     -- {1,2,3,4}
    ARRAY_PREPEND(0, ARRAY[1,2,3])     -- {0,1,2,3}
FROM products LIMIT 1;

-- ARRAY_CAT — concatenate two arrays (same as || operator)
SELECT ARRAY_CAT(ARRAY[1,2], ARRAY[3,4]);   -- {1,2,3,4}

-- ARRAY_REMOVE — remove all occurrences of a value
SELECT ARRAY_REMOVE(ARRAY[1,2,3,2,4], 2);   -- {1,3,4}

-- ARRAY_REPLACE — replace all occurrences of a value with another
SELECT ARRAY_REPLACE(ARRAY[1,2,3,2,4], 2, 99);   -- {1,99,3,99,4}

-- ARRAY_POSITION — find the index of the first occurrence (1-indexed, NULL if not found)
SELECT ARRAY_POSITION(ARRAY['a','b','c','b'], 'b');   -- 2

-- ARRAY_POSITIONS — find all indexes of a value (returns integer array)
SELECT ARRAY_POSITIONS(ARRAY['a','b','c','b'], 'b');   -- {2,4}

-- ARRAY_TO_STRING — join array elements into a string with a delimiter
SELECT ARRAY_TO_STRING(ARRAY['apple','banana','cherry'], ', ');   -- 'apple, banana, cherry'
SELECT ARRAY_TO_STRING(ARRAY[1,2,NULL,4], '-', '?');   -- '1-2-?-4' (third arg replaces NULLs)

-- STRING_TO_ARRAY — split a string into an array (reverse of ARRAY_TO_STRING)
SELECT STRING_TO_ARRAY('a,b,c', ',');   -- {a,b,c}

-- ARRAY_AGG — aggregate rows into an array (covered in 03_aggregations.sql)
SELECT ARRAY_AGG(first_name ORDER BY first_name) FROM employees;


/*============================================================
//UNNEST — Expand an array into a set of rows (one row per element)
// Inverse of ARRAY_AGG
============================================================*/

-- Basic UNNEST
SELECT UNNEST(ARRAY[1,2,3,4]) AS value;
-- Returns 4 rows: 1, 2, 3, 4

-- UNNEST in FROM clause
SELECT * FROM UNNEST(ARRAY['apple','banana','cherry']) AS fruit;

-- UNNEST with WITH ORDINALITY — includes row number alongside each value
SELECT * FROM UNNEST(ARRAY['a','b','c']) WITH ORDINALITY AS t(value, index);
-- Returns: ('a', 1), ('b', 2), ('c', 3)

-- Multiple arrays UNNESTed together — zipped row-by-row
SELECT * FROM UNNEST(
    ARRAY['Alice', 'Bob', 'Carmen'],
    ARRAY[30, 25, 35]
) AS t(name, age);
-- Returns: ('Alice', 30), ('Bob', 25), ('Carmen', 35)

-- JOIN a table with an unnested array column
SELECT p.id, t.tag
FROM products AS p
CROSS JOIN UNNEST(p.tags) AS t(tag);

-- Filter rows based on array membership after unnesting
SELECT p.*
FROM products AS p
WHERE 'urgent' = ANY(SELECT UNNEST(p.tags));


/*============================================================
//ANY / ALL — Quantified comparisons over arrays
// Useful for checking if a condition is true for any or all array elements
============================================================*/

-- ANY: true if the comparison matches at least one element
SELECT * FROM products WHERE 10 = ANY(scores);         -- at least one score is 10
SELECT * FROM products WHERE 'urgent' = ANY(tags);     -- 'urgent' appears in tags array

-- Equivalent to using IN with an unnested array
SELECT * FROM products WHERE 'urgent' IN (SELECT UNNEST(tags));

-- ALL: true if the comparison matches every element
SELECT * FROM products WHERE 5 < ALL(scores);          -- all scores are > 5

-- ANY/ALL work with operators: =, <>, <, >, <=, >=
SELECT * FROM orders WHERE total > ANY(ARRAY[100, 200, 300]);
SELECT * FROM orders WHERE total <= ALL(ARRAY[100, 200, 300]);


/*============================================================
//ARRAY CONTAINMENT & OVERLAP — Querying array membership
============================================================*/

-- @> contains operator: does the left array contain all elements of the right?
SELECT * FROM products WHERE tags @> ARRAY['featured','sale'];
-- Returns rows where tags contains both 'featured' AND 'sale'

-- <@ contained by operator: is the left array fully contained in the right?
SELECT * FROM products WHERE ARRAY['featured'] <@ tags;

-- && overlap operator: do the arrays share at least one element?
SELECT * FROM products WHERE tags && ARRAY['urgent','featured'];
-- Returns rows where tags contains 'urgent' OR 'featured' (or both)


/*============================================================
//ARRAY AGGREGATION PATTERNS
============================================================*/

-- Collect all tags across multiple products into one array
SELECT ARRAY_AGG(DISTINCT tag) AS all_tags
FROM products, UNNEST(tags) AS tag;

-- Flatten a nested array structure (array of arrays → single flat array)
SELECT ARRAY(SELECT UNNEST(UNNEST(nested_array_column))) FROM table_name;


/*============================================================
//INDEXING ARRAYS — Speed up array containment queries
============================================================*/

-- GIN index: supports @>, <@, && operators
CREATE INDEX idx_products_tags ON products USING GIN(tags);

-- Queries that benefit from the index:
SELECT * FROM products WHERE tags @> ARRAY['featured'];
SELECT * FROM products WHERE tags && ARRAY['sale','clearance'];

-- GIN index with array_ops (default) or custom operator class
CREATE INDEX idx_tags_gin ON products USING GIN(tags array_ops);


/*============================================================
//MULTIDIMENSIONAL ARRAYS — Rarely used but supported
============================================================*/

-- 2D array literal
SELECT '{{1,2,3},{4,5,6}}'::INTEGER[][] AS matrix;

-- Access elements
SELECT matrix[1][2] FROM (SELECT '{{1,2,3},{4,5,6}}'::INTEGER[][] AS matrix) t;

-- Note: PostgreSQL does not enforce rectangular shape — jagged arrays are allowed
-- but most array functions assume regular dimensions