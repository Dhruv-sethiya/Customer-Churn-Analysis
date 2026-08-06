CREATE DATABASE customer_churn;
USE customer_churn;
SELECT COUNT(*) AS total_customers
FROM staging_customer_churn;
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM staging_customer_churn;
SELECT
    churn_label,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY churn_label;
SELECT
    ROUND(
        SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM staging_customer_churn;
SELECT
    ROUND(SUM(total_charges),2) AS total_revenue
FROM staging_customer_churn;
SELECT
    ROUND(AVG(monthly_charges),2) AS average_monthly_charge
FROM staging_customer_churn;
SELECT
    ROUND(AVG(tenure_months),2) AS average_tenure
FROM staging_customer_churn;
SELECT
    MAX(monthly_charges) AS highest_monthly_charge
FROM staging_customer_churn;
SELECT
    MIN(monthly_charges) AS lowest_monthly_charge
FROM staging_customer_churn;
SELECT
    ROUND(SUM(total_charges),2) AS revenue_lost
FROM staging_customer_churn
WHERE churn_label = 'Yes';
-- PART 2 : CUSTOMER SEGMENTATION ANALYSIS
CREATE DATABASE IF NOT EXISTS customer_churn;
USE customer_churn;
SHOW TABLES;
USE customer_churn;
SELECT
    gender,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY gender;
-- Query 12 : Churn by Gender

SELECT
    gender,
    churn_label,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY gender, churn_label
ORDER BY gender, churn_label;
-- Query 13 : Customer Distribution by Contract Type

SELECT
    contract,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY contract
ORDER BY total_customers DESC;
-- Query 14 : Churn by Contract Type

SELECT
    contract,
    churn_label,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY contract, churn_label
ORDER BY contract, churn_label;
-- Query 15 : Customer Distribution by Internet Service

SELECT
    internet_service,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY internet_service
ORDER BY total_customers DESC;
-- Query 16 : Churn by Internet Service

SELECT
    internet_service,
    churn_label,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY internet_service, churn_label
ORDER BY internet_service, churn_label;
-- Query 17 : Customer Distribution by Payment Method

SELECT
    payment_method,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY payment_method
ORDER BY total_customers DESC;
-- Query 18 : Churn by Payment Method

SELECT
    payment_method,
    churn_label,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY payment_method, churn_label
ORDER BY payment_method, churn_label;
-- Query 19 : Customer Distribution by Senior Citizen

SELECT
    senior_citizen,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY senior_citizen;
-- Query 20 : Churn by Senior Citizen

SELECT
    senior_citizen,
    churn_label,
    COUNT(*) AS total_customers
FROM staging_customer_churn
GROUP BY senior_citizen, churn_label
ORDER BY senior_citizen, churn_label;
-- Query 21 : Churn Rate by Contract Type

SELECT
    contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM staging_customer_churn
GROUP BY contract
ORDER BY churn_rate DESC;
-- CREATE DATABASE customer_churn;
-- USE customer_churn;
-- ============================================
-- Query 22 : Revenue by Contract Type
-- ============================================

SELECT
    contract,
    ROUND(SUM(total_charges),2) AS total_revenue
FROM staging_customer_churn
GROUP BY contract
ORDER BY total_revenue DESC;
-- ============================================
-- Query 23 : Average Monthly Charge by Contract
-- ============================================

SELECT
    contract,
    ROUND(AVG(monthly_charges),2) AS average_monthly_charge
FROM staging_customer_churn
GROUP BY contract
ORDER BY average_monthly_charge DESC;
-- ============================================
-- Query 24 : Average Tenure by Contract
-- ============================================

SELECT
    contract,
    ROUND(AVG(tenure_months),2) AS average_tenure
FROM staging_customer_churn
GROUP BY contract
ORDER BY average_tenure DESC;
-- ============================================
-- Query 25 : Revenue Lost by Contract
-- ============================================

SELECT
    contract,
    ROUND(SUM(total_charges),2) AS revenue_lost
FROM staging_customer_churn
WHERE churn_label='Yes'
GROUP BY contract
ORDER BY revenue_lost DESC;-- ============================================
-- Query 26 : Top 10 Customers
-- ============================================

SELECT
    customer_id,
    gender,
    contract,
    total_charges
FROM staging_customer_churn
ORDER BY total_charges DESC
LIMIT 10;
-- ============================================
-- Query 27 : Average Monthly Charge by Internet Service
-- ============================================

SELECT
    internet_service,
    ROUND(AVG(monthly_charges),2) AS average_monthly_charge
FROM staging_customer_churn
GROUP BY internet_service
ORDER BY average_monthly_charge DESC;
-- ============================================
-- Query 28 : Top Churn Reasons
-- ============================================

SELECT
    churn_reason,
    COUNT(*) AS total_customers
FROM staging_customer_churn
WHERE churn_reason IS NOT NULL
GROUP BY churn_reason
ORDER BY total_customers DESC;
-- ============================================
-- Query 29 : Average CLTV by Contract
-- ============================================

SELECT
    contract,
    ROUND(AVG(cltv),2) AS average_cltv
FROM staging_customer_churn
GROUP BY contract
ORDER BY average_cltv DESC;
-- ============================================
-- Query 29 : Average CLTV by Contract
-- ============================================

SELECT
    contract,
    ROUND(AVG(cltv),2) AS average_cltv
FROM staging_customer_churn
GROUP BY contract
ORDER BY average_cltv DESC;

-- ============================================
-- Query 31 : Rank Customers by Total Charges
-- ============================================

SELECT
    customer_id,
    total_charges,
    RANK() OVER (ORDER BY total_charges DESC) AS customer_rank
FROM staging_customer_churn;
-- ============================================
-- Query 32 : Dense Rank by CLTV
-- ============================================

SELECT
    customer_id,
    cltv,
    DENSE_RANK() OVER (ORDER BY cltv DESC) AS cltv_rank
FROM staging_customer_churn;
-- ============================================
-- Query 32 : Dense Rank by CLTV
-- ============================================

SELECT
    customer_id,
    cltv,
    DENSE_RANK() OVER (ORDER BY cltv DESC) AS cltv_rank
FROM staging_customer_churn;
-- ============================================
-- Query 34 : Top 5 Customers using CTE
-- ============================================

WITH ranked_customers AS
(
    SELECT
        customer_id,
        total_charges,
        RANK() OVER(ORDER BY total_charges DESC) AS customer_rank
    FROM staging_customer_churn
)

SELECT *
FROM ranked_customers
WHERE customer_rank <= 5;
-- ============================================
-- Query 35 : Average Charges by Contract
-- ============================================

WITH contract_summary AS
(
    SELECT
        contract,
        AVG(monthly_charges) AS avg_charge
    FROM staging_customer_churn
    GROUP BY contract
)

SELECT *
FROM contract_summary
ORDER BY avg_charge DESC;
-- ============================================
-- Query 36 : Customer Summary View
-- ============================================

CREATE OR REPLACE VIEW customer_summary AS

SELECT
    customer_id,
    gender,
    contract,
    internet_service,
    monthly_charges,
    total_charges,
    churn_label
FROM staging_customer_churn;
SELECT *
FROM customer_summary
LIMIT 10;
SELECT *
FROM customer_summary
LIMIT 10;
SELECT *
FROM churn_summary;
-- ============================================
-- Query 38 : Running Revenue
-- ============================================

SELECT
    customer_id,
    total_charges,
    SUM(total_charges)
        OVER(ORDER BY total_charges DESC) AS running_revenue
FROM staging_customer_churn;
-- ============================================
-- Query 38 : Running Revenue
-- ============================================

SELECT
    customer_id,
    total_charges,
    SUM(total_charges)
        OVER(ORDER BY total_charges DESC) AS running_revenue
FROM staging_customer_churn;
-- ============================================
-- Query 39 : Revenue Contribution
-- ============================================

SELECT
    customer_id,
    total_charges,
    ROUND(
        total_charges * 100 /
        SUM(total_charges) OVER(),
        2
    ) AS revenue_percentage
FROM staging_customer_churn;
-- ============================================
-- Query 39 : Revenue Contribution
-- ============================================

SELECT
    customer_id,
    total_charges,
    ROUND(
        total_charges * 100 /
        SUM(total_charges) OVER(),
        2
    ) AS revenue_percentage
FROM staging_customer_churn;
