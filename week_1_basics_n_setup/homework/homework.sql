-- Question 3
-- How many taxi trips were there on January 15?
SELECT COUNT(*)
FROM yellow_taxi_trips
WHERE CAST(tpep_pickup_datetime as DATE) = '2021-01-15'


-- Question 4
-- Find the largest tip for each day. On which day it was the largest tip in January?
SELECT CAST(tpep_pickup_datetime as DATE) as pickup_day, max(tip_amount) as max_tip
FROM yellow_taxi_trips
GROUP BY pickup_day
ORDER BY max_tip DESC
LIMIT 1


-- Question 5
-- What was the most popular destination for passengers picked up in central park on January 14?
-- Use the pick up time for your calculations.
SELECT dol."Zone" as do_zone, COUNT(*)
FROM yellow_taxi_trips
JOIN zones pul
ON yellow_taxi_trips."PULocationID" = pul."LocationID"
JOIN zones dol
ON yellow_taxi_trips."DOLocationID" = dol."LocationID"
WHERE pul."Zone" LIKE 'Central Park' and CAST(tpep_pickup_datetime as DATE) = '2021-01-14'
GROUP BY dol."Zone"
ORDER BY 2 DESC
LIMIT 1


-- Question 6
-- What's the pickup-dropoff pair with the largest average price for a ride 
-- (calculated based on total_amount)? Enter two zone names separated by a slash. 
-- For example:"Jamaica Bay / Clinton East". If any of the zone names are unknown (missing), 
-- write "Unknown". For example, "Unknown / Clinton East".

SELECT CONCAT(
			CASE WHEN pul."Zone" IS NULL THEN 'Unknown' ELSE pul."Zone" END,
	    	' / ', 
			CASE WHEN dol."Zone" IS NULL THEN 'Unknown' ELSE dol."Zone" END), 
			AVG(total_amount)
FROM yellow_taxi_trips
JOIN zones pul ON yellow_taxi_trips."PULocationID" = pul."LocationID"
JOIN zones dol ON yellow_taxi_trips."DOLocationID" = dol."LocationID"
GROUP BY pul."Zone", dol."Zone"
ORDER BY 2 DESC
LIMIT 1