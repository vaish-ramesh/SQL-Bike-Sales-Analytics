/*
=============================================================
1. Change Over Time Analysis
=============================================================
*/

-- Analyze yearly sales changes to gain detailed insights into performance across individual years

select 
extract (year from order_date) as order_year, 
sum(sales_amount) as total_sales,
count (distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from sales
where order_date is not null
group by order_year
order by order_year;

-- Monthly Perfomance Analysis helps to understand seasonality

select 
extract (month from order_date) as order_month, 
sum(sales_amount) as total_sales,
count (distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from sales
where order_date is not null
group by order_month
order by order_month;

-- Analyze monthly sales trends across all years

select 
date_trunc('month', order_date) as order_date, 
sum(sales_amount) as total_sales,
count (distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from sales
where order_date is not null
group by date_trunc('month', order_date)
order by date_trunc('month', order_date);

/*
=============================================================
2. Cumulative Analysis
=============================================================
*/

-- Calculating the total sales per month and the running total sales over time

select
order_month,
total_sales,
sum(total_sales) over(order by order_month) as running_total_sales
from (
select 
date_trunc('month',order_date) as order_month,
sum(sales_amount) as total_sales
from sales
where order_date is not null
group by order_month
order by order_month);

-- Analyze monthly performance trends through running total sales and moving average prices

select
order_month,
total_sales,
sum(total_sales) over(order by order_month) as running_total_sales,
avg(avg_price) over(order by order_month) as moving_average_price
from (
select 
date_trunc('month',order_date) as order_month,
sum(sales_amount) as total_sales,
avg(price) as avg_price
from sales
where order_date is not null
group by order_month
order by order_month);

/*
=============================================================
3. Performance Analysis
=============================================================
*/

-- Analysis of yearly performance of products by comparing current, average and previous sales

with yearly_prod_sales as (
select 
extract (year from s.order_date) as order_year,
p.product_name,
sum(s.sales_amount) as current_sales
from sales as s
left join products as p
on s.product_key = p.product_key
where s.order_date is not null
group by order_year, p.product_name)

select order_year,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name) as diff_avg,
case 
	when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'Above Avg'
	when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'Below Avg'
	else 'Avg'
end as avg_change,
lag(current_sales) over(partition by product_name order by order_year) as prev_year_sales,
current_sales - lag(current_sales) over(partition by product_name order by order_year) as diff_py,
case 
	when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
	when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
	else 'No change'
end as py_change
from yearly_prod_sales
order by product_name, order_year;

/*
=============================================================
4. Part-To_Whole Analysis or Proportional Analysis
=============================================================
*/

-- Categories that contribute the most to the overall sales

with category_sales as (
select
category,
sum(sales_amount) as total_sales
from sales as s
left join products as p
on s.product_key = p.product_key
group by category)

select 
category,
total_sales,
sum(total_sales) over() as overall_sales,
round((total_sales/sum(total_sales) over()) * 100, 2) as total_percentage
from category_sales;

/*
=============================================================
5. Data Segmentation
=============================================================
*/

-- Segmenting and counting products into cost ranges 

with product_segments as (
select 
product_key,
product_name,
cost,
case
	when cost < 100 then 'below 100'
	when cost between 100 and 500 then '100-500'
	when cost between 500 and 1000 then '500-1000'
	else 'Above 1000'
end as cost_range
from products)

select 
cost_range,
count(product_key) as total_products
from product_segments
group by cost_range
order by total_products desc;
