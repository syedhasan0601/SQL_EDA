-- Q1.What is the total amount each customer spent at the restaurant?

select s.customer_id ,sum(m.price) as total_amt_spent 
from sales s inner join menu m on s.product_id = m.product_id
group by s.customer_id; 
 
 -- Q2.How many days has each customer visited the restaurant? 
 
select customer_id,count(distinct(order_date)) from sales group by customer_id;

-- Q3.What was the first item from the menu purchased by each customer?
with CTE as (
select customer_id,
order_date,product_name,
RANK() over (partition by customer_id order by order_date asc) as rnk,
row_number() over (partition by customer_id order by order_date asc) as rn
from sales s inner join menu as M on S.product_id = M.product_id 
)

select customer_id,product_name from CTE where rnk =  1;

-- to filter or use window function i.e. rank in where clause use CTE approach

-- Q4.What is the most purchased item on the menu and how many times was it purchased by all customers?
 select M.product_name,count(s.product_id) as no_of_orders from sales s join menu m
 on m.product_id = s.product_id
 group by m.product_name
order by no_of_orders desc limit 1;

-- Q5.Which item was the most popular for each customer?

with cte1 as (
select s.customer_id,m.product_name,count(s.product_id) as no_of_orders from sales s join menu m
on m.product_id = s.product_id
group by s.customer_id,m.product_name
order by no_of_orders desc )

select customer_id,product_name ,
rank() over (partition by customer_id order by no_of_orders desc) as rnk
from cte1;

-- Q6.Which item was purchased first by the customer after they became a member?
with cte2 as (
select s.customer_id,
s.order_date,mem.join_date,m.product_name,
RANK() over (partition by s.customer_id order by s.order_date asc) as rnk
from sales s inner join menu as M on S.product_id = M.product_id 
inner join members mem on s.customer_id = mem.customer_id
where s.order_date >= mem.join_date
)

select customer_id,order_date,join_date,product_name from cte2 where rnk =  1;

-- Q7.Which item was purchased just before the customer became a member?
with cte3 as (
select s.customer_id,
s.order_date,mem.join_date,m.product_name,
RANK() over (partition by s.customer_id order by s.order_date asc) as rnk
from sales s inner join menu as M on S.product_id = M.product_id 
inner join members mem on s.customer_id = mem.customer_id
where s.order_date < mem.join_date
)

select customer_id,product_name,order_date,join_date from cte3 where rnk =  1;

-- Q8.What is the total items and amount spent for each member before they became a member?
with memberdata as 
(select members.customer_id,s.product_id,m.product_name,s.order_date,members.join_date,
m.price from sales s inner join menu m 
on s.product_id = m.product_id
left join members 
on s.customer_id = members.customer_id
where s.order_date < members.join_date )

select customer_id,sum(price),count(distinct(product_name)) from memberdata group by customer_id;

-- Q9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
-- how many points would each customer have?

with points  as (
select s.customer_id ,s.product_id,
case
	when m.product_name = 'sushi' then (price * 20) 
	when m.product_name in ('curry','ramen') then price * 10
    else price
end as points
from sales s inner join menu m on s.product_id = m.product_id )

select customer_id , sum(points) from points group by customer_id;

-- Q10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?

WITH new_points as (
select s.customer_id ,s.product_id,s.order_date,members.join_date,
case
		when s.order_date between members.join_date and DATE_ADD(members.join_date, INTERVAL 6 DAY)
		then price * 20
	else
		case
			when m.product_name = 'sushi' then (price * 20) 
			when m.product_name in ('curry','ramen') then price * 10
		else price
        end
end as points
from sales s inner join menu m on s.product_id = m.product_id
right join members on s.customer_id = members.customer_id )

select customer_id , sum(points) from new_points group by customer_id


