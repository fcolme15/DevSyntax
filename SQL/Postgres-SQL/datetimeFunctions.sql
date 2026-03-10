/* PostgreSQL Date & Time Functions:
Current time, intervals, truncation, extraction, arithmetic, formatting, timezones */


/*============================================================
//CURRENT DATE & TIME — Getting the current moment
============================================================*/

SELECT
    NOW(),                      -- current timestamp with timezone (TIMESTAMPTZ)
    CURRENT_TIMESTAMP,          -- same as NOW(), SQL standard syntax
    CURRENT_DATE,               -- today's date only (DATE), no time component
    CURRENT_TIME,               -- current time with timezone (TIMETZ)
    LOCALTIME,                  -- current time without timezone
    LOCALTIMESTAMP,             -- current timestamp without timezone
    CLOCK_TIMESTAMP(),          -- actual current time, updates within a transaction
    TRANSACTION_TIMESTAMP()     -- same as NOW() — fixed at transaction start time
FROM employees LIMIT 1;

-- NOW() and CURRENT_TIMESTAMP are fixed at the start of the transaction
-- CLOCK_TIMESTAMP() advances in real time even within a long transaction


/*============================================================
//DATE/TIME TYPES & LITERALS
============================================================*/

SELECT
    '2024-03-15'::DATE,
    '2024-03-15 14:30:00'::TIMESTAMP,
    '2024-03-15 14:30:00+05:00'::TIMESTAMPTZ,
    '14:30:00'::TIME,
    '3 days 4 hours 30 minutes'::INTERVAL,
    INTERVAL '2 weeks',
    INTERVAL '1 year 3 months';


/*============================================================
//INTERVAL — Represent a duration of time
============================================================*/

-- Constructing intervals
SELECT
    INTERVAL '1 year',
    INTERVAL '3 months',
    INTERVAL '2 weeks',
    INTERVAL '5 days',
    INTERVAL '6 hours',
    INTERVAL '30 minutes',
    INTERVAL '45 seconds',
    INTERVAL '1 year 2 months 3 days 4 hours';

-- Interval arithmetic
SELECT
    NOW() + INTERVAL '30 days'              AS thirty_days_from_now,
    NOW() - INTERVAL '1 year'              AS one_year_ago,
    CURRENT_DATE + INTERVAL '3 months'     AS three_months_out,
    INTERVAL '2 hours' + INTERVAL '30 minutes'  AS combined;   -- → '2:30:00'

-- MAKE_INTERVAL — construct an interval from named parameters
-- MAKE_INTERVAL(years, months, weeks, days, hours, mins, secs)
SELECT MAKE_INTERVAL(days => 10, hours => 3);


/*============================================================
//DATE_TRUNC — Truncate a timestamp to a specified precision
// Returns the start of the containing unit (zeroes out smaller units)
============================================================*/

-- DATE_TRUNC(unit, timestamp)
-- units: microseconds, milliseconds, second, minute, hour, day, week, month, quarter, year, decade, century
SELECT
    DATE_TRUNC('year',    hire_date)    AS start_of_year,    -- 2024-01-01 00:00:00
    DATE_TRUNC('quarter', hire_date)    AS start_of_quarter, -- 2024-04-01 00:00:00 (for Q2)
    DATE_TRUNC('month',   hire_date)    AS start_of_month,   -- 2024-03-01 00:00:00
    DATE_TRUNC('week',    hire_date)    AS start_of_week,    -- Monday of that week
    DATE_TRUNC('day',     created_at)   AS start_of_day,     -- date at midnight
    DATE_TRUNC('hour',    created_at)   AS start_of_hour
FROM employees;

-- Common pattern: group by time period
SELECT DATE_TRUNC('month', created_at) AS month, COUNT(*) AS signups
FROM users
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month;


/*============================================================
//EXTRACT / DATE_PART — Pull a specific component out of a date/time
// EXTRACT returns NUMERIC, DATE_PART returns FLOAT8 (functionally equivalent)
============================================================*/

-- EXTRACT(field FROM timestamp)
-- fields: year, month, day, hour, minute, second, milliseconds, microseconds,
--         dow (0=Sunday), isodow (1=Monday), doy (day of year), week (ISO week), quarter, epoch
SELECT
    EXTRACT(year    FROM hire_date)     AS hire_year,
    EXTRACT(month   FROM hire_date)     AS hire_month,
    EXTRACT(day     FROM hire_date)     AS hire_day,
    EXTRACT(hour    FROM created_at)    AS hour_of_day,
    EXTRACT(dow     FROM created_at)    AS day_of_week,    -- 0=Sunday, 6=Saturday
    EXTRACT(isodow  FROM created_at)    AS iso_day,        -- 1=Monday, 7=Sunday
    EXTRACT(week    FROM created_at)    AS iso_week,
    EXTRACT(quarter FROM created_at)    AS quarter,
    EXTRACT(epoch   FROM created_at)    AS unix_timestamp  -- seconds since 1970-01-01
FROM employees;

-- DATE_PART is functionally equivalent to EXTRACT
SELECT DATE_PART('year', hire_date) FROM employees;


/*============================================================
//AGE — Compute the interval between two dates/timestamps
============================================================*/

-- AGE(end, start) — returns a human-readable interval
SELECT
    AGE(NOW(), hire_date)                   AS tenure,         -- e.g. '3 years 4 months 12 days'
    AGE(termination_date, hire_date)        AS employment_span,
    AGE(birthdate)                          AS current_age     -- AGE(date) uses today as end date
FROM employees;

-- To get tenure as a plain number of years/months, combine with EXTRACT
SELECT EXTRACT(year FROM AGE(NOW(), hire_date)) AS years_employed FROM employees;


/*============================================================
//DATE ARITHMETIC — Add and subtract from dates and timestamps
============================================================*/

SELECT
    hire_date + 90                          AS ninety_day_mark,     -- add integer days to DATE
    hire_date + INTERVAL '3 months'         AS three_month_review,
    created_at - updated_at                 AS time_since_update,   -- TIMESTAMP - TIMESTAMP = INTERVAL
    CURRENT_DATE - hire_date                AS days_employed        -- DATE - DATE = INTEGER (days)
FROM employees;

-- Convert an interval to a specific unit using EXTRACT or division
SELECT
    EXTRACT(epoch FROM (NOW() - created_at)) / 3600   AS hours_elapsed,
    EXTRACT(epoch FROM (NOW() - created_at)) / 86400  AS days_elapsed
FROM orders;


/*============================================================
//TIMEZONE HANDLING
============================================================*/

-- AT TIME ZONE — convert a timestamp to a different timezone
-- TIMESTAMPTZ AT TIME ZONE 'zone' → returns TIMESTAMP in that zone
-- TIMESTAMP AT TIME ZONE 'zone'   → interprets it as being in that zone, returns TIMESTAMPTZ
SELECT
    NOW() AT TIME ZONE 'America/New_York'   AS eastern,
    NOW() AT TIME ZONE 'UTC'                AS utc,
    NOW() AT TIME ZONE 'Asia/Tokyo'         AS tokyo;

-- Store as UTC, display in user's timezone
SELECT created_at AT TIME ZONE 'America/Chicago' AS local_time FROM orders;

-- Useful timezone names: 'UTC', 'America/New_York', 'America/Chicago',
-- 'America/Los_Angeles', 'Europe/London', 'Asia/Tokyo', 'Australia/Sydney'

-- Set session timezone
SET timezone = 'America/New_York';
SHOW timezone;


/*============================================================
//DATE CONSTRUCTION & FORMATTING
============================================================*/

-- MAKE_DATE / MAKE_TIMESTAMP / MAKE_TIMESTAMPTZ — construct from parts
SELECT
    MAKE_DATE(2024, 3, 15),
    MAKE_TIMESTAMP(2024, 3, 15, 14, 30, 0),
    MAKE_TIMESTAMPTZ(2024, 3, 15, 14, 30, 0, 'America/New_York');

-- TO_DATE / TO_TIMESTAMP — parse a string using a format pattern
SELECT
    TO_DATE('15/03/2024', 'DD/MM/YYYY'),
    TO_TIMESTAMP('2024-03-15 14:30', 'YYYY-MM-DD HH24:MI');

-- TO_CHAR — format a date/timestamp as a string
-- Format codes: YYYY year, MM month, DD day, HH24 24h hour, HH12 12h hour,
--               MI minutes, SS seconds, Day full day name, Mon short month, TZ timezone
SELECT
    TO_CHAR(hire_date,   'Month DD, YYYY')          AS formatted_date,  -- 'March 15, 2024'
    TO_CHAR(created_at,  'YYYY-MM-DD HH24:MI:SS')   AS iso_format,
    TO_CHAR(CURRENT_DATE,'Day, DD Mon YYYY')         AS full_format,     -- 'Friday, 15 Mar 2024'
    TO_CHAR(NOW(),       'HH12:MI AM TZ')            AS time_with_tz
FROM employees;


/*============================================================
//GENERATE_SERIES — Generate a sequence of dates or timestamps
// Useful for filling gaps in time-series data or building date spine tables
============================================================*/

-- GENERATE_SERIES(start, stop, step_interval)
SELECT GENERATE_SERIES(
    '2024-01-01'::DATE,
    '2024-12-31'::DATE,
    INTERVAL '1 month'
) AS month_start;

-- Daily series as a derived table
SELECT gs::DATE AS day
FROM GENERATE_SERIES('2024-01-01', '2024-01-31', INTERVAL '1 day') AS gs;

-- Fill gaps: LEFT JOIN your data against a complete date series
SELECT
    ds.day,
    COALESCE(COUNT(o.order_id), 0) AS orders
FROM GENERATE_SERIES('2024-01-01', '2024-01-31', INTERVAL '1 day') AS ds(day)
LEFT JOIN orders AS o ON o.order_date = ds.day
GROUP BY ds.day
ORDER BY ds.day;