
-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
SELECT 
	type,
	COUNT(*) total_count
FROM netflix
GROUP BY type;


--2. Find the most common rating for movies and TV shows

SELECT 
	type, rating
FROM 
(
	SELECT 
		type,
		rating,
		COUNT(*) total_count,
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) Ranking
	FROM netflix
	GROUP BY type, rating
) t1
WHERE ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix
WHERE type = 'Movie' 
	AND 
	release_year = 2020
;


--4. Find the top 5 countries with the most content on Netfli

SELECT 
		UNNEST(string_to_array(country, ',')) AS new_country,
		COUNT(show_id)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC LIMIT 5


--5. Identify the longest movie

SELECT *
FROM netflix
WHERE type = 'Movie' 
	AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::int DESC 
LIMIT 1
;

--6. Find content added in the last 5 years

SELECT  
	*
FROM netflix 
WHERE
	TO_DATE(date_added, 'Month DD, YYYY' ) >= CURRENT_DATE - INTERVAL '5 years'
;




--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * 
FROM netflix 
WHERE 
	director ILIKE '%Rajiv Chilaka%'

	

--8. List all TV shows with more than 5 seasons

SELECT 
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND 
	SPLIT_PART(duration, ' ', 1)::int > 5




--9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in , ',')) genre,
	COUNT(show_id) total_content
FROM netflix
GROUP BY 1;

--10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')),
	COUNT(show_id) total_content,
	(COUNT(show_id)::numeric / (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric  ) * 100 Avg_content
FROM netflix
WHERE country ILIKE 'India'
GROUP BY 1
ORDER BY 3 DESC LIMIT 5;


--11. List all movies that are documentaries



SELECT 
	* 
FROM netflix
WHERE
	TYPE = 'Movie'
	AND  listed_in ILIKE '%documentaries%';



--12. Find all content without a director

SELECT * FROM netflix
WHERE 
	director IS NULL;


	
--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!


SELECT * 
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	release_year >= EXTRACT(YEAR FROM (CURRENT_DATE - INTERVAL '10 years'));



--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT * FROM netflix;

SELECT 
	
	UNNEST(STRING_TO_ARRAY(casts, ',' )) Actors,
	COUNT(*) Movie_produced
FROM netflix
WHERE 
	country ILIKE '%India%'
	AND type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC LIMIT 10;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.


SELECT 
	cateogry,
	COUNT(*) total_count
FROM 
(
	SELECT 
		*,
		CASE WHEN description ILIKE  '%kill%' OR description ILIKE  '%violence%' THEN 'Bad'
		ELSE 'Good'
		END Cateogry
	FROM netflix
) t
GROUP BY 1;


