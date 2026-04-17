--------------------------------------------------------------------------------
-- PROJECT: KajoDataSpace Customer Analysis
-- SCRIPT: 02_Final_Data_Preparation
-- GOAL: Creating a flat table for Power BI with Cohort and Segmentation logic
--------------------------------------------------------------------------------

-- 1. Create Final Analytical Table
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS kds_final_data;

CREATE TABLE kds_final_data AS 
WITH ranked_transactions AS (
    SELECT
        customer AS customer_id,
        t_date AS transaction_date,
        amount,
        -- Identifying the sequence of purchases for each customer
        ROW_NUMBER() OVER(PARTITION BY customer ORDER BY t_date ASC, amount DESC) AS trans_rank,
        -- Capturing the very first acquisition date for cohort grouping
        MIN(t_date) OVER(PARTITION BY customer) AS first_transaction_date
    FROM kds_transactions_cleaned 
)
SELECT 
    customer_id,
    first_transaction_date,
    DATE_TRUNC('month', first_transaction_date)::DATE AS cohort_month,
    transaction_date,
    DATE_TRUNC('month', transaction_date)::DATE AS transaction_month,
    
    -- Month Index: Calculating the time difference for Retention Matrix
    (EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', transaction_date)::DATE, 
                           DATE_TRUNC('month', first_transaction_date)::DATE)) * 12 +
     EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', transaction_date)::DATE, 
                            DATE_TRUNC('month', first_transaction_date)::DATE)))::INT AS month_number,
    
    amount,
    
    -- Life-cycle Segmentation: Distinguishing acquisition from retention
    CASE 
        WHEN trans_rank = 1 THEN 'New'
        ELSE 'Returning'
    END AS customer_segment,
    
    -- Price-based Segmentation: Based on price point distribution analysis
    CASE 
        WHEN amount >= 890 THEN 'Yearly/HighTicket'
        WHEN amount IN (89, 99, 169, 199, 249) THEN 'Standard'
        WHEN amount < 169 AND (amount % 10 != 0 OR amount < 89) THEN 'Promo'
        WHEN amount > 249 AND amount < 890 THEN 'Multi-month Bundle'
        ELSE 'Other/Standard'
    END AS price_segment

FROM ranked_transactions;


-- 2. Business Intelligence & Exploratory Queries
-- -----------------------------------------------------------------------------

-- Analyzing price frequency and lifecycle to identify potential pricing changes or promos
SELECT 
    amount, 
    COUNT(*) AS frequency, 
    MIN(transaction_date) AS first_seen, 
    MAX(transaction_date) AS last_seen
FROM kds_final_data
GROUP BY amount
ORDER BY frequency DESC;


-- 3. Data Quality & Validation Checks
-- -----------------------------------------------------------------------------

-- Summary of defined segments to ensure logic consistency
SELECT 
    price_segment, 
    MIN(amount) AS min_price, 
    MAX(amount) AS max_price, 
    ROUND(AVG(amount), 2) AS avg_price, 
    COUNT(DISTINCT amount) AS unique_price_points
FROM kds_final_data
GROUP BY price_segment
ORDER BY avg_price DESC;

-- Integrity check: Ensuring row count matches source
SELECT 
    (SELECT COUNT(*) FROM kds_final_data) AS final_rows,
    (SELECT COUNT(*) FROM kds_transactions_cleaned) AS source_rows;

-- Sanity check: New customers should only appear in month 0
SELECT DISTINCT 
    customer_segment, 
    month_number 
FROM kds_final_data 
WHERE customer_segment = 'New'
ORDER BY month_number;
