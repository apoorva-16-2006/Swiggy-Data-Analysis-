USE [Swiggy DataBase];
GO
select * from swiggy_data;

-- Data Validation and cleaning data  
-- Number of Null value
select 
	sum(case when State is Null then 1 else 0 END) as NULL_State,
	sum(case when City is Null then 1 else 0 END) as NULL_City,
	sum(case when Order_Date is NULL then 1 else 0 END) as NULL_Order_Date,
	sum(case when Restaurant_Name is NULL then 1 else 0 END) as NULL_Restaurant_Name,
	sum(case when Location is NULL then 1 else 0 END) as NULL_Location,
	sum(case when Category is NULL then 1 else 0 END) as NULL_Category,
	sum(case when Dish_Name is NULL then 1 else 0 END) as NULL_Dish_Name,
	sum(case when Price_INR is NULL then 1 else 0 END) as NULL_price,
	sum(case when Rating is NULL then 1 else 0 END) as NULL_Rating,
	sum(case when Rating_Count is NULL then 1 else 0 END) as NULL_Rating_Count
from  swiggy_data;

-- Blank or Empty Strings
select * from swiggy_data 
where State=' ' or City =' ' or Restaurant_Name=' ' or Location=' ' or Category=' ' or Dish_Name=' '

-- Duplicate Detection
SELECT
    State, City, order_date, restaurant_name,
    location, category, dish_name, price_INR,
    rating, rating_count, COUNT(*) AS CNT
FROM swiggy_data
GROUP BY
    State, City, order_date, restaurant_name,
    location, category, dish_name, price_INR,
    rating, rating_count
HAVING COUNT(*) > 1;

-- Delete Duplication
with CTE as (
select *,ROW_NUMBER() over (
PARTITION BY State, City, order_date, restaurant_name,
    location, category, dish_name, price_INR,
    rating, rating_count order by (select NULL)
	) as rn
	from swiggy_data
	)
	DElETE from CTE where rn>1

-- Creating Schema
-- Dimension Table
-- Date Table

-- dim_date
CREATE TABLE dim_date(
date_id INT IDENTITY(1,1) PRIMARY KEY,
Full_Date Date,
Year INT,
Month INT,
Month_Name Varchar(50),
Quarter INT,
Day INT,
Week INT
)
Select * from dim_date;

-- Din Location
CREATE TABLE dim_location (
location_id INT IDENTITY(1,1) PRIMARY KEY,
State VARCHAR(100),
City VARCHAR(100),
Location VARCHAR(100)
)

Select * from dim_location;

-- dim_restaurant
CREATE TABLE dim_restaurant(
restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
Restaurant_Name VARCHAR(200)
)

Select * from dim_restaurant

-- dim_dish 
CREATE TABLE dim_dish(
dish_id INT IDENTITY(1,1) PRIMARY KEY,
Dish_Name VARCHAR(200)
)

-- dim_Category
CREATE TABLE dim_category(
category_id INT IDENTITY(1,1) PRIMARY KEY,
Category VARCHAR(200)
)
SELECT * FROM dim_category

-- Fact Table
CREATE TABLE fact_swiggy_orders(
order_id INT IDENTITY(1,1) PRIMARY KEY,
date_id INT,
Price_INR DECIMAL(10,2),
Rating DECIMAL(10,2),
Rating_Count INT,

location_id INT,
restaurant_id INT,
category_id INT,
dish_id INT,

FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
FOREIGN KEY (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
FOREIGN KEY (dish_id) REFERENCES dim_dish(dish_id),
);

Select * from fact_swiggy_orders

select * from swiggy_data;
-- dim_date
INSERT INTO dim_date (Full_Date,Year,Month,Month_Name,Quarter,Day,Week)
SELECT DISTINCT
Order_Date,
YEAR(Order_Date),
MONTH(Order_Date),
DATENAME(MONTH,Order_Date),
DATEPART(QUARTER,Order_Date),
DAY (Order_Date),
DATEPART(WEEK,Order_Date)
from swiggy_data
where Order_Date IS NOT NULL;

Select * from dim_date;

-- dim_location
INSERT INTO dim_location(State,City,Location)
SELECT DISTINCT
State ,City ,Location
from swiggy_data;

Select * from dim_location;

-- dim_restaurant
INSERT INTO dim_restaurant(Restaurant_Name)
SELECT DISTINCT 
Restaurant_Name 
from swiggy_data;

Select * from dim_restaurant;

-- dim_category 
INSERT INTO dim_category(Category)
SELECT DISTINCT 
Category 
from swiggy_data

Select * from dim_category;

-- dim_dish
INSERT INTO dim_dish
SELECT DISTINCT
Dish_Name
from swiggy_data

select * from dim_dish;

-- join fact tables 
INSERT INTO fact_swiggy_orders
(
date_id,
Price_INR,
Rating,
Rating_Count,
location_id,
restaurant_id,
category_id,
dish_id
)
SELECT 
dd.date_id,
s.Price_INR,
s.Rating,
s.Rating_Count,

d1.location_id,
dr.restaurant_id,
dc.category_id,
dsh.dish_id

from swiggy_data s

JOIN dim_date dd
ON dd.Full_Date=s.Order_Date

JOIN dim_location d1
on d1.State=s.State
AND d1.City=s.City
AND d1.Location=s.Location

JOIN dim_restaurant dr
on dr.Restaurant_Name=s.Restaurant_Name

JOIN dim_category dc
on dc.category=s.Category

JOIN dim_dish dsh
on dsh.Dish_Name=s.Dish_Name;

select * from fact_swiggy_orders;

SELECT *
FROM fact_swiggy_orders f
JOIN dim_date d
    ON f.date_id = d.date_id
JOIN dim_location l
    ON f.location_id = l.location_id
JOIN dim_restaurant r
    ON f.restaurant_id = r.restaurant_id
JOIN dim_category c
    ON f.category_id = c.category_id
JOIN dim_dish di
    ON f.dish_id = di.dish_id;

select * from fact_swiggy_orders;

-- KPI
-- Total Orders
SELECT COUNT(*) AS TOTAL_ORDERS FROM fact_swiggy_orders;

-- Total Revenue 
SELECT FORMAT(SUM(convert(float,Price_INR))/1000000,'N2')+' INR Million' AS TOTAL_REVENUE FROM fact_swiggy_orders;

--Average Dish
SELECT FORMAT(AVG(convert(float,Price_INR)),'N2')+' INR' AS TOTAL_REVENUE FROM fact_swiggy_orders;

-- Average Rating
SELECT format(AVG(CONVERT(FLOAT,Rating)),'N2') as Avg_Rating FROM fact_swiggy_orders;

-- Total Restaurant 
SELECT COUNT(DISTINCT restaurant_id) AS RESTAURANT_COUNT FROM fact_swiggy_orders;

-- Total Numbers of City 
SELECT COUNT(DISTINCT location_id) AS Total_City FROM fact_swiggy_orders;

-- Data Analysis
-- Monthly Order Trends 
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY COUNT(*) DESC;

-- Monthy Revenue 
SELECT
    d.year,
    d.month,
    d.month_name,
    FORMAT(SUM(convert(float,Price_INR))/1000000,'N2')+' INR Million' AS Total_Revenune
FROM fact_swiggy_orders f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY  FORMAT(SUM(convert(float,Price_INR))/1000000,'N2')+' INR Million' DESC;

-- Quaterly trend 
SELECT
    d.year,
    d.Quarter,
    COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY
    d.year,
    d.Quarter
ORDER BY COUNT(*) DESC;

-- Yearly Trends
SELECT d.year,
count(*) as total_orders 
from fact_swiggy_orders f
join dim_date d on f.date_id=d.date_id
group by d.year
order by count(*) DESC

-- Orders by day of week (Mon - Sun)
SELECT 
DATENAME(WEEKDAY,d.full_date) as day_name,
COUNT(*) as total_orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id =d.date_id 
group by DATENAME (WEEKDAY,d.full_date),DATEPART(WEEKDAY,d.full_date)
order by DATEPART (WEEKDAY,d.full_date);

-- Top 10 Cities by order volume
SELECT top 10
l.city,
COUNT(*) AS Total_Orders from fact_swiggy_orders f JOIN 
dim_location l on 
l.location_id=f.location_id
GROUP BY l.City
order by count(*) desc;

-- Top 10 Cities by revenue
SELECT top 10
l.city,
SUM(f.Price_INR) AS Total_revenue from fact_swiggy_orders f JOIN 
dim_location l on 
l.location_id=f.location_id
GROUP BY l.City
order by SUM(f.Price_INR) desc;

-- Revenue Contribution By States
SELECT 
l.State,
SUM(f.Price_INR) AS Total_revenue from fact_swiggy_orders f JOIN 
dim_location l on 
l.location_id=f.location_id
GROUP BY l.State
order by SUM(f.Price_INR) desc;

-- Top 10 Restaurants by Orders
SELECT TOP 10
    r.restaurant_id,
    r.Restaurant_Name,
    sum(f.Price_INR) AS total_revenue
FROM fact_swiggy_orders f
JOIN dim_restaurant r
    ON r.restaurant_id = f.restaurant_id
GROUP BY
    r.restaurant_id,
    r.Restaurant_Name
ORDER BY
    sum(f.Price_INR) DESC;

-- Top Categories By Order Volume
SELECT
    c.category,
    COUNT(*) AS total_orders
FROM fact_swiggy_orders f
JOIN dim_category c
    ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY total_orders DESC;

-- Most Ordered Dishes
SELECT TOP 10
    d.dish_name,
    COUNT(*) AS order_count
FROM fact_swiggy_orders f
JOIN dim_dish d
    ON f.dish_id = d.dish_id
GROUP BY d.dish_name
ORDER BY order_count DESC;

-- Cuisine Performance (Orders + Avg Rating)
SELECT
    c.category,
    COUNT(*) AS total_orders,
    AVG(CONVERT(FLOAT, f.rating)) AS avg_rating
FROM fact_swiggy_orders f
JOIN dim_category c
    ON f.category_id = c.category_id
GROUP BY c.category
ORDER BY total_orders DESC;


-- Total Orders by Price Range
SELECT
    CASE
        WHEN CONVERT(FLOAT, price_inr) < 100 THEN 'Under 100'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 100 AND 199 THEN '100 - 199'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 200 AND 299 THEN '200 - 299'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 300 AND 499 THEN '300 - 499'
        ELSE '500+'
    END AS price_range,
    COUNT(*) AS total_orders
FROM fact_swiggy_orders
GROUP BY
    CASE
        WHEN CONVERT(FLOAT, price_inr) < 100 THEN 'Under 100'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 100 AND 199 THEN '100 - 199'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 200 AND 299 THEN '200 - 299'
        WHEN CONVERT(FLOAT, price_inr) BETWEEN 300 AND 499 THEN '300 - 499'
        ELSE '500+'
    END
ORDER BY total_orders DESC;

-- Rating Count Distribution (1–5)
SELECT
    rating,
    COUNT(*) AS rating_count
FROM fact_swiggy_orders
GROUP BY rating
ORDER BY rating DESC;

