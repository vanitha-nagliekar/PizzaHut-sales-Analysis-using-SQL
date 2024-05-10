Create database PizzaHut;

select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;

--Retrieve the total number of orders placed.

Select count(order_id) as total_orders from orders;

--Calculate the total revenue generated from pizza sales.

select 
Round(Sum(order_details.quantity*pizzas.price),2) as Total_Revenue
from order_details
Join 
pizzas on order_details.Pizza_id=Pizzas.pizza_id;

--Identify the highest-priced pizza.

Select top 1 pizza_types.name, pizzas.price 
from pizza_types
Join
pizzas
on pizza_types.pizza_type_id = Pizzas.pizza_type_id
order by price desc;


--Identify the most common pizza size ordered.

select pizzas.size, count(order_details.quantity) as order_count from pizzas
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;

--List the top 5 most ordered pizza types along with their quantities.

select top 5 pizza_types.name, Sum(order_details.quantity) as Quantities 
from pizza_types
Join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
Join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by Quantities desc;

--Intermediate:
--Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, Sum(order_details.quantity) as quantity
from Pizza_types
join pizzas on Pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by quantity desc;

---Determine the distribution of orders by hour of the day.

select datepart(hour, order_time) as order_hour, count(order_id) as order_count
from orders
group by datepart(hour, order_time);

--Join relevant tables to find the category-wise distribution of pizzas.
select * from pizza_types;

select category, count(name) as Pizzas_count from pizza_types
group by category;

---Group the orders by date and calculate the average number of pizzas ordered per day.
;with order_quantity as
(select orders.order_date, sum(order_details.quantity) as total_orders
from orders
Join order_details on orders.order_id = order_details.order_id
group by orders.order_date)
select avg(total_orders) as average_pizzas_orderered_per_day from order_quantity;


--Determine the top 3 most ordered pizza types based on revenue.
select * from pizzas
select * from pizza_types

select top 3 pizza_types.name, Sum(order_details.quantity*pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue;

--Advanced:
--Calculate the percentage contribution of each pizza type to total revenue.
select * from pizzas
select * from pizza_types
select * from order_details

select pizza_types.category, Round(sum(order_details.quantity*pizzas.price)/(select sum(order_details.quantity*pizzas.price) as total_sales from order_details
join Pizzas on order_details.pizza_id=pizzas.pizza_id)*100, 2) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by revenue desc;

---Analyze the cumulative revenue generated over time.
select * from orders;
select * from order_details;
select * from Pizzas;

;with total_sales_on_each_day as
(
select orders.order_date, sum(order_Details.quantity*pizzas.price) as total_sales
from orders
join order_details on orders.order_id = order_details.order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id
group by orders.order_date
)
select order_date, sum(total_sales) over (order by order_date) as cumulative_revenue from total_sales_on_each_day;

---Determine the top 3 most ordered pizza types based on revenue for each pizza category.
;with revenue_by_Pizza_category as
(
select pizza_types.category, pizza_types.name, Sum(order_details.quantity*pizzas.price) as revenue,
rank() over (partition by category order by Sum(order_details.quantity*pizzas.price) desc) as rank
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category, pizza_types.name
)
select category, revenue from revenue_by_Pizza_category where rank <= 3

