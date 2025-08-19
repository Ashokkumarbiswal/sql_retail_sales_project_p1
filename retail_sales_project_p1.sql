create database sql_project_p1;
use sql_project_p1;

-- creating the table

create table retail_sales (
	transactions_id	int primary key,
    sale_date date,
    sale_time time,
    customer_id int,
    gender varchar(15),
    age int,
    category varchar(15),	
    quantity int,
    price_per_unit float,
    cogs float,
    total_sale float
);

-- Data cleaning

select * from retail_sales
where customer_id is null;

select * from retail_sales
where 
transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

delete from retail_sales
where 
transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

select count(*) from retail_sales;

-- Data exploration

-- How many records
select count(*) from retail_sales;

-- How many unique customers
select count(distinct customer_id) from retail_sales; 

-- Unique categories
select distinct category from retail_sales;

-- Query to retrieve all sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- Query to retrieve all transactions for clothing category and the quantity sold more than 10 in the month of Nov-2022
select * from retail_sales
where category = 'Clothing'
and sale_date between '2022-11-01' and '2022-11-30'
and quantity > 3 -- we have changed quantity to 3 as 10 was not part of the data
order by sale_date;

-- Query to calculate total sales & total orders for each category
select category, sum(total_sale) as total_sales, count(*) as total_orders
from retail_sales
group by category;

-- Query to find average age of customers purchased items from the 'Beauty' category
select round(avg(age),2) as average_age
from retail_sales
where category = 'Beauty';

-- Query to find all transactions where total sale is greater than 1000
select * from retail_sales
where total_sale > 1000;

-- Query to find the total number of transactions made by each gender in each category
select category, gender, count(transactions_id) as transaction_count
from retail_sales
group by category, gender
order by category;

-- Query to calculate average sale for each month. find out best selling month in each year
select * from (
		select year(sale_date) as sale_year,
		month(sale_date) as sale_month, 
		round(avg(total_sale),2) average_sales,
		rank() over(partition by year(sale_date) order by round(avg(total_sale),2) desc) as rnk
		from retail_Sales
		group by sale_year, sale_month) as x
where x.rnk = 1;

-- Query to find the top 5 customers based on highest total sales
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- Query to find the number of unique customers purchased items from each category
select category, count(distinct customer_id) as unique_customers
from retail_sales
group by category;

-- Query to create each shift and number of orders 
with shift_wise_orders as (
			select *,
			case
				when sale_time <= '12:00:00' then 'morning'
				when sale_time between '12:00:00' and '17:00:00' then 'afternoon'
				else 'evening'
				end as shift
			from retail_sales)            
select shift, count(transactions_id) as total_order from shift_wise_orders
group by shift
order by total_order desc; 

-- Solution using sub-query

select shift, count(transactions_id) as total_order from (
			select *,
			case
				when sale_time <= '12:00:00' then 'morning'
				when sale_time between '12:00:00' and '17:00:00' then 'afternoon'
				else 'evening'
				end as shift
			from retail_sales) x    
group by shift
order by total_order desc; 


-- End of project




