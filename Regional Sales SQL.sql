use regional_sales_db;

-- 📊 Exploratory Analysis
# Q1 What is the total revenue generated across all orders?

select sum(revenue) total_revenue from regional_sales;

## Q2 What is the average revenue per order?

select * from regional_sales;
select round(Avg(revenue),2) from regional_sales;

## Q3.Which product has the highest total sales?
select product_name, 
	   sum(total_profit) as total_sales
from regional_sales
group by product_name;
	

## Q4 What is the total order quantity by region?

select * from regional_sales;
select region, 
	   sum(order_quantity) as Total_order_quantity
from regional_sales
group by 1;

## Q5 What is the average unit price of each product?
 select product_name,
		round(avg(unit_price),2)
from regional_sales
group by product_name;
 
 
## Q6 Which customers have placed the highest number of orders?

select distinct(count(*)) from regional_sales;

select customer_name,
	   count(order_number) as Total_orders
from regional_sales
group by 1
order by 2 desc
limit 5;

## or uisng TOP N function wghich is not compliant with MySql or postgresql
-- select Top 5 customer_name,
-- count(order_number) as Total_orders
-- from regional_sales
-- group by 1
-- order by 2 desc;##
----------------------------------------------
-- ⏰ Time Series Analysis
## Q7 What is the monthly revenue trend across all regions?
select region,
	   month(order_date),
	   sum(revenue) as total_revenue
from regional_sales
group by 1,2
order by 3 desc;

# Q8 Which month had the highest total profit?
select month_name,
	   sum(total_profit) as Total_profit
from regional_sales
group by 1
order by 2 desc
Limit 1;

## Q9 How does revenue change by order_month and region?

select month_name,	
	   region,
       sum(revenue) as total_revenue
from regional_sales
group by 1,2
;

# Q10 What is the average profit margin per month?

select month_name,
	   avg(profit_margin_pct) as avg_profit_margin
from regional_sales
group by 1;
 ---------------------------------------------------------
##  🧮 Aggregations & Grouping
# Q 11.What is the total profit by channel?
select channel,
	   sum(total_profit) AS Total_profit
from regional_sales
group by 1;

# Q12.What is the average total_unit_cost per state?

select state,
	   sum(total_unit_cost) as Total_unit_cost
from regional_sales
group by 1;

# Q13.Show total sales grouped by product and region.

select product_name,
	   region,
       sum(total_profit) as Total_Sales
from regional_sales
group by 1,2;

# Q14.How many orders were placed in each county?

select county,
	   count(order_number) as Order_count
from regional_sales
group by 1;

---------------------------------------------------
## 🗃️ Filtering & Conditions
# Q15.List all orders where the profit margin is below 10%.
select profit_margin_pct 
from regional_sales
where profit_margin_pct < 20;

# Q16.Find orders with revenue greater than ₹1,00,000.
select Order_number,
	   revenue
from regional_sales
where revenue > 100000;

# Q17.List the top 5 orders based on revenue.

select Order_number,
	   sum(revenue) as Total_rvenue
from regional_sales 
group by 1
order by 2 desc
limit 5;


# Q18.Show orders made through the "Retail" channel in the South region.

select *
from regional_sales
where channel = 'Retail' and region ='south';

------------------------------------------------------
# Windows Functions
# Q19.Rank products by revenue within each region.
select product_name,
	   region,
       revenue,
       rank() over(partition by region order by revenue) as rnk
from regional_sales ;

# Q19.What is the cumulative monthly revenue for each product?

select product_name,
	   month_name,
       sum(revenue) over(partition by product_name order by month_name) as cumulative_revenue
from regional_sales;

# Q20.What is the difference in profit between each order and the regional average?

select order_number,
	   total_profit - avg(total_profit) over(partition by region) as profit_difference
from regional_sales;
       
# Q21. Find the previous and necxt orders revenue per each product
SELECT product_name, order_date, revenue,
       LAG(revenue) OVER (PARTITION BY product_name ORDER BY order_date) AS previous_revenue,
       LEAD(revenue) OVER (PARTITION BY product_name ORDER BY order_date) AS next_revenue
FROM regional_sales;

# Q24. Show percentage contribution of each order to monthly revenue.

select order_number,
	   month_name,
       revenue,
	   round(100*revenue/sum(revenue) over(partition by month_name),2)as revenue_pct
from regional_sales;