CREATE TABLE transactions (
    transaction_id INT,
    transaction_amount DECIMAL(10,2),
    login_attempts INT,
	device_risk_score DECIMAL(5,2),
	transfer_frequency INT,
	anomaly_score DECIMAL(5,2),
	account_age_days INT,
	transaction_time_hour INT,
	failed_transactions_last_30d INt,
    avg_monthly_balance DECIMAL(10,2),
	daily_transaction_count INT,
	geo_distance_km DECIMAL(10,2),
	session_duration_minutes INt,
	transaction_velocity_score DECIMAL(5,2),
	payment_channel VARCHAR(50),
    authentication_type VARCHAR(50),
    card_present_flag VARCHAR(10),
    international_transaction_flag VARCHAR(10),
    suspicious_ip_flag VARCHAR(10),
	fraud_flag VARCHAR(10)   
);

Select * from transactions;



--Total Records
Select COUNT(*) as Total_transactions from Transactions;


--Check Fraud Distribution
Select 
	fraud_flag,
	COUNT(*) AS total_transactions,
	CONCAT(
	ROUND(
	COUNT(*) * 100.0 / (SELECT COUNT(*)FROM transactions),
	2
	), 
	'%'
	) As Percentage
	FROM transactions
	GROUP BY fraud_flag;

--Fraud Rate KPI
SELECT fraud_flag, COUNT(*)
FROM transactions
GROUP BY fraud_flag;

--Fraud by Payment Channel

SELECT payment_channel,
       fraud_flag,
       COUNT(*) AS flag_by_payment
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY payment_channel,
         fraud_flag
ORDER BY flag_by_payment DESC;



--Fraud by Authentication Type
--Business Question:
--Which authentication method is safest?


SELECT authentication_type, fraud_flag,
	COUNT (*) AS fraud_cases
	FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY authentication_type,
		 fraud_flag
ORDER BY fraud_cases DESC;

--Fraud by International Transactions
Select    international_transaction_flag,
		  authentication_type,
		  fraud_flag,
COUNT (*) Fraud_by_International_Transactions
FROM      transactions
WHERE     fraud_flag = 'TRUE'
GROUP BY  international_transaction_flag,
		  authentication_type,
		  fraud_flag
ORDER BY Fraud_by_International_Transactions 
DESC;





--Suspicious IP Analysis
Select    suspicious_ip_flag,
		  payment_channel,
		  fraud_flag,
COUNT (*) suspicious_ip_address
FROM      transactions
WHERE     fraud_flag = 'TRUE'
GROUP BY  suspicious_ip_flag,
		  payment_channel,
		  fraud_flag
ORDER BY suspicious_ip_address
DESC;










--Average Risk Scores
SELECT fraud_flag,
ROUND(AVG(device_risk_score),2) AS avg_device_risk,
ROUND(AVG(anomaly_score),2) AS avg_anomaly_score,
ROUND(AVG(transaction_velocity_score),2) AS avg_velocity_score
FROM transactions
GROUP BY fraud_flag;






--High-Risk Hours
--Business Question
--At what time are frauds most likely to occur?
Select    transaction_time_hour,
		  fraud_flag,
COUNT (*) fraud_cases
FROM      transactions
WHERE     fraud_flag = 'TRUE'
GROUP BY   transaction_time_hour,
		  fraud_flag
ORDER BY   fraud_cases
DESC;



Select * from transactions;



--Account Age Analysis
--Business Question:
--Are new accounts more likely to commit fraud?
SELECT        payment_channel,
	         fraud_flag,
ROUND(AVG(account_age_days),0) account_age_detection
FROM         transactions
WHERE        fraud_flag = 'TRUE'
GROUP BY    payment_channel,
fraud_flag
ORDER BY   account_age_detection;






--Top 10 Largest Fraud Transactions
SELECT
    transaction_id,
    transaction_amount,
    DENSE_RANK() OVER(
        ORDER BY transaction_amount DESC
    ) AS ranking
FROM transactions
WHERE fraud_flag = 'TRUE'
LIMIT 10;

--Fraud loss
SELECT
    CONCAT(
        ROUND(SUM(transaction_amount) / 1000000.0, 2),
        ' M'
    ) AS fraud_loss
FROM transactions
WHERE fraud_flag = 'TRUE';

--Average Fraud Transaction Amount
SELECT
ROUND(AVG(transaction_amount),2) AS avg_fraud_amount
FROM transactions
WHERE fraud_flag = 'TRUE';



--Top 5 Riskiest Payment Channels
SELECT
payment_channel,
COUNT(*) AS fraud_cases
FROM transactions
WHERE fraud_flag = 'TRUE'
GROUP BY payment_channel
ORDER BY fraud_cases DESC
LIMIT 5;




--Create Fraud Risk Categories
SELECT
    transaction_id,
    anomaly_score,
    CASE
        WHEN anomaly_score >= 80 THEN 'High Risk'
        WHEN anomaly_score >= 50 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM transactions
;





















