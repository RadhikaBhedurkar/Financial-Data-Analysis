CREATE DATABASE finance;

USE finance;

-- customer

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    join_date DATE
);

INSERT INTO customers VALUES
(1, 'Rohan Mehta', 'rohan@example.com', '2022-05-12'),
(2, 'Priya Shah', 'priya@example.com', '2023-03-21'),
(3, 'Aarav Singh', 'aarav@example.com', '2023-08-17'),
(4, 'Neha Patel', 'neha@example.com', '2022-11-05');


-- accounts

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(50),
    balance DECIMAL(12,2),
    created_on DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO accounts VALUES
(101, 1, 'Savings', 50000, '2022-05-12'),
(102, 2, 'Current', 120000, '2023-03-21'),
(103, 3, 'Savings', 45000, '2023-08-17'),
(104, 4, 'Savings', 70000, '2022-11-05');


-- transactions

CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    account_id INT,
    txn_date DATE,
    txn_type VARCHAR(10),  -- 'Credit' or 'Debit'
    amount DECIMAL(10,2),
    category VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO transactions VALUES
(1, 101, '2024-01-10', 'Credit', 15000, 'Salary'),
(2, 101, '2024-01-12', 'Debit', 5000, 'Groceries'),
(3, 102, '2024-02-15', 'Debit', 20000, 'Rent'),
(4, 103, '2024-03-01', 'Credit', 18000, 'Investments'),
(5, 103, '2024-03-20', 'Debit', 3000, 'Utilities'),
(6, 104, '2024-04-01', 'Credit', 22000, 'Freelance'),
(7, 104, '2024-04-10', 'Debit', 4000, 'Shopping'),
(8, 101, '2024-04-15', 'Debit', 8000, 'Travel'),
(9, 102, '2024-04-18', 'Credit', 25000, 'Consulting'),
(10, 103, '2024-05-01', 'Debit', 7000, 'Bills');


-- investments

CREATE TABLE investments (
    investment_id INT PRIMARY KEY,
    customer_id INT,
    type VARCHAR(50),
    amount DECIMAL(10,2),
    start_date DATE,
    return_rate DECIMAL(5,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO investments VALUES
(1, 1, 'Mutual Fund', 30000, '2023-01-01', 12.5),
(2, 2, 'Fixed Deposit', 50000, '2022-09-10', 7.0),
(3, 3, 'Stock', 20000, '2023-06-20', 15.0),
(4, 4, 'Bonds', 40000, '2023-02-15', 9.5);


-- 1. Total Revenue, Expenses & Profit

SELECT 
    SUM(CASE WHEN txn_type = 'Credit' THEN amount ELSE 0 END) AS total_revenue,
    SUM(CASE WHEN txn_type = 'Debit' THEN amount ELSE 0 END) AS total_expenses,
    SUM(CASE WHEN txn_type = 'Credit' THEN amount ELSE 0 END) -
    SUM(CASE WHEN txn_type = 'Debit' THEN amount ELSE 0 END) AS net_profit
FROM transactions;


-- 2. Monthly Profit/Loss Trend

SELECT 
    DATE_FORMAT(txn_date, '%Y-%m') AS month,
    SUM(CASE WHEN txn_type = 'Credit' THEN amount ELSE -amount END) AS net_balance
FROM transactions
GROUP BY month
ORDER BY month;


-- 3. Top Spending Categories

SELECT 
    category,
    SUM(amount) AS total_spent
FROM transactions
WHERE txn_type = 'Debit'
GROUP BY category
ORDER BY total_spent DESC
LIMIT 5;


-- 4. Customer-wise Investment Returns

SELECT 
    c.name,
    i.type,
    i.amount,
    i.return_rate,
    ROUND(i.amount * i.return_rate / 100, 2) AS expected_return
FROM investments i
JOIN customers c ON i.customer_id = c.customer_id
ORDER BY expected_return DESC;


-- 5. Account Balance by Customer

SELECT 
    c.name,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
ORDER BY balance DESC;


-- 6. Detect Unusual Large Transactions

SELECT 
    txn_id, account_id, txn_date, txn_type, amount
FROM transactions
WHERE amount > (SELECT AVG(amount) + 2 * STDDEV(amount) FROM transactions);


-- 7. Show all customers who joined after January 1, 2023

SELECT * 
FROM customers
WHERE join_date > '2023-01-01';


-- 8. List all Debit transactions greater than ₹10,000

SELECT * 
FROM transactions
WHERE txn_type = 'Debit' AND amount > 10000;


-- 9. Count total transactions per account

SELECT account_id, COUNT(*) AS total_transactions
FROM transactions
GROUP BY account_id;


-- 10. Show unique transaction categories

SELECT DISTINCT category 
FROM transactions;


-- 11. Find the total credits and debits for each account

SELECT 
    account_id,
    SUM(CASE WHEN txn_type = 'Credit' THEN amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN txn_type = 'Debit' THEN amount ELSE 0 END) AS total_debit
FROM transactions
GROUP BY account_id;


-- 12. Display customers with balance greater than ₹60,000

SELECT c.name, a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.balance > 60000;


-- 13. Show all transactions done by ‘Rohan Mehta’

SELECT c.name, t.txn_id, t.txn_date, t.txn_type, t.amount, t.category
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE c.name = 'Rohan Mehta';


-- 14. Find the first transaction date for each account

SELECT account_id, MIN(txn_date) AS first_transaction
FROM transactions
GROUP BY account_id;


-- 15. Calculate average debit amount

SELECT ROUND(AVG(amount), 2) AS avg_debit_amount
FROM transactions
WHERE txn_type = 'Debit';


-- 16. Get top 3 highest debit transactions

SELECT *
FROM transactions
WHERE txn_type = 'Debit'
ORDER BY amount DESC
LIMIT 3;


-- 17. Monthly total credits and debits

SELECT 
    DATE_FORMAT(txn_date, '%Y-%m') AS month,
    SUM(CASE WHEN txn_type = 'Credit' THEN amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN txn_type = 'Debit' THEN amount ELSE 0 END) AS total_debit
FROM transactions
GROUP BY month
ORDER BY month;


-- 18. Find customer with the highest total spending

SELECT c.name, SUM(t.amount) AS total_spent
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.txn_type = 'Debit'
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;


-- 19. Calculate profit (credits - debits) for each customer

SELECT 
    c.name,
    SUM(CASE WHEN t.txn_type = 'Credit' THEN t.amount ELSE -t.amount END) AS net_profit
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.name;


-- 20. List accounts with no transactions

SELECT a.account_id, c.name
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.txn_id IS NULL;


-- 21. Total investment amount per customer

SELECT c.name, SUM(i.amount) AS total_investment
FROM investments i
JOIN customers c ON i.customer_id = c.customer_id
GROUP BY c.name;


-- 22. Find average return rate for each investment type

SELECT type, ROUND(AVG(return_rate), 2) AS avg_return
FROM investments
GROUP BY type;


-- 23. Show customers who invested more than ₹40,000

SELECT c.name, i.amount, i.type
FROM investments i
JOIN customers c ON i.customer_id = c.customer_id
WHERE i.amount > 40000;


-- 24. Identify customers with both Credit and Debit transactions

SELECT a.account_id, c.name
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY a.account_id, c.name
HAVING SUM(t.txn_type = 'Credit') > 0 AND SUM(t.txn_type = 'Debit') > 0;


-- 25. List transactions made in 2024

SELECT * 
FROM transactions
WHERE YEAR(txn_date) = 2024;


-- 26. Rank customers based on total balance

SELECT 
    c.name,
    a.balance,
    RANK() OVER (ORDER BY a.balance DESC) AS rank_position
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id;


-- 27. Find customers with overall loss (more expenses than income)

SELECT 
    c.name,
    SUM(CASE WHEN t.txn_type = 'Credit' THEN t.amount ELSE -t.amount END) AS net_profit
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.name
HAVING net_profit < 0;


-- 28. Detect unusual transactions (above mean + 2×std deviation)

SELECT *
FROM transactions
WHERE amount > (SELECT AVG(amount) + 2 * STDDEV(amount) FROM transactions);


-- 29. Calculate cumulative profit over time

SELECT 
    txn_date,
    SUM(CASE WHEN txn_type='Credit' THEN amount ELSE -amount END) 
        OVER (ORDER BY txn_date) AS cumulative_profit
FROM transactions;


-- 30. Get percentage share of each category in total spending

SELECT 
    category,
    ROUND(SUM(amount) * 100.0 / (SELECT SUM(amount) FROM transactions WHERE txn_type='Debit'), 2) AS percent_share
FROM transactions
WHERE txn_type = 'Debit'
GROUP BY category
ORDER BY percent_share DESC;


-- 31. Find the top 3 investment types by average return rate

SELECT 
    type,
    ROUND(AVG(return_rate), 2) AS avg_return
FROM investments
GROUP BY type
ORDER BY avg_return DESC
LIMIT 3;


-- 32. Compare customer spending to average spending

SELECT 
    c.name,
    SUM(t.amount) AS total_spending,
    (SELECT AVG(amount) FROM transactions WHERE txn_type='Debit') AS avg_spending
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.txn_type = 'Debit'
GROUP BY c.name;


-- 33. Show total expected investment returns per customer

SELECT 
    c.name,
    SUM(ROUND(i.amount * i.return_rate / 100, 2)) AS expected_returns
FROM investments i
JOIN customers c ON i.customer_id = c.customer_id
GROUP BY c.name
ORDER BY expected_returns DESC;


-- 34. Find month with highest net profit

SELECT 
    DATE_FORMAT(txn_date, '%Y-%m') AS month,
    SUM(CASE WHEN txn_type = 'Credit' THEN amount ELSE -amount END) AS net_profit
FROM transactions
GROUP BY month
ORDER BY net_profit DESC
LIMIT 1;


-- 35. Show customers whose investment return rate is above overall average

SELECT 
    c.name, i.type, i.return_rate
FROM investments i
JOIN customers c ON i.customer_id = c.customer_id
WHERE i.return_rate > (SELECT AVG(return_rate) FROM investments);


-- 36. Detect customers with more than 2 large debit transactions (> ₹10,000)

SELECT c.name, COUNT(*) AS large_txns
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.txn_type = 'Debit' AND t.amount > 10000
GROUP BY c.name
HAVING COUNT(*) > 2;
