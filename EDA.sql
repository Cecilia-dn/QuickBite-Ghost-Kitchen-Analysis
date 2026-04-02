--- GHOST KITCHEN
-- 5 Tables: Competitor_data, Kitchen_cost, menu_items, orders_data and weather_data

-----------------------------------------ORDERS_TABLE------------------------------------------
SELECT TOP 10 * 
FROM gk.orders_data ;

--- Date Range
SELECT 
	MAX(order_datetime) ,-- Aug 1st
	MIN(order_datetime) --Jan 31st
FROM gk.orders_data ;

--- number of orders, revenue & sum of items accross all locations
--- Kilimani>Westlands>Eastleigh (Westlands- Eastleigh = 1 ??)
--- AoV Kilimani>Westlands>Eastleigh
SELECT location,
	COUNT(order_id) total_orders,  --- Kilimani> Westlands > Eastleigh
	SUM(num_items) sum_items,  --- Kilimani> Eastleigh> Westlands
	SUM(subtotal) total_revenue,  --- Kilimani> Westlands> Eastleigh
	SUM(subtotal) / COUNT(order_id) average_order_value,
	AVG(delivery_time_minutes) avg_delivery_time,
	AVG(customer_rating) avg_customer_rating
FROM gk.orders_data
GROUP BY location
ORDER BY total_revenue DESC;



---- monthly orders, number of items, revenue by location
--- The orders, number of items, & revenue in Eastleigh constantly increases every month the numbers are not high enough.
--- The orders, number of items, & revenue in Kilimani are on off, both the increase and decrease are high.
--- The orders, number of items, & revenue in Westlands are on off.
SELECT FORMAT(order_datetime, 'MMM yyyy') month_year,
	location,
	COUNT(order_id) total_orders,
	SUM(num_items) sum_items,
	SUM(subtotal) total_revenue,
	SUM(subtotal) / COUNT(order_id) average_order_value
FROM gk.orders_data
WHERE location = 'Eastleigh'
GROUP BY 
    FORMAT(order_datetime, 'MMM yyyy'),
    location ORDER BY MIN(order_datetime);

----------------------------------------
--- Day of the week----
---weekdays: Kilimani > Westlands > Eastleigh
SELECT FORMAT(order_datetime, 'ddd') day_of_week,
	location,
	COUNT(order_id) total_orders,  -- weekend has high orders
	SUM(num_items) sum_items,	--- -- weekend has high orders
	SUM(subtotal) total_revenue  --- 
FROM gk.orders_data
WHERE location = 'Westlands' AND is_weekend = 0   --- Weekend:Kilimani > Eastleigh > Westlands
GROUP BY 
    FORMAT(order_datetime, 'ddd'),
    location
ORDER BY total_orders DESC;

----------------------------------------Revenue & Profit--------
---Revenue: Kilimani > Westlands > Eastleigh
---Profit: Kilimani > Eastleigh > Westlands 
SELECT t.location,
	t.total_revenue,t.ingredient_cost,
	k._6_months fixed_cost,
	t.total_revenue - (t.ingredient_cost + k._6_months) AS total_profit
FROM
	(SELECT location,
		SUM(subtotal) total_revenue,
		SUM(ingredient_cost) ingredient_cost
	FROM gk.orders_data 
	GROUP BY location)t
LEFT JOIN gk.kitchen_costs k
	ON t.location = k.location
ORDER BY total_profit DESC;

SELECT * 
FROM gk.kitchen_costs;


----- Growth rate of Orders
--By Location
WITH monthly_orders as(
	SELECT YEAR(order_datetime)  year,
        MONTH(order_datetime)  month,
		location,
		COUNT(order_id) current_total_orders
	FROM gk.orders_data
	GROUP BY location, 
		YEAR(order_datetime),
        MONTH(order_datetime)
),
previous_orders AS(
	SELECT  year, month,
		location,
		current_total_orders,
		LAG(current_total_orders) OVER(PARTITION BY location ORDER BY year, month) previous_total_orders
		FROM monthly_orders
)
SELECT 
    location,
    year, month,
    current_total_orders,
    previous_total_orders,
    ROUND(
        (current_total_orders - previous_total_orders) * 100.0 
        / previous_total_orders, 2
    ) as percentage_growth_rate
FROM previous_orders
WHERE previous_total_orders IS NOT NULL --AND --location = 'Eastleigh'
ORDER BY year, month;

/***Eastleigh percentage growth rate increase monthly
mnth 1: 7.3%
mnth 2: 4.0%
mnth 3: 15.8%
mnth 4: 3.6%
mnth 5: 2.8% **/

------------------------------------------
--WEATHER
-----------------------------------------------
SELECT *,
    FORMAT(date, 'MMM yyyy') AS MonthYear,
    FORMAT(date, 'ddd') AS DayOfWeek
FROM gk.weather_data;
------------------------------

--Monthly average weather data 
-- October highest rain avg and 
SELECT FORMAT(date, 'MMM yyyy')  month_year,
	ROUND(AVG(rainfall_mm), 2) avg_rain,
	ROUND(AVG(temperature_celsius),2) avg_temp
FROM gk.weather_data
GROUP BY FORMAT(date, 'MMM yyyy')
ORDER BY avg_rain DESC;

--- Number of days where it rained
SELECT
    FORMAT(date, 'MMM yyyy')  month_year,
    COUNT(rainfall_mm) day_with_rain
FROM gk.weather_data
WHERE rainfall_mm > 0
GROUP BY FORMAT(date, 'MMM yyyy')
ORDER BY day_with_rain DESC;

--- Thursday highest rain avg
SELECT FORMAT(date, 'ddd')  day_of_week,
	ROUND(AVG(rainfall_mm), 2) avg_rain,
	ROUND(AVG(temperature_celsius),2) avg_temp
FROM gk.weather_data
GROUP BY FORMAT(date, 'ddd')
ORDER BY avg_rain DESC;

---- Impact of Rainy Weather------------ 
--1: Kilimani> Eastleigh> Westlands
--0: Kilimani> > Westlands> Eastleigh
SELECT location, 
	COUNT(order_id) total_orders
FROM gk.orders_data 
WHERE is_rainy = 1
GROUP BY location
ORDER BY total_orders DESC;

-- During rainy days the orders decrease from 127 to 91
-- the average delivery time in greater when its raining 
-- 0 no rain 127
-- 1 yes rain 57
SELECT is_rainy,
    COUNT(DISTINCT CAST(order_datetime AS DATE)) as num_days,
    COUNT(order_id) as total_orders,
    COUNT(order_id) / COUNT(DISTINCT CAST(order_datetime AS DATE)) as orders_per_day,
	AVG(delivery_time_minutes) avg_delivery_time
FROM gk.orders_data
GROUP BY is_rainy;


---By location
SELECT location,
    is_rainy,
    COUNT(DISTINCT CAST(order_datetime AS DATE)) as num_days,
    COUNT(order_id) as total_orders,
    COUNT(order_id) / COUNT(DISTINCT CAST(order_datetime AS DATE)) as orders_per_day,
	AVG(delivery_time_minutes) avg_delivery_time
FROM gk.orders_data
GROUP BY is_rainy, location
ORDER BY location;

/*
--orders_lost 1,491,804
SELECT 
    (127 - 91) * 57 * AVG(total) AS lost_revenue
FROM gk.orders_data; */
------------------------------------------------------------
SELECT location,
    hour,
    COUNT(order_id) as total_orders,
	AVG(delivery_time_minutes) avg_delivery_time
FROM gk.orders_data
GROUP BY location, hour
ORDER BY hour, total_orders DESC;

/*** Kilimani
peak hours = 12pm to 1pm, 7pm to 8pm
off_peak = 2pm to 6pm, 9pm to 10pm

Westlands
peak hours = 12pm to 2pm, 7pm to 8pm
off_peak = 3pm to 6pm, and 10pm

Eastleigh
peak hours = 1pm to 3pm, 8pm to 9pm
off_peak = 4pm to 7pm, 9pm to 10pm
Peak hours of eastleigh is different from the rest **/

-------- KITCHEN_COSTS-------------------------------------
-----Westlands > Kilimani > Eastleigh
SELECT * 
FROM gk.kitchen_costs
ORDER BY _6_months DESC;

-----------------MENU-----------------------------
---Nyama Choma Platter is mostly tops in Kilimani and Westlands but missing from Eastleigh top lists.
SELECT items,
	COUNT( items) meal_combination, ---pilau
	SUM(subtotal) revenue  --- chicken Biriyani
	--SUM(ingredient_cost) ingredient_cost
FROM gk.orders_data 
WHERE location = 'Eastleigh'
GROUP BY items
ORDER BY meal_combination DESC;

---Nyama Choma with the highest prep time, cost & profit
---Top: Nyama Choma > Chicken Biriyani
--Lowest: Samosa, Mandazi & Bhajia
SELECT * 
FROM gk.menu_items
ORDER BY profit DESC;


SELECT FORMAT(order_datetime, 'MMM yyyy') month_year, 
	items,
	COUNT( items) meal_combo, ---pilau
	SUM(subtotal) revenue  --- chicken Biriyani
	--SUM(ingredient_cost) ingredient_cost
FROM gk.orders_data 
WHERE location = 'Eastleigh'
GROUP BY items,
	FORMAT(order_datetime, 'MMM yyyy')
ORDER BY meal_combo DESC;


-------- COMPETITOR_DATA-------------------------------------
SELECT * 
FROM gk.competitor_data;

--- Delivery time diference between Ghost Kitchen and competitors
---They all take a long time to do deliveries Kilimani>Eastleigh>Westlands
WITH avg_delivery as(
	SELECT location,
		AVG(delivery_time_minutes) avg_time_delivery
	FROM gk.orders_data
	GROUP BY location
)
SELECT c.location,
	avg_competitor_delivery_time,
	avg_time_delivery,
	(avg_time_delivery - avg_competitor_delivery_time ) time_difference
FROM gk.competitor_data c
LEFT JOIN avg_delivery a
	ON c.location = a.location
ORDER BY time_difference DESC;






