create database swiggy_project;
use swiggy_project;

CREATE TABLE Restaurent AS
SELECT 
     Restaurent_ID,
    Restaurant_Name,
    Order_Price,
     City
FROM swiggy;

Create table ratings as 
select 
Restaurent_ID,
Avg_ratings,
Total_ratings
from swiggy ;

Create table delivery as 
select
Restaurent_ID,
Restaurant_Name,
Delivery_time
from swiggy;


## Total Restaurent
select count(*) as total_restaurent
from swiggy;


##  Which city has the highest number of restaurants?
select City ,count(Restaurent_ID) as total_Restaurent
from swiggy 
group by  City
order by total_Restaurent desc
Limit 1;




## Unique 'cities'
select distinct city 
from swiggy;

## Avg. Ratings
select round(Avg(Avg_ratings),2) as avg_rating
from ratings;

## Top 10 rated restaurent by rating
select  sg.Restaurant_Name, rt.Avg_ratings, sg.Restaurent_ID
from swiggy as sg join ratings as rt
on sg.Restaurent_ID = rt.Restaurent_ID
order by rt.Avg_ratings desc
limit 10 ;

## Fastest delivery restaurent 
select Restaurant_Name, Delivery_time
from swiggy
order by Delivery_time asc
limit 10;

## Most expensive Restaurent
select Restaurent_ID,Restaurant_Name,Order_Price
from swiggy 
order by Order_Price desc
limit 10;


## Average order price of Restaurent 
select Restaurant_Name ,City, round(avg(Order_Price),2)as average_price 
from restaurent
group by Restaurant_Name ,City , Order_Price;


## Max Price
select Restaurant_Name, max(Order_price) as maximum_price
from restaurent
group by Restaurant_Name
order by max(Order_price) desc; 	


## Minimum price 
select Restaurant_Name, min(Order_price) as minimum_price
from restaurent
group by Restaurant_Name
order by minimum_price asc;

## Restaurent above 1000 as per premium category
with premium_category as (
select Restaurant_Name , Order_Price 
from restaurent
)
select *
from premium_category
where Order_Price >1000;	


## Restaurent below average--
select Restaurent_ID , Restaurant_Name ,Order_Price
from restaurent
where Order_Price < (select avg(Order_Price) from restaurent)
order by Order_Price desc;


## Count expensive Restaurent per city -- 
select  City, Count(*) as expensive_ord
from restaurent
where Order_Price > 500
group by City;


## Top City's with highest Avg price --
select city ,avg(Order_Price) as avg_price
from swiggy
group by City 
order by avg_price desc;

## Top 3 expensive restaurent --
select  Restaurent_ID, City ,Restaurant_Name,Order_Price,
rank()over(partition by city order by Order_Price desc) as rnk
from restaurent 
order by Order_Price desc
limit 3;


# Windows function --

## Rank by price --
SELECT
Restaurant_Name,
    City,
    Order_Price,
    Rank() Over(partition by  City order by Order_Price desc) as price_rank
    from restaurent;

## Row number -- 
SELECT
    Restaurant_Name,
    City,
    Order_Price,
    ROW_NUMBER() OVER(PARTITION BY City ORDER BY Order_Price DESC) AS row_num
FROM restaurent;


## Rank expensive restaurent in each city --
## Rank

select
 Restaurant_Name,
 City,
 Order_Price,
rank()over(partition by City order by Order_Price desc) as price_rank
  from restaurent;

## Dense_rank
select 
Restaurent_ID,
Restaurant_Name, 
City,
Order_Price,
dense_rank()over(partition by City order by Order_Price desc) as price_rank
from restaurent;

## Row_number 
select Restaurent_ID,
Restaurant_Name,
 City,
 Order_Price,
row_number()over(partition by City order by Order_Price desc) as price_rank
from restaurent;


## Top 3 Restaurent per city by Order price--
select
    Restaurant_Name,
    City,
    Order_Price,
    Rank() Over(partition by City order by Order_Price desc) as rnk
from restaurent
limit 3;


## Price difference from city avg -- 
SELECT
    Restaurant_Name,
    City,
    Order_Price,
    Order_Price - avg(Order_Price) Over(partition by City) as diff_from_avg
    FROM restaurent;
    
## Running total --
SELECT
    Restaurant_Name,
    Order_Price,
    SUM(Order_Price) Over (order by Order_Price desc) as running_total
    from restaurent;
    
## Self join -- 
#Expensive vs affordable Restaurents -- 
SELECT
    a.Restaurant_Name as Expensive_Restaurant,
    b.Restaurant_Name as afford_Restaurant,
    a.City,
    a.Order_Price as Expensive_Price,
    b.Order_Price as afford_Price
FROM restaurent a
JOIN restaurent b
ON a.City = b.City
AND a.Order_Price > b.Order_Price
LIMIT 20;

##left join --
## All restaurent ratings
SELECT 
    s.Restaurent_ID,
	s.City,
    r.Avg_ratings
FROM swiggy as s
LEFT JOIN ratings as r
ON s.Restaurent_ID = r.Restaurent_ID;

## Right join -- 
## Delivery table
SELECT 
    d.Restaurent_ID,
    d.Delivery_time,
    s.Restaurant_Name,
    s.City
FROM swiggy as s
RIGHT JOIN delivery as d
ON s.Restaurent_ID = d.Restaurent_ID
order by Delivery_time asc;




## Top restaurent by ratings--
SELECT 
    s.Restaurant_Name,
    s.City,
    r.Avg_ratings
FROM swiggy as s
JOIN ratings as r
ON s.Restaurent_ID = r.Restaurent_ID
ORDER BY r.Avg_ratings desc
LIMIT 10;


## Which restaurants have high ratings but relatively lower prices? 
SELECT 
    s.Restaurant_Name,
    r.Avg_ratings, min(Order_Price) as lowest_price
FROM swiggy as s
JOIN ratings as r
ON s.Restaurent_ID = r.Restaurent_ID
group by s.Restaurant_Name,r.Avg_ratings
ORDER BY r.Avg_ratings desc
LIMIT 10 ;

## Are there restaurants that have high prices but low ratings?

SELECT
    s.Restaurant_Name,
    r.Avg_ratings,
    s.Order_Price
FROM swiggy s
JOIN ratings r
ON s.Restaurent_ID = r.Restaurent_ID
WHERE r.Avg_ratings <= 3
AND s.Order_Price >= 1000
ORDER BY r.Avg_ratings DESC, s.Order_Price ASC;




## Case statement --
# Restaurent category by ratings --
	SELECT 
    s.Restaurant_Name,
    r.Avg_ratings,
    CASE 
        WHEN r.Avg_ratings >= 4.5 THEN 'Excellent'
        WHEN r.Avg_ratings >= 4.0 THEN 'Very Good'
        WHEN r.Avg_ratings >= 3.5 THEN 'Good'
        ELSE 'Average'
    END AS Rating_Category
FROM swiggy s
JOIN ratings r
ON s.Restaurent_ID = r.Restaurent_ID;


## Restaurent Category by delivery time
SELECT 
    s.Restaurant_Name,
    d.Delivery_time,
    CASE 
        WHEN d.Delivery_time <= 30 THEN 'Fast Delivery'
        WHEN d.Delivery_time BETWEEN 31 AND 45 THEN 'Moderate'
        ELSE 'Slow Delivery'
    END AS Delivery_Status
FROM swiggy s
JOIN delivery d
ON s.Restaurent_ID = d.Restaurent_ID
order by Delivery_time asc;

