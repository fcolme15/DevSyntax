/* PostgreSQL JSON Operations:
JSON vs JSONB, operators, extraction, manipulation, aggregation, indexing */


/*============================================================
//JSON vs JSONB — Two types for storing JSON data
============================================================*/

-- JSON: text-based storage, preserves whitespace and key order, slower queries
-- JSONB: binary storage, decomposed and indexed, faster queries, no whitespace/order preservation
-- Recommendation: use JSONB unless you specifically need to preserve exact formatting

CREATE TABLE events (
    id       SERIAL PRIMARY KEY,
    metadata JSON,        -- stores exact text
    payload  JSONB        -- stores parsed binary representation
);


/*============================================================
//OPERATORS — Extract and query JSON data
// -> returns JSON/JSONB (preserves type)
// ->> returns TEXT (extracts as string)
// #> and #>> navigate nested paths
============================================================*/

SELECT
    payload->'user'                AS user_object,        -- JSON object (keeps as JSON)
    payload->>'user'               AS user_text,          -- TEXT (converts to string)
    payload->'user'->>'name'       AS user_name,          -- drill down: JSON then TEXT
    payload->'items'->0            AS first_item,         -- array indexing: 0-based
    payload->'items'->0->>'sku'    AS first_item_sku,
    payload#>'{user,address,city}' AS nested_city_json,   -- path navigation: returns JSON
    payload#>>'{user,address,city}' AS nested_city_text   -- path navigation: returns TEXT
FROM events;

-- Array element access: 0-indexed
SELECT payload->'tags'->0 FROM events;   -- first element of 'tags' array
SELECT payload->'tags'->-1 FROM events;  -- last element (negative indexing, PostgreSQL 14+)


/*============================================================
//EXISTENCE & CONTAINMENT — Check if keys or values exist
============================================================*/

-- ? — does the JSON object contain this top-level key?
SELECT * FROM events WHERE payload ? 'user_id';

-- ?| — does the JSON object contain ANY of these keys?
SELECT * FROM events WHERE payload ?| ARRAY['user_id', 'session_id'];

-- ?& — does the JSON object contain ALL of these keys?
SELECT * FROM events WHERE payload ?& ARRAY['user_id', 'timestamp'];

-- @> — does left JSON contain right JSON? (deep containment check)
SELECT * FROM events WHERE payload @> '{"status": "completed"}';
SELECT * FROM events WHERE payload @> '{"user": {"role": "admin"}}';

-- <@ — is left JSON contained by right JSON? (reverse of @>)
SELECT * FROM events WHERE '{"status": "completed"}' <@ payload;

-- @? — does the JSON path exist? (JSONPath syntax, PostgreSQL 12+)
SELECT * FROM events WHERE payload @? '$.user.email';

-- @@ — does the JSON path match a predicate? (JSONPath boolean filter, PostgreSQL 12+)
SELECT * FROM events WHERE payload @@ '$.items[*].price > 100';


/*============================================================
//BUILDING JSON — Create JSON from SQL values
============================================================*/

-- JSON_BUILD_OBJECT — create a JSON object from key-value pairs
SELECT JSON_BUILD_OBJECT(
    'id',         employee_id,
    'name',       first_name || ' ' || last_name,
    'salary',     salary,
    'hired',      hire_date
) FROM employees;

-- JSON_BUILD_ARRAY — create a JSON array from a list of values
SELECT JSON_BUILD_ARRAY(first_name, last_name, department_id) FROM employees;

-- JSONB_BUILD_OBJECT / JSONB_BUILD_ARRAY — same but returns JSONB
SELECT JSONB_BUILD_OBJECT('name', first_name, 'dept', department_id) FROM employees;

-- ROW_TO_JSON — convert an entire row to JSON (keys = column names)
SELECT ROW_TO_JSON(e) FROM employees AS e LIMIT 1;

-- TO_JSON / TO_JSONB — convert any SQL value to JSON
SELECT TO_JSONB(ARRAY[1,2,3]);
SELECT TO_JSONB(NOW());


/*============================================================
//AGGREGATING TO JSON — Collect rows into JSON arrays/objects
============================================================*/

-- JSON_AGG — aggregate rows into a JSON array (one element per row)
SELECT JSON_AGG(first_name) FROM employees;   -- ["Alice", "Bob", "Carmen"]

-- Aggregate entire rows as JSON objects
SELECT JSON_AGG(ROW_TO_JSON(e)) FROM employees AS e;

-- JSONB_AGG — same but returns JSONB
SELECT JSONB_AGG(first_name ORDER BY first_name) FROM employees;

-- JSON_OBJECT_AGG — aggregate key-value pairs into a JSON object
SELECT JSON_OBJECT_AGG(department_id, department_name) FROM departments;
-- Result: {"1": "Engineering", "2": "Sales", "3": "Marketing"}

-- Nested aggregation: group employees by department as JSON
SELECT
    d.department_name,
    JSON_AGG(JSON_BUILD_OBJECT(
        'name', e.first_name,
        'salary', e.salary
    )) AS employees
FROM departments AS d
JOIN employees AS e ON d.id = e.department_id
GROUP BY d.department_name;


/*============================================================
//MODIFYING JSON — Update, add, or remove keys
============================================================*/

-- JSONB_SET — set a value at a path (creates if missing, updates if exists)
-- JSONB_SET(target, path, new_value, create_if_missing)
SELECT JSONB_SET(
    '{"user": {"name": "Alice", "age": 30}}',
    '{user,age}',
    '31'
);   -- {"user": {"name": "Alice", "age": 31}}

-- Add a new key
SELECT JSONB_SET(
    '{"user": {"name": "Alice"}}',
    '{user,city}',
    '"New York"',
    true    -- create_if_missing = true
);

-- JSONB_INSERT — insert a value at a specific position (useful for arrays)
SELECT JSONB_INSERT(
    '{"items": [1, 2, 4]}',
    '{items, 2}',   -- insert before index 2
    '3'
);   -- {"items": [1, 2, 3, 4]}

-- || operator — merge/concatenate JSON objects (right side wins on key conflicts)
SELECT '{"a": 1, "b": 2}'::JSONB || '{"b": 3, "c": 4}'::JSONB;
-- Result: {"a": 1, "b": 3, "c": 4}

-- - operator — remove a key from a JSON object
SELECT '{"a": 1, "b": 2, "c": 3}'::JSONB - 'b';   -- {"a": 1, "c": 3}

-- - operator with integer — remove array element by index
SELECT '["a", "b", "c"]'::JSONB - 1;   -- ["a", "c"]

-- #- operator — remove at a path
SELECT '{"user": {"name": "Alice", "age": 30}}'::JSONB #- '{user,age}';
-- Result: {"user": {"name": "Alice"}}

-- JSONB_STRIP_NULLS — remove all null values from a JSON object
SELECT JSONB_STRIP_NULLS('{"a": 1, "b": null, "c": 3}');   -- {"a": 1, "c": 3}


/*============================================================
//EXTRACTING & EXPANDING JSON
============================================================*/

-- JSONB_EACH — expand a JSON object into key-value rows (returns SETOF RECORD)
SELECT * FROM JSONB_EACH('{"a": 1, "b": 2, "c": 3}'::JSONB);
-- Returns: ("a", 1), ("b", 2), ("c", 3)

-- JSONB_EACH_TEXT — same but values are TEXT
SELECT * FROM JSONB_EACH_TEXT('{"a": 1, "b": 2}'::JSONB);

-- JSONB_OBJECT_KEYS — get all top-level keys as a set of TEXT rows
SELECT JSONB_OBJECT_KEYS('{"a": 1, "b": 2, "c": 3}');   -- "a", "b", "c"

-- JSONB_ARRAY_ELEMENTS — expand a JSON array into rows (one row per element)
SELECT * FROM JSONB_ARRAY_ELEMENTS('[1, 2, 3]'::JSONB);

-- JSONB_ARRAY_ELEMENTS_TEXT — same but returns TEXT
SELECT * FROM JSONB_ARRAY_ELEMENTS_TEXT('["a", "b", "c"]'::JSONB);

-- JSONB_TO_RECORD — expand a JSON object into a row with typed columns
-- Must specify the expected schema with AS
SELECT * FROM JSONB_TO_RECORD('{"name": "Alice", "age": 30}'::JSONB)
AS x(name TEXT, age INT);

-- JSONB_POPULATE_RECORD — same but updates an existing record type
-- Useful when you have a table type and want to hydrate it from JSON


/*============================================================
//JSONPATH — Advanced querying (PostgreSQL 12+)
// More expressive than basic operators for complex queries
============================================================*/

-- JSONB_PATH_EXISTS — check if a path exists
SELECT JSONB_PATH_EXISTS(
    '{"items": [{"price": 10}, {"price": 20}]}'::JSONB,
    '$.items[*] ? (@.price > 15)'
);   -- true

-- JSONB_PATH_QUERY — return matching elements (one row per match)
SELECT * FROM JSONB_PATH_QUERY(
    '{"items": [{"price": 10}, {"price": 20}, {"price": 30}]}'::JSONB,
    '$.items[*] ? (@.price > 15)'
);   -- returns two JSONB values: {"price": 20}, {"price": 30}

-- JSONB_PATH_QUERY_ARRAY — collect matches into a JSONB array
SELECT JSONB_PATH_QUERY_ARRAY(
    '{"items": [{"price": 10}, {"price": 20}, {"price": 30}]}'::JSONB,
    '$.items[*].price ? (@ > 15)'
);   -- [20, 30]

-- JSONB_PATH_QUERY_FIRST — return only the first match
SELECT JSONB_PATH_QUERY_FIRST(
    '{"items": [{"price": 10}, {"price": 20}]}'::JSONB,
    '$.items[*] ? (@.price > 5)'
);   -- {"price": 10}


/*============================================================
//INDEXING JSONB — Speed up queries on JSONB columns
============================================================*/

-- GIN index: index all keys and values in the JSONB column (supports @>, ?, ?&, ?|)
CREATE INDEX idx_events_payload ON events USING GIN(payload);

-- Queries that benefit:
SELECT * FROM events WHERE payload @> '{"status": "completed"}';
SELECT * FROM events WHERE payload ? 'user_id';

-- Expression GIN index: index a specific nested path for faster equality checks
CREATE INDEX idx_events_user_id ON events USING GIN((payload->'user_id'));

-- B-tree index on extracted value: for ordering or range queries
CREATE INDEX idx_events_timestamp ON events((payload->>'timestamp'));

-- Query that benefits:
SELECT * FROM events WHERE payload->>'timestamp' > '2024-01-01' ORDER BY payload->>'timestamp';


/*============================================================
//TYPE VALIDATION & FUNCTIONS
============================================================*/

-- JSONB_TYPEOF — return the JSON type of a value
SELECT JSONB_TYPEOF(payload->'user');   -- "object", "array", "string", "number", "boolean", "null"

-- JSONB_ARRAY_LENGTH — count elements in a JSON array
SELECT JSONB_ARRAY_LENGTH(payload->'items') FROM events;

-- JSONB_PRETTY — format JSONB as indented text (for debugging, not storage)
SELECT JSONB_PRETTY(payload) FROM events;