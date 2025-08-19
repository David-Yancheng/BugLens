-- db-init/2_load_cases.sql
-- Runs on first container init

-- Ensure schema exists
CREATE SCHEMA IF NOT EXISTS public;

-- Make sure empty (idempotent)
TRUNCATE TABLE public.cases;

-- Load your filtered subset
COPY public.cases
FROM '/docker-entrypoint-initdb.d/cases_filtered.csv'
WITH (FORMAT csv, HEADER true);