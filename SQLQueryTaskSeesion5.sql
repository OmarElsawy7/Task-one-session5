
-- 1 - Count the total number of products in the database.

select count(*) as total_number
from production.products ;

-- 2 - Find the average, minimum, and maximum price of all products.

select avg(list_price) as avarage_product  ,
min(list_price) as min_product,
max(list_price) as max_product
from production.products;

-- 3. Count how many products are in each category.

select category_id ,count(*) as product_count 
from  production.products group by  category_id;

--4. Find the total number of orders for each store.

select store_id ,
count(*) as total_orders
from sales.orders  group by store_id ;

--5. Show customer first names in UPPERCASE 
--and last names in lowercase for the first 10 customers.

select upper(first_name) ,
lower(last_name)
from sales.customers
where customer_id<=10;

-- 6 Get the length of each product name.
--Show product name and its length for the first 10 products.

select product_name , LEN(product_name) as length_product_name
from production.products  where product_id<=10;

--  7 Format customer phone numbers to show only the area code 
--(first 3 digits) for customers 1-15.

select customer_id, substring (phone ,1, 3 ) as area_code
from sales.customers
where customer_id between 1 and 15 ;


-- or solution

select customer_id , left(phone , 3) as area_code
from sales.customers
where customer_id <= 15 ;

--8. Show the current date and extract the year and month 
--from order dates for orders 1-10

select order_id, order_date,
getdate() as 'current_date' ,
year(order_date) as year_order ,
month(order_date) as month_order
from sales.orders
where order_id between 1 and 10 ;

-- 9 Join products with their categories.
--Show product name and category name for first 10 products.

select p.product_name , c.category_name 
from production.products p
inner join  production.categories c
on p.category_id=c.category_id
where product_id <= 10;

-- 10. Join customers with their orders. 
--Show customer name and order date for first 10 orders

select c.first_name +' ' +c.last_name as customer_name,
o.order_date from sales.customers c
inner join sales.orders o  on c.customer_id = o.customer_id
where o.order_id <= 10  ;

--11 11. Show all products with their brand names, 
--even if some products don't have brands

select p.product_name , b.brand_name from production.products p

join production.brands b  on p.brand_id=b.brand_id ;


--12.Find products that cost more than the average product price

select product_name ,list_price as price_more_than_the_average
from production.products
where list_price > ( select avg(list_price) from production.products) ;

--13. Find customers who have placed at least one order 
--(subquery with IN)

select first_name +' ' +last_name as customer_name 
from sales.customers
where customer_id IN (
select customer_id from sales.orders
); 

--14 For each customer, 
---show their name and total number of orders
--(subquery in SELECT clause)

select first_name +' ' + last_name as customer_name ,
(select count(*)  from sales.orders o 
where o.customer_id = c.customer_id)
 as total_number_of_orders
from sales.customers c ;
 
 --15 Create a view easy_product_list
 --and select products with price > 100

CREATE VIEW easy_product_list AS
SELECT
    p.product_name,
    c.category_name,
    p.list_price
FROM production.products p
INNER JOIN production.categories c ON p.category_id = c.category_id;

SELECT * FROM easy_product_list
WHERE list_price > 100
ORDER BY list_price DESC;

-- 16. Create a view customer_info and 
--find all customers from California (CA)

CREATE VIEW customer_info AS
SELECT
    c.customer_id,
    c.first_name+ ' '+ c.last_name AS full_name,
    c.email , c.city+ ', '+ c.state AS location
    FROM sales.customers c;

-- Use the view
SELECT * FROM customer_info
WHERE location LIKE '%, CA';

-- 17. Find all products that cost between $50 and $200

select product_name , 
list_price from production.products 
where list_price between 50 and 200
order by list_price asc ; 

-- 18. Count how many customers live in each state

select state , count(*) as count_custom_state
from sales.customers group by state
order by count_custom_state desc

---- 19. Find the most expensive product in each category

SELECT p.product_name, 
c.category_name, p.list_price
FROM production.products p
INNER JOIN production.categories c 
    ON p.category_id = c.category_id
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);


-- 20. Show all stores and their cities, 
--including total number of orders from each store

select s.store_name , s.city , count(o.order_id) as total

from sales.stores s

join sales.orders o on s.store_id = o.store_id

group by s.store_id , s.store_name , s.city


