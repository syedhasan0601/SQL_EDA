-- Q1.HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5? 
select count(distinct(restaurant_name)) as Top_Restaurants from swiggy where rating > 4.5 ;

-- Q2.WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
select city,count(distinct(restaurant_name)) as no_of_restaurants from swiggy group by city order by no_of_restaurants desc limit 1;

-- Q3.HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?
select count(distinct(restaurant_name)) as pizza_restaurants from swiggy where restaurant_name like '%pizza%';

-- Q4.WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
select cuisine , count(*) as cuisine_count from swiggy group by cuisine order by cuisine_count desc limit 1;

-- Q5.WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
select city,avg(rating) as avg_rating from swiggy group by city;

-- Q6.WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
select restaurant_name,menu_category,max(price) as high_price from swiggy where menu_category = 'Recommended' group by restaurant_name,menu_category ;

-- Q7.FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.
select distinct(restaurant_name),cost_per_person from swiggy where cuisine != 'Indian' order by cost_per_person desc limit 5;

-- Q8.FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER
select distinct(restaurant_name),avg(cost_per_person) from (select avg(cost_per_person) from swiggy);

-- Q9.RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
select * from swiggy limit 5;
select distinct(s1.restaurant_name),s1.city,s2.city from swiggy s1 join swiggy s2 on s1.restaurant_name = s2.restaurant_name and s1.city != s2.city;

-- Q10.WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
select restaurant_name,count(distinct(item)) as no_items from swiggy where menu_category = 'Main Course'  group by restaurant_name order by no_items desc limit 1; 

-- Q11.LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.
select distinct restaurant_name,
(count(case when veg_or_nonveg='Veg' then 1 end)*100/
count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100.00
order by restaurant_name;

-- Q12.WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS
select distinct(restaurant_name) as restaurant,round(avg(price),2) as lowest_avg_price from swiggy group by restaurant_name order by lowest_avg_price limit 1;

-- Q13.WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
select distinct(restaurant_name) as restaurant , count(distinct(menu_category)) as no_of_categories from swiggy 
group by restaurant order by no_of_categories desc limit 5; 

-- Q14.WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
select distinct restaurant_name,
(count(case when veg_or_nonveg='Non-veg' then 1 end)*100
/count(*)) as nonvegetarian_percentage
from swiggy
group by restaurant_name
order by nonvegetarian_percentage desc limit 1;




