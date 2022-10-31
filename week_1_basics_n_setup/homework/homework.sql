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
-- What was the most popular destination for passengers picked up in central parl on January 14?
