--------------------------------------------------------------------------------
-- PROJECT: KajoDataSpace Customer Analysis
-- SCRIPT: 01_Data_Ingestion_and_Cleaning
-- GOAL: Initial ETL from raw strings to structured numeric data
--------------------------------------------------------------------------------

-- 1. Infrastructure Setup
-- -----------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS kds_challenge;

-- Set search path to make the script cleaner, or use explicit schema naming
SET search_path TO kds_challenge, public;


-- 2. Raw Data Ingestion
-- -----------------------------------------------------------------------------
-- Drop existing table to ensure a clean start for the ingestion process
DROP TABLE IF EXISTS kds_transactions_raw;

CREATE TABLE kds_transactions_raw (
    transaction_date VARCHAR(20),
    client INT,
    amount_raw VARCHAR(20)
);

-- Note: Data import (COPY or INSERT) should happen here. 
-- SELECT * FROM kds_transactions_raw LIMIT 10;


-- 3. ETL & Data Transformation
-- -----------------------------------------------------------------------------
-- Transforming raw strings into proper Date and Numeric types
-- Replacing comma with dot for decimal consistency

DROP TABLE IF EXISTS kds_transactions_cleaned;

CREATE TABLE kds_transactions_cleaned AS
SELECT 
    client AS customer,
    -- Casting string to date using specific European format
    TO_DATE(transaction_date, 'DD.MM.YYYY') AS t_date,
    -- Fixing decimal separators and casting to precision numeric type
    REPLACE(amount_raw, ',', '.')::DECIMAL(10,2) AS amount
FROM kds_transactions_raw;


-- 4. Quality Assurance (QA)
-- -----------------------------------------------------------------------------
-- Visual check of the transformed data
SELECT * FROM kds_transactions_cleaned
ORDER BY customer, t_date 
LIMIT 100;

-- Basic check for nulls after transformation
SELECT 
    COUNT(*) AS total_rows,
    COUNT(t_date) AS valid_dates,
    COUNT(amount) AS valid_amounts
FROM kds_transactions_cleaned;
