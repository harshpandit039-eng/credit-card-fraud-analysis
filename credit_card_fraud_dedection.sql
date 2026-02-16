# creating our database
=========================
create database Card_Fraud
========================
# using database
use Card_Fraud
=========================
# creating table
create table Transactions(
transaction_id INT PRIMARY KEY,
amount DECIMAL(10,2),
transaction_hour INT,
merchant_category VARCHAR(50),
foreign_transaction INT,
location_mismatch INT,
device_trust_score INT,
velocity_last_24h INT,
cardholder_age INT,
is_fraud INT
);
==============================
# show everything in this table
select * from Transactions
==============================
# What is the total number of transactions in the dataset?
select count(Transaction_id) from Transactions 
=========================================
# Total Fraud Transactions
select is_fraud ,count(*) as fraud_count
from Transactions
group by is_fraud
==========================================
=====================================================================================

# What is the overall fraud rate (percentage) in the dataset?
select(count( case when is_fraud = 1 then 1 end)*100.0 /count(*)) as fraud_percentage
from transactions
=======================================================================================
======================================================================
# How many transactions occurred in each merchant category?

select merchant_category,sum(is_fraud) as total_fraud_by_category
from transactions
group by merchant_category
======================================================================
======================================================================
# What is the total number of transactions, total fraudulent transactions, 
#and fraud percentage grouped by foreign transaction status?
select foreign_transaction,count(*) as total_transaction,
sum(is_fraud)as total_fraud,
sum(is_fraud)*100.0/count(*)as fraud_percentage
from transactions 
group by foreign_transaction
=======================================================================
===================================================================================================
#divide Device trust score into 3 categories low,medium,high and find percentage for each category

select case when device_trust_score < 40 then 'low'
			when device_trust_score between 40 and 70 then 'medium'
		    else 'high'
            end as score_level,
			count(*) as total_transactions,
			sum(is_fraud) as total_fraud,
			round(sum(is_fraud),2)*100.0/count(*)as fraud_percentage
from transactions
group by  case 
				when device_trust_score < 40 then 'low'
                when device_trust_score between 40 and 70 then 'medium'
		    else 'high'
		end;
===============================================================================
===============================================================================
#Find fraud percentage for transactions where foreign_transaction = 1,
#AND location_mismatch = 1,AND device_trust_score < 4:

select count(*) as total_percentage,sum(is_fraud)as total_fruad,
sum(is_fraud)*100.0/count(*)
from transactions
where foreign_transaction=1 and location_mismatch=1 and device_trust_score<40
=================================================================================
# Show top 3 merchant categories with highest fraud percentage.

select merchant_category,count(*) as total_transaction,sum(is_fraud)as total_fraud,
sum(is_fraud)*100.0/count(*) as fraud_percentage
from transactions
group by merchant_category
having sum(is_fraud)*100.0/count(*)>2
order by fraud_percentage desc
limit 3
======================================================================================
#Compare fraud rate between foreign transactions and domestic transactions.

select foreign_transaction,
       count(*) as total_transaction,
       sum(is_fraud) as total_fraud,
       sum(is_fraud) * 100.0 / count(*) as fraud_percentage
from transactions
group by foreign_transaction;
========================================================================================
======================================================================================
#How can customers be segmented into age groups (Young, Adult, Middle Age, Senior)?

select case 
            when cardholder_age between 18 and 25 then 'young'
            when cardholder_age between 26 and 40 then 'adult'
            when cardholder_age between 41 and 60 then 'middle age'
            else 'senior'
		end as age_group,
			count(*) as total_transaction,
			sum(is_fraud) as total_fraud,
			sum(is_fraud)*100.0/count(*) as fraud_percentage
from transactions
group by case 
            when cardholder_age between 18 and 25 then 'young'
            when cardholder_age between 26 and 40 then 'adult'
            when cardholder_age between 41 and 60 then 'middle age'
            else 'senior'
		end;
===========================================================================
============================================================================
#Show fraud percentage by age group But only for foreign transactions

select 
      case 
			when cardholder_age between 18 and 25 then 'young'
			when cardholder_age between 26 and 40 then 'adult'
			when cardholder_age between 41 and 60 then 'middle age'
		  else 'senior'
		end as age_group,
			count(*) as total_transaction,
			sum(is_fraud) as total_fraud,
			sum(is_fraud)*100.0/count(*) as fraud_percentage
from transactions
where foreign_transaction=1
group by case 
            when cardholder_age between 18 and 25 then 'young'
            when cardholder_age between 26 and 40 then 'adult'
            when cardholder_age between 41 and 60 then 'middle age'
            else 'senior'
		end;
========================================================================================
========================================================================================
# Show top 3 most risky age groups (based on fraud percentage) for foreign transactions.
 select case 
            when cardholder_age between 18 and 25 then 'young'
            when cardholder_age between 26 and 40 then 'adult'
            when cardholder_age between 41 and 60 then 'middle age'
		else 'senior'
	end as age_group,
			count(*) as total_transaction,
			sum(is_fraud) as total_fraud,
			sum(is_fraud)*100.0/count(*) as fraud_percentage
from transactions
where foreign_transaction=1
group by case 
            when cardholder_age between 18 and 25 then 'young'
            when cardholder_age between 26 and 40 then 'adult'
            when cardholder_age between 41 and 60 then 'middle age'
            else 'senior'
		end
order by fraud_percentage desc
limit 3
=====================================================================================
=========================================================================================
#What are the top 5 highest fraud percentage combinations based on foreign transaction
# and device trust score?
select foreign_transaction,
		case 
            when device_trust_score < 40 then 'Low'
            when device_trust_score between 40 and 70 then 'Medium'
		else 'High'
	end as device_score,
			count(*) as total_transaction,
			sum(is_fraud) as total_fraud,
			sum(is_fraud)*100.0/count(*) percentage_count
from transactions
group by foreign_transaction,
case
	when device_trust_score < 40 then 'Low'
	when device_trust_score between 40 and 70 then 'Medium'
  else 'High'
end
order by percentage_count desc
limit 5
======================================================================================




















