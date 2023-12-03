-- first off, before importing the data I create a database to load the data into it
-- or just load the table into an existing database 

CREATE DATABASE call_centre;


-- starting working on new database

USE call_centre;


-- Create a table that will contain the imported csv file 

CREATE TABLE calls (
	ID CHAR(50),
	cust_name CHAR (50),
	sentiment CHAR (20),
	csat_score INT,
	call_timestamp CHAR (10),
	reason CHAR (20),
	city CHAR (20),
	state CHAR (20),
	channel CHAR (20),
	response_time CHAR (20),
	call_duration_minutes INT,
	call_center CHAR (20)
);


-- Now I used table data import wizard and loaded our data in

-- The table is too big to view all of it, let's see the first 20 rows

SELECT * FROM calls LIMIT 20;

-- the call_timestamp is a string and needs converting to a date format

UPDATE calls SET call_timestamp = str_to_date(call_timestamp, '%m/%d/%Y'); 

ALTER TABLE calls MODIFY COLUMN call_timestamp date;

SELECT * FROM calls LIMIT 20;

-- missing csat_score to be set to NULL

SELECT * from calls WHERE NOT csat_score BETWEEN 1 AND 10
ORDER BY csat_score desc
LIMIT 20;

UPDATE calls SET csat_score = NULL WHERE NOT csat_score BETWEEN 1 AND 10;

SELECT * FROM calls WHERE csat_score is NULL
LIMIT 20;

-- the count and percentage from total of each of the distinct values

SELECT * FROM calls
LIMIT 20;

SELECT sentiment, COUNT(*) AS count, CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1),'%') AS percentage
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, COUNT(*) AS count, CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1),'%') AS percentage
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, COUNT(*) AS count, CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1),'%') AS percentage
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, COUNT(*) AS count, CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1),'%') AS percentage
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, COUNT(*) AS count, CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1),'%') AS percentage
FROM calls GROUP BY 1 ORDER BY 3 DESC;

SELECT state, COUNT(*) AS count
FROM calls GROUP BY 1 ORDER BY 2 DESC;

-- which day has the most calls?

SELECT DAYNAME(call_timestamp) as day_of_calls, COUNT(*) AS num_of_calls, CONCAT(ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1),'%') AS percentage
FROM calls GROUP BY 1 ORDER BY 3 DESC;


-- call centre & state aggregations - checking the performance of call stations 

SELECT call_center, response_time, COUNT(*) AS count
FROM calls GROUP BY 1, 2 ORDER BY 1, 3;

SELECT call_center, AVG(call_duration_in_minutes)
FROM calls GROUP BY 1 ORDER BY 1;

SELECT state, COUNT(*) AS count
FROM calls GROUP BY 1 ORDER BY 2 DESC;

SELECT state, reason, COUNT(*) AS count
FROM calls GROUP BY 1,2 ORDER BY 1,2,3 DESC;

SELECT state, sentiment, COUNT(*) AS count
FROM calls GROUP by 1,2 ORDER BY 1,3;

SELECT state, ROUND(AVG(csat_score),2) as average
FROM calls GROUP by 1 ORDER BY 2 DESC;

SELECT sentiment, ROUND(AVG(call_duration_in_minutes),1) as call_duration_in_minutes
FROM calls GROUP BY 1 ORDER BY 2 DESC;
