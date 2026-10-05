# Bank-Customer-Profitability-Analysis
Bank customer profitability and financial performance analysis using SQL and Power BI.
## Project Overview
This project analyzes bank customer profitability and financial performance using SQL and Power BI.
The analysis focuses on customer segmentation, loan performance, account balances, transaction activity, customer profitability, and high-value customers.
The project combines SQL data cleaning and analysis with an interactive Power BI dashboard to convert banking data into actionable business insights.

## Business Problem
Banks generate large amounts of customer, account, loan, and transaction data. However, raw data does not clearly identify profitable customers, high-performing loan categories, transaction trends, or customer engagement opportunities.
The objective of this project is to analyze banking data and provide insights that can support customer management, loan portfolio monitoring, and financial performance analysis.
The business problem addressed by this project is:
How can a bank use customer, loan, account, and transaction data to identify profitable customers and segments, understand loan and transaction performance, and improve overall financial performance?

## Objectives
- Analyze customer segments and customer behavior
- Measure customer profitability
- Analyze loan portfolio performance
- Analyze account balances
- Analyze transaction activity
- Identify high-value customers
- Identify customers without loans
- Identify customers without transaction activity
- Analyze monthly transaction trends
- Create an interactive Power BI dashboard

## Dataset
The project contains four main datasets:

### Customers
- Customer ID
- Customer Name
- Age
- Gender
- City
- Customer Segment
- Signup Date

### Accounts
- Account ID
- Customer ID
- Account Type
- Balance

### Loans
- Loan ID
- Customer ID
- Loan Type
- Loan Amount
- Interest Rate
- Interest Earned

### Transactions
- Transaction ID
- Account ID
- Transaction Date
- Transaction Type
- Amount
- Fee

## Data Cleaning
SQL was used to:
- Identify duplicate records
- Remove duplicate customers
- Remove duplicate accounts
- Remove duplicate loans
- Remove duplicate transactions
- Check missing values
- Validate customer ages
- Validate loan amounts
- Validate interest rates
- Validate transaction amounts
- Handle negative transaction fees
- Check foreign-key relationships
- Remove orphan transactions
- Create primary keys
- Create foreign keys

## SQL Analysis
The SQL analysis includes:
- Overall banking KPIs
- Customer segmentation
- Customer profitability
- Loan type analysis
- Account type analysis
- Transaction type analysis
- Monthly transaction trends
- High-value customers
- Customers with loans
- Customers without loans
- Customers without transactions
- Top customers by interest earned
- Top customers by transaction fees

## Power BI Dashboard

### Dashboard KPIs

- Total Customers: 10,000
- Total Accounts: 9,900
- Total Loans: 9,862
- Total Loan Amount: 24.87B
- Total Balance: 1.61B
- Estimated Profit: 467.03M

### Dashboard Visualizations
- Profit by Customer Segment
- Loan Portfolio by Loan Type
- Monthly Transaction Value
- Top 10 Customers by Estimated Profit
- Transaction Count by Transaction Type
- KPI Cards

## Key Insights
1. The bank has a customer base of 10,000 customers with 9,900 accounts and 9,862 loans.
2. The total loan portfolio is approximately 24.87B.
3. Estimated profit shown in the dashboard is approximately 467.03M.
4. Profitability is distributed across major customer segments including Affluent, Salary, Premium, and Mass Market.
5. Monthly transaction value shows a declining trend during the period represented in the dashboard.
6. A small group of customers generates relatively high estimated profit, while customers without loans or transaction activity represent potential opportunities for cross-selling and customer engagement.

## Recommendations
- Develop segment-specific customer strategies.
- Focus on retaining high-profit customers.
- Monitor loan profitability by loan type.
- Investigate the decline in monthly transaction value.
- Encourage digital transaction adoption.
- Identify eligible customers for loan cross-selling.
- Develop strategies to re-engage inactive customers.

- ## Tools & Technologies
- MySQL
- SQL
- Power BI
- Power Query
- Data Cleaning
- Data Analysis
- Data Visualization

- 
## Project Workflow
Raw Data
↓
SQL Data Cleaning
↓
Data Validation
↓
SQL Analysis
↓
Power BI Data Modeling
↓
Dashboard Development
↓
Business Insights
↓
Recommendations
