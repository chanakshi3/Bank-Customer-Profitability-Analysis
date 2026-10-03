create database bank_profit;
use bank_profit;
select * from loans;
select (select count(*) from customers )as customers,
(select count(*) from accounts) as accounts,
(select count(*) from  loans) as loans,
(select count(*) from transactions)as transactions;

#check duplicates 
select customer_id, count(*) as duplicates from customers group by customer_id having count(*) >1;
select account_id,count(*) as duplicates from accounts group by account_id having count(*)>1;
select loan_id, count(*) as duplicates from loans group by loan_id having count(*) >1;
select transaction_id,count(*) as duplicates from transactions group by transaction_id having count(*)>1;

#remove duplicate
 CREATE TABLE customers_clean AS
SELECT
    customer_id,
    customer_name,
    age,
    gender,
    city,
    customer_segment,
    signup_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY customer_id
           ) AS rn
    FROM customers
) x
WHERE rn = 1;
select customer_id,count(*) as duplicates from customers_clean group by customer_id having count(*)>1;

CREATE TABLE accounts_clean AS
SELECT
    account_id,
    customer_id,
    account_type,
    balance
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY account_id
               ORDER BY account_id
           ) AS rn
    FROM accounts
) x
WHERE rn = 1;
select account_id,count(*) as duplicates from accounts_clean group by account_id having count(*)>1;

CREATE TABLE loans_clean AS
SELECT
    loan_id,
    customer_id,
    loan_type,
    loan_amount,
    interest_rate,
    interest_earned
FROM ( 
SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY loan_id
               ORDER BY loan_id
           ) AS rn
    FROM loans
) x
WHERE rn = 1;
select loan_id,count(*) as duplicates from loans_clean group by loan_id having count(*)>1;

CREATE TABLE transactions_clean AS
SELECT
    transaction_id,
    account_id,
    transaction_date,
    transaction_type,
    amount,
    fee
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY transaction_id
               ORDER BY transaction_id
           ) AS rn
    FROM transactions
) x
WHERE rn = 1;
select transaction_id,count(*) as duplicates from transactions_clean group by transaction_id having count(*)>1;

#check missing values
SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_name IS NULL) AS missing_name,
    SUM(age IS NULL) AS missing_age,
    SUM(gender IS NULL) AS missing_gender,
    SUM(city IS NULL) AS missing_city,
    SUM(customer_segment IS NULL) AS missing_segment,
    SUM(signup_date IS NULL) AS missing_signup_date
FROM customers_clean;
SELECT
    SUM(account_id IS NULL) AS missing_account_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(account_type IS NULL) AS missing_account_type,
    SUM(balance IS NULL) AS missing_balance
FROM accounts_clean;
SELECT
    SUM(loan_id IS NULL) AS missing_loan_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(loan_type IS NULL) AS missing_loan_type,
    SUM(loan_amount IS NULL) AS missing_loan_amount,
    SUM(interest_rate IS NULL) AS missing_interest_rate,
    SUM(interest_earned IS NULL) AS missing_interest_earned
FROM loans_clean;
SELECT
    SUM(transaction_id IS NULL) AS missing_transaction_id,
    SUM(account_id IS NULL) AS missing_account_id,
    SUM(transaction_date IS NULL) AS missing_date,
    SUM(transaction_type IS NULL) AS missing_type,
    SUM(amount IS NULL) AS missing_amount,
    SUM(fee IS NULL) AS missing_fee
FROM transactions_clean;
select * from loans_clean;
select * from accounts_clean where balance is null;

#data validations
SELECT *
FROM customers_clean
WHERE age < 18 ;
set sql_safe_updates =0;
update customers_clean set age =null where age <18;
select count(*) from customers_clean;
select * from customers_clean where age>100;
update customers_clean set age =null where age >100;
update customers_clean set age =0 where age is null;
#invlid loan amounts
select * from loans_clean where loan_amount<=0;
select count(*) as invalid_loan_amounts from loans_clean where loan_amount<=0;
delete from loans_clean where loan_amount<=0;

#invalid intrest rates
select * from loans_clean where intrest_rate<=0 or intrest_rate >30;
SELECT
    MIN(interest_rate) AS minimum_rate,
    MAX(interest_rate) AS maximum_rate,
    AVG(interest_rate) AS average_rate
FROM loans_clean;
SELECT
    interest_rate,
    COUNT(*) AS number_of_loans
FROM loans_clean
GROUP BY interest_rate
ORDER BY interest_rate;
SELECT *
FROM loans_clean
WHERE interest_rate <= 0;
SELECT *
FROM loans_clean
WHERE interest_rate > 20
ORDER BY interest_rate DESC;
SELECT *
FROM loans_clean
WHERE interest_rate <= 0
   OR interest_rate > 30;
   DELETE FROM loans_clean
WHERE interest_rate <= 0;

#invalid transactions
SELECT *FROM transactions_clean where amount<=0;

#invalid fees
select * from transactions_clean where fee<0;
update transactions_clean set fee=null where fee<0;
update transactions_clean set fee=0 where fee is null;

#check foerign key relationships
select a.* from accounts_clean a left join customers_clean c on a.customer_id=c.customer_id where c.customer_id is null;
select l.* from loans_clean l left join customers_clean c on c.customer_id=l.customer_id where c.customer_id is null;
select t.* from transactions_clean t left join accounts_clean a on a.account_id =t.account_id where a.account_id is null;
select count(*) as null_accounts_id from transactions_clean where account_id is null;
select t.account_id,count(*) as transaction_count from transactions_clean t left join accounts_clean a
on t.account_id = a.account_id where a.account_id is null group by t.account_id order by transaction_count desc;
SELECT
    t.account_id,
    COUNT(*) AS transaction_count
FROM transactions_clean t
JOIN accounts a
    ON t.account_id = a.account_id
LEFT JOIN accounts_clean ac
    ON t.account_id = ac.account_id
WHERE ac.account_id IS NULL
GROUP BY t.account_id
ORDER BY transaction_count DESC;
SELECT DISTINCT t.account_id
FROM transactions_clean t
LEFT JOIN accounts a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
#removing orphans
SELECT COUNT(*) AS orphan_transactions
FROM transactions_clean t
LEFT JOIN accounts_clean a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
SELECT COUNT(*) AS transactions_before
FROM transactions_clean;
DELETE t
FROM transactions_clean t
LEFT JOIN accounts_clean a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
SELECT COUNT(*) AS remaining_orphans
FROM transactions_clean t
LEFT JOIN accounts_clean a
    ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
SELECT COUNT(*) AS orphan_accounts
FROM accounts_clean a
LEFT JOIN customers_clean c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
SELECT COUNT(*) AS orphan_loans
FROM loans_clean l
LEFT JOIN customers_clean c
    ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
#create primary keys
alter table customers_clean add primary key (customer_id);
alter table accounts_clean add primary key(account_id);
alter table loans_clean add primary key(loan_id);
alter table transactions_clean add primary key (transaction_id);

#cretaing foreign keys
alter table accounts_clean add constraint fk_loans_customers foreign key(customer_id) references customers_clean(customer_id);
alter table loans_clean add constraint fk_loans_customer foreign key(customer_id) references customers_clean(customer_id);
alter table transactions_clean add constraint fk_transactions_account foreign key(account_id) references accounts_clean(account_id);

#final validation
SELECT COUNT(*) FROM customers_clean;
SELECT COUNT(*) FROM accounts_clean;
SELECT COUNT(*) FROM loans_clean;
SELECT COUNT(*) FROM transactions_clean;

#sql analysis
select count(*) as total_customers from customers_clean;
select count(*) as total_accounts from  accounts_clean;
select count(*) as total_loans from loans_clean;
select sum(loan_amount)as total_loan_value from loans_clean;
select sum(interest_earned) as total_intrest_earned from loans_clean;
select sum(amount) as total_transaction_value from transactions_clean;
select sum(fee) as total_fees from transactions_clean;

#customer_segmentation
select customer_segment,count(*) as customers from customers_clean group by customer_segment
order by customers desc;

#customer profitability
select c.customer_id,c.customer_name,c.customer_segment, coalesce(sum(l.interest_earned),0)as
interest_earned, coalesce(sum(t.fee),0)as transaction_fees, coalesce(sum(l.interest_earned),0)
+coalesce(sum(t.fee),0)as estimated_profit from customers_clean c left join loans_clean l on 
c.customer_id =l.customer_id left join accounts_clean a on c.customer_id=a.customer_id
left join transactions_clean t on a.account_id=t.account_id
group by  c.customer_id,c.customer_name,c.customer_segment order by estimated_profit desc;

#most profitable customer segments
select c.customer_segment,sum(l.interest_earned)as interest_earned, count(distinct c.customer_id)as customers
from customers_clean c left join loans_clean l on c.customer_id=l.customer_id
group by c.customer_segment order by interest_earned desc;
select* from loans_clean;

#loan type analysis
select loan_type, count(*) as total_loans, sum(loan_amount) as total_loan_amount, avg(interest_rate)
as avg_interset_rate, sum(interest_earned) as total_interest_earned from loans_clean group by loan_type
order by total_interest_earned desc;

#account type analysis
select account_type, count(*) as total_accounts, sum(balance) as total_balance, avg(balance) as avg_balance
from accounts_clean group by account_type order by total_balance desc;

#transaction type analysis
select transaction_type, count(*) as transaction_count, sum(amount) as transaction_value,
sum(fee) as total_fees from transactions_clean group by transaction_type order by transaction_value desc;

#monthly transaction trend
select year(transaction_date) as transaction_year,
month(transaction_date) as transaction_month,
count(*) as tranactions, sum(amount) as transaction_value, sum(fee) as fees from transactions_clean
group by year(transaction_date) ,
month(transaction_date) order by transaction_year,transaction_month;

#high value customers
select c.customer_id, c.customer_name, c.customer_segment, sum(balance) as total_balance 
from customers_clean c join accounts_clean a on c.customer_id = a.customer_id
group by c.customer_id, c.customer_name, c.customer_segment order by total_balance desc limit 20;

#customers with loan
select c.customer_id, c.customer_name, count(l.loan_id) as number_of_loans,
sum(l.loan_amount) as total_loan_amount, sum(l.interest_earned) as total_interest from customers_clean c
join loans_clean l on c.customer_id =l,customer_id
group by c.customer_id, c.customer_name order by total_interest desc;

#customers with no loan
select c.customer_id, c.customer_name,c.customer_segment from customers_clean c left join loans_clean l on
c.customer_id=l.customer_id where l.loan_id is null;

#customers with no transactions 
select distinct c.customer_id, c.customer_name from customers_clean c join accounts_clean a
on c.customer_id=a.customer_id left join transactions_clean t on a.account_id = t.account_id
where t.transaction_id is null;

#top 10 customers by interset earned
select c.customer_id, c.customer_name, sum(l.interest_earned) as interest_earned from customers_clean c
join loans_clean l on c.customer_id= l.customer_id group by c.customer_id, c.customer_name
order by interest_earned desc limit 10;

#  top 10 customers by transaction fees
select c.customer_id,c.customer_name,sum(t.fee) as total_fees from customers_clean c join
accounts_clean a on c.customer_id = a.customer_id join transactions_clean t
on a.account_id=t.account_id group by c.customer_id, c.customer_name order by total_fees
desc limit 10;

#customer profitablity classification
select c.customer_id,c.customer_name,c.customer_segment,
coalesce(l.interest_earned,0) as interest_earned,
coalesce(t.transaction_fees,0) as transaction_fees,
coalesce(l.interest_earned,0)+coalesce(t.transaction_fees,0) as profit
from customers_clean c left join(
select customer_id, sum(interest_earned)as interest_earned from loans_clean group by customer_id)l
on c.customer_id=l.customer_id left join( select a.customer_id,sum(t.fee) as transaction_fees 
from accounts_clean a join transactions_clean t on a.account_id= t.account_id
group by a.customer_id)t on c.customer_id=t.customer_id;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT account_id) AS unique_accounts
FROM accounts_clean;