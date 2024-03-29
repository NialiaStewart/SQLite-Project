Create Table appleStore_description_combined AS

Select * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

Select * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**Exploratory DATA Analysis**

-- check the number of unique apps in both tablesAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDS
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDS
FROM appleStore_description_combined

--Check for any missing values in key fields

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null OR user_rating IS null or prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is NULL

-- Find out the number of apps per genre

SELECT prime_genre, COUNT(*) AS	NumApps
FROM AppleStore
GROUP BY prime_genre
Order By NumApps DESC

-- Get an overview of the apps' ratingsAppleStore

SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore   

**DATA ANALYSIS**

-- Determine whether paid apps have a higher ratings than free apps

SELECT CASE
		WHEN price > 0 THEN 'Paid'
        ELSE 'Free'
    END AS App_Type,
    avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type
        
--Check if apps with more supported lanaguages have higher ratings

SELECT CASE
			WHEN lang_num < 10 then '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
      END AS language_bucket,
      avg(user_rating) AS Avg_Rating
FROM AppleStore
Group By language_bucket
Order BY Avg_Rating DESC

--Check genres with low ratings

SELECT prime_genre,
	   avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
Order By Avg_Rating ASC
LIMIT 10

--Check if there is a correlation between the length of the app description and user rating 

SELECT CASE 
			WHEN length(b.app_desc) <500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
       END AS description_length_bucket,
       avg(a.user_rating) AS average_rating

FROM	
	AppleStore AS A
JOIN
	appleStore_description_combined AS b
ON
	a.id = b.id
    
GROUP BY description_length_bucket
ORDER BY average_rating DESC

--Check the top-rated apps for each genre

Select
	prime_genre,
    track_name,
    user_rating
FROM (
	SELECT
	prime_genre,
    track_name,
    user_rating,
    Rank() OVER(Partition BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM
    appleStore
 ) AS a
WHERE
a.rank = 1

      