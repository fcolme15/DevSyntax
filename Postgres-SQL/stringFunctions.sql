/* PostgreSQL String Functions:
Concatenation, case, padding, trimming, searching, replacing, formatting, regex */


/*============================================================
//CONCATENATION
============================================================*/

-- || operator — joins two strings, returns NULL if either side is NULL
SELECT first_name || ' ' || last_name AS full_name FROM employees;

-- CONCAT — joins strings, silently ignores NULLs (treats them as empty string)
SELECT CONCAT(first_name, ' ', last_name) FROM employees;

-- CONCAT_WS — concat with separator, skips NULLs entirely (separator not inserted for NULL values)
-- CONCAT_WS(separator, val1, val2, ...)
SELECT CONCAT_WS(', ', last_name, first_name, middle_name) FROM employees;
-- If middle_name is NULL: 'Smith, John' not 'Smith, John, '


/*============================================================
//CASE CONVERSION
============================================================*/

SELECT
    UPPER(first_name),          -- 'francisco' → 'FRANCISCO'
    LOWER(email),               -- 'USER@EXAMPLE.COM' → 'user@example.com'
    INITCAP(job_title)          -- 'senior software engineer' → 'Senior Software Engineer'
FROM employees;


/*============================================================
//LENGTH & CHARACTER INFO
============================================================*/

SELECT
    LENGTH(first_name),         -- number of characters (multibyte-aware)
    CHAR_LENGTH(first_name),    -- same as LENGTH for text
    OCTET_LENGTH(first_name),   -- number of bytes (differs from LENGTH for multibyte chars)
    BIT_LENGTH(first_name),     -- number of bits
    ASCII(first_name),          -- ASCII code of the first character
    CHR(65)                     -- character from ASCII code: 65 → 'A'
FROM employees;


/*============================================================
//SUBSTRING & SLICING
============================================================*/

-- SUBSTRING(string FROM start FOR length) — 1-indexed, start counts from 1
SELECT SUBSTRING(phone_number FROM 1 FOR 3) AS area_code FROM employees;

-- Short form: SUBSTR(string, start, length)
SELECT SUBSTR(product_code, 3, 4) FROM products;

-- SUBSTRING with regex — extract first match of a pattern
SELECT SUBSTRING(description FROM '[0-9]+') AS first_number FROM products;

-- LEFT / RIGHT — take n characters from the left or right end
SELECT LEFT(sku, 3), RIGHT(sku, 4) FROM products;


/*============================================================
//SEARCHING WITHIN STRINGS
============================================================*/

SELECT
    POSITION('sql' IN description),        -- 1-indexed position of first match, 0 if not found
    STRPOS(description, 'sql'),             -- same as POSITION, different syntax
    STARTS_WITH(email, 'admin'),            -- true/false, case-sensitive prefix check
    CONTAINS(tags, 'urgent')               -- use LIKE/ILIKE or ~ for general substring checks
FROM tickets;
-- LIKE and ILIKE are covered in 01_basics.sql


/*============================================================
//TRIMMING & PADDING
============================================================*/

SELECT
    TRIM(leading  ' ' FROM input),         -- remove leading spaces
    TRIM(trailing ' ' FROM input),         -- remove trailing spaces
    TRIM(both     ' ' FROM input),         -- remove both (default behavior of TRIM)
    TRIM(input),                            -- shorthand: trims spaces from both ends
    LTRIM(input, ' #'),                     -- remove any of the given characters from the left
    RTRIM(input, ' .'),                     -- remove any of the given characters from the right
    BTRIM(input, '*')                       -- remove character from both ends
FROM raw_data;

SELECT
    LPAD(invoice_number::TEXT, 8, '0'),     -- pad left to width 8 with '0': '42' → '00000042'
    RPAD(department_code, 10, '-')          -- pad right to width 10 with '-'
FROM invoices;


/*============================================================
//REPLACING & MANIPULATING
============================================================*/

SELECT
    REPLACE(phone, '-', ''),               -- replace ALL occurrences (string, from, to)
    OVERLAY(description PLACING 'SQL' FROM 5 FOR 3),  -- replace characters at a specific position
    REVERSE(first_name),                   -- reverse the string character by character
    REPEAT('ab', 3),                       -- repeat string n times: 'ababab'
    TRANSLATE(code, 'abc', '123')          -- character-by-character substitution: a→1, b→2, c→3
FROM employees;


/*============================================================
//SPLITTING & JOINING
============================================================*/

-- SPLIT_PART — split a string on a delimiter and return the nth part (1-indexed)
SELECT
    SPLIT_PART(email, '@', 1)   AS username,   -- 'user@example.com' → 'user'
    SPLIT_PART(email, '@', 2)   AS domain      -- 'user@example.com' → 'example.com'
FROM employees;

-- STRING_TO_ARRAY — split string into a PostgreSQL array
SELECT STRING_TO_ARRAY('a,b,c,d', ',');        -- → '{a,b,c,d}'
SELECT STRING_TO_ARRAY('a,,b', ',', '');        -- third arg replaces empty segments with NULL

-- ARRAY_TO_STRING — join array elements into a string
SELECT ARRAY_TO_STRING(ARRAY['a','b','c'], '-');  -- → 'a-b-c'


/*============================================================
//FORMATTING
============================================================*/

-- FORMAT — printf-style string formatting (PostgreSQL-specific)
-- %s = text, %I = quoted identifier, %L = quoted literal
SELECT FORMAT('Hello, %s! Your balance is %s.', first_name, balance) FROM accounts;
SELECT FORMAT('UPDATE %I SET active = %L', table_name, true);     -- safe for dynamic SQL

-- TO_CHAR — format numbers and dates as strings (covered more in 08_datetime)
SELECT
    TO_CHAR(salary, 'FM$999,999.00'),       -- '$85,000.00' (FM removes leading spaces)
    TO_CHAR(3.14159, 'FM999.99')            -- '3.14'
FROM employees;


/*============================================================
//REGEX — Pattern matching and extraction
============================================================*/

-- Match operators (return boolean)
-- ~    case-sensitive match
-- ~*   case-insensitive match
-- !~   case-sensitive no-match
-- !~*  case-insensitive no-match
SELECT * FROM employees WHERE last_name ~ '^[A-M]';

-- REGEXP_LIKE (PostgreSQL 15+) — cleaner boolean regex test
SELECT REGEXP_LIKE(email, '^[a-z]+@[a-z]+\.[a-z]+$') FROM employees;

-- REGEXP_REPLACE — replace regex matches with a substitution string
-- REGEXP_REPLACE(string, pattern, replacement, flags)
-- flags: g = replace all, i = case-insensitive
SELECT REGEXP_REPLACE(phone, '[^0-9]', '', 'g') AS digits_only FROM employees;

-- REGEXP_MATCH — returns first match as a TEXT array, NULL if no match
SELECT REGEXP_MATCH(description, '(\d+)\s*(kg|lb)') FROM products;
-- Returns array: '{500, kg}' — capture groups become array elements

-- REGEXP_MATCHES — returns a row per match (use when there are multiple matches)
SELECT REGEXP_MATCHES(notes, '\d+', 'g') FROM tickets;

-- REGEXP_SPLIT_TO_TABLE — split string on regex, returns one row per part
SELECT REGEXP_SPLIT_TO_TABLE('one  two   three', '\s+');

-- REGEXP_SPLIT_TO_ARRAY — same but returns an array instead of rows
SELECT REGEXP_SPLIT_TO_ARRAY('one  two   three', '\s+');


/*============================================================
//ENCODING & CONVERSION
============================================================*/

SELECT
    ENCODE(data, 'base64'),                -- binary to base64 text
    DECODE('SGVsbG8=', 'base64'),          -- base64 text to binary
    CONVERT_FROM(data, 'UTF8'),            -- binary to text in given encoding
    MD5(password_text)                     -- MD5 hash as hex string (not for security use)
FROM raw_inputs;