# Financial-Data-Analysis

📘 Project Overview

This project performs financial data analysis using SQL. It helps track income, expenses, transactions, and investments, generating insights such as profit/loss trends, customer spending behavior, and investment performance.

# Objective:

1.Analyze revenue and expenses

2.Compute monthly profit/loss trends

3.Detect large or unusual transactions

4.Summarize investment portfolios and expected returns

#  Database Schema
Tables

1. customers – Stores customer information

customer_id (INT, Primary Key)

name (VARCHAR)

email (VARCHAR)

join_date (DATE)

2. accounts – Customer account details

account_id (INT, Primary Key)

customer_id (INT, Foreign Key)

account_type (VARCHAR)

balance (DECIMAL)

created_on (DATE)

3. transactions – Records of financial transactions

txn_id (INT, Primary Key)

account_id (INT, Foreign Key)

txn_date (DATE)

txn_type (VARCHAR: Credit/Debit)

amount (DECIMAL)

category (VARCHAR)

4. investments – Customer investment portfolios

investment_id (INT, Primary Key)

customer_id (INT, Foreign Key)

type (VARCHAR)

amount (DECIMAL)

start_date (DATE)

return_rate (DECIMAL)

# Key Features / SQL Analyses

> Revenue and Expenses: Calculate total revenue, total expenses, and net profit.

> Monthly Profit/Loss Trend: Group transactions by month to analyze performance.

> Top Spending Categories: Identify which categories consume most funds.

> Customer Account Balance: Track balances of each account.

> Investment Portfolio Summary: Calculate expected returns based on investments.

> Detect Large Transactions: Identify abnormal or unusually large transactions.

> Customer Ranking: Rank customers based on total spending, profit, or investment returns.
