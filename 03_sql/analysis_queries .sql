-- Q1: Count transactions by status
SELECT status, COUNT(*) AS transaction_count
FROM cleaned_transactions
GROUP BY status;

-- Q2: Total captured GMV by merchant
SELECT merchant_name, SUM(amount_usd) AS total_gmv
FROM cleaned_transactions
WHERE status = 'CAPTURED'
GROUP BY merchant_name
ORDER BY total_gmv DESC;

-- Q3: Top 10 merchants by captured GMV
SELECT merchant_name, SUM(amount_usd) AS total_gmv
FROM cleaned_transactions
WHERE status = 'CAPTURED'
GROUP BY merchant_name
ORDER BY total_gmv DESC
LIMIT 10;

-- Q4: Daily GMV and successful transaction count
SELECT DATE(transaction_date) AS txn_date,
       SUM(amount_usd) AS daily_gmv,
       COUNT(CASE WHEN status = 'CAPTURED' THEN 1 END) AS successful_txn
FROM cleaned_transactions
GROUP BY DATE(transaction_date)
ORDER BY txn_date;

-- Q5: Merchants with chargeback ratio above 1%
SELECT merchant_name,
       SUM(CASE WHEN status = 'CHARGEBACK' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS chargeback_ratio
FROM cleaned_transactions
GROUP BY merchant_name
HAVING chargeback_ratio > 0.01;

-- Q6: Regions with avg risk score > 50 and more than 20 transactions
SELECT region,
       AVG(risk_score) AS avg_risk,
       COUNT(*) AS txn_count
FROM cleaned_transactions
GROUP BY region
HAVING AVG(risk_score) > 50 AND COUNT(*) > 20;

-- Q7: Users with 3+ failed or chargeback transactions on same day
SELECT user_id,
       DATE(transaction_date) AS txn_date,
       COUNT(*) AS failed_txn_count
FROM cleaned_transactions
WHERE status IN ('FAILED', 'CHARGEBACK')
GROUP BY user_id, DATE(transaction_date)
HAVING COUNT(*) >= 3;

-- Q8: Chargeback summary by merchant
SELECT merchant_name,
       COUNT(*) AS chargeback_count,
       COUNT(DISTINCT user_id) AS affected_users,
       SUM(amount_usd) AS chargeback_amount
FROM cleaned_transactions
WHERE status = 'CHARGEBACK'
GROUP BY merchant_name
ORDER BY chargeback_amount DESC;

