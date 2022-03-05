USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) from director_mapping;
 -- 3867 

select count(*) from movie;
 -- 7997

select count(*) from genre;
 -- 14662

select count(*) from names;
 -- 25735

select count(*) from ratings ;
-- 7997

select count(*) from role_mapping ;
-- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select * from movie ;
 -- PK column ID cannot have null values ,Lets check other columns
select count(*) from movie where  title    is null ;         -- No Nulls                                                                  
select count(*) from movie where year       is null ;      -- No Nulls                                                                       
select count(*) from movie where date_published        is null ;    -- No Nulls                                                                              
select count(*) from movie where duration           is null ;           -- No Nulls                                                          
select count(*) from movie where country               is null ;    -- 20 records with null                                                                    
select count(*) from movie where  worlwide_gross_income       is null ;  -- many nulls 3724                                                                           
select count(*) from movie where  languages                   is null ;   -- many nulls 194                                                                
select count(*) from movie where production_company      is null ;      -- 528 nulls
-- Now lets check percentage of null for these columns 

select (COUNT(*) - COUNT(worlwide_gross_income)) / COUNT(*) *100 null_percentage from movie;
-- 46.5675

select (COUNT(*) - COUNT(country)) / COUNT(*) *100 null_percentage from movie;
-- 0.2501

select (COUNT(*) - COUNT(languages)) / COUNT(*) *100 null_percentage from movie;
-- 2.4259

select (COUNT(*) - COUNT(production_company)) / COUNT(*) *100 null_percentage from movie;
-- 6.6025


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+



Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year ,count(*) number_of_movies from movie group by year order by year ;

select year(date_published ) year,count(*) number_of_movies from movie group by  year(date_published ) order by  year(date_published ) ;

select month(date_published ) month_num,count(*) number_of_movies from movie group by  month(date_published ) order by  month(date_published ) ;






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(*)  from movie where (upper(country) LIKE  '%INDIA%'  or upper(country) LIKE  '%USA%' )
AND YEAR =2019;

-- ONE MORE METHOD
select  count(*)  from movie where ( INSTR(UPPER(country),'USA')>0 OR 
INSTR(UPPER(country),'INDIA')>0 ) AND YEAR =2019;
-- 1059 COUNT 








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT GENRE FROM genre ;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT   g.genre, count(*)   FROM movie m 
inner join
genre g
on m.id=g.movie_id
group by g.genre
order by count(*) desc
limit 1;

-- Drama 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
 
with t as ( 
SELECT   g.movie_id, count(*) cnt  FROM  
genre g
group by g.movie_id
having count(*) =1 ) 
select count(*)  from t ;
-- 3289







/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT   g.genre, round(avg(m.duration) ,2) avg_duration FROM movie m 
inner join
genre g
on m.id=g.movie_id
group by g.genre
order by  avg_duration desc ;







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with t as ( 
SELECT   g.genre, count(*) cnt,row_number() over (  order by count(*)  desc) genre_rank  FROM  
genre g
group by g.genre)
select * from t where t.genre='Thriller'
 






/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select  
min(avg_rating) as min_avg_rating,
max(avg_rating)  as max_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as min_median_rating
 from ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too



with tab1 as (
select title, avg_rating , row_number() over ( order by avg_rating  desc) as movie_rank ,
rank() over ( order by avg_rating  desc) as movie_rank1 ,
dense_rank()  over ( order by avg_rating  desc) as movie_rank2 
from movie m
inner join 
ratings r 
on m.id=r.movie_id
 )
 select * from tab1 where movie_rank<=10;




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select  
  median_rating ,
 count(*) as movie_count
 from ratings
 group by median_rating 
 order by movie_count desc ;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with tab1 as ( 
select production_company  , count(id ) movie_count, rank() over (order by count(id ) desc )  prod_company_rank
from movie  m
inner join ratings r 
on r.movie_id =m.id
where avg_rating >8
and production_company is not null
group by production_company )
select * from tab1 where prod_company_rank=1;




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre, count(*)  as movie_count from movie  m 
inner join ratings r
on  r.movie_id =m.id
inner join genre g 
on g.movie_id =m.id
where month(m.date_published)=3
and year(m.date_published)=2017
and m.country like '%USA%' -- as some movies released in multiple countries
and total_votes>1000
group by  g.genre
order by movie_count desc ;







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select m.title , r.avg_rating ,g.genre
from movie  m 
inner join ratings r
on  r.movie_id =m.id
inner join genre g 
on g.movie_id =m.id 
-- where m.title like 'The%'  -- Method 1 
where m.title regexp '^The' -- Method 2
and avg_rating>8 
order by r.avg_rating desc ;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


select count(m.id)  as movie_count 
from movie  m 
inner join ratings r
on  r.movie_id =m.id
where      m.date_published >=STR_TO_DATE('01-04-2018','%d-%m-%Y') 
-- as date format may b different on different client PCs
and  m.date_published<=STR_TO_DATE('01-04-2019','%d-%m-%Y')
and median_rating =8 ;
 







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
with tab1 as ( 
SELECT 
   m.id,r.total_votes,
   case when languages like '%German%' and languages like '%Italian%' then 'Both'
   when languages like '%German%' then 'German_flag'
   when languages like '%Italian%' then 'Italian_flag'
   end Language_flag 
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    upper(languages) LIKE '%GERMAN%'
        OR upper(languages) LIKE '%ITALIAN%'
 )
 select count(*) Count_movies , sum(total_votes) Tot_votes, Language_flag  from tab1  group by Language_flag
 order by Count_movies desc ;

-- answer Yes




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select count(*)  - count( name)  as name_nulls ,
count(*)  - count( height )  as height_nulls,
count(*)  - count( date_of_birth )   as date_of_birth_nulls,
count(*)  - count( known_for_movies )   as known_for_movies_nulls
from names ;

-- Method 2 
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

 WITH top_genre AS
(
	SELECT g.genre, COUNT(g.movie_id) AS movie_count
	FROM genre AS g
	INNER JOIN ratings AS r
	ON g.movie_id = r.movie_id
	WHERE avg_rating > 8
    GROUP BY genre
    ORDER BY movie_count desc
    LIMIT 3
) 
SELECT n.name AS director_name,
		COUNT(g.movie_id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) AS director_row_rank
FROM names AS n 
INNER JOIN director_mapping AS dm 
ON n.id = dm.name_id 
INNER JOIN genre AS g 
ON dm.movie_id = g.movie_id 
INNER JOIN ratings AS r 
ON r.movie_id = g.movie_id
inner join top_genre
WHERE g.genre  = top_genre.genre  AND avg_rating>8
GROUP BY director_name
ORDER BY movie_count DESC;
 








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
 

 
select n.name, count(m.id) movie_cnt 
from movie  m
inner join role_mapping  rm
on rm.movie_id =m.id
inner join ratings r 
on r.movie_id =m.id
inner join names n 
on n.id =rm.name_id
where median_rating  >=8
and  category ='actor'
group by  n.name
order by movie_cnt desc limit 2; 





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company, SUM(total_votes) AS vote_count,
		RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank_1,
		DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank_2
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY production_company
order by vote_count desc
LIMIT 3;







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



with tab2 as (
with tab1 as  (    
 SELECT nm.name AS actor_name,  
 m.id ,
                -- (avg_rating)  AS actor_avg_rating	,
                r.total_votes	,
                  (avg_rating*total_votes)   weighted_rating  ,
                  sum(total_votes) v_sum ,
                 1 movie_cnt
FROM movie m 
INNER JOIN ratings r 
ON m.id = r.movie_id 
INNER JOIN role_mapping rm 
ON m.id=rm.movie_id 
INNER JOIN names nm 
ON rm.name_id=nm.id
WHERE category='actor' AND upper(country) like '%INDIA%'  
group by name,m.id  
 )
select actor_name ,sum(total_votes) total_votes1 ,round(sum(weighted_rating)/sum(v_sum) ,2) weighted_rating_f , 
 sum(movie_cnt) movie_count  
 -- ,row_number over ( order by sum(total_votes) desc ) rank1
 from tab1    
group by actor_name
having sum(movie_cnt)>=5
)
select actor_name, total_votes1,movie_count, weighted_rating_f as actor_avg_rating, 
row_number() over ( order by weighted_rating_f desc, total_votes1 desc ) actor_rank
 from tab2;








-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


with tab2 as (
with tab1 as  (    
 SELECT nm.name AS actor_name,  
 m.id ,
                -- (avg_rating)  AS actor_avg_rating	,
                r.total_votes	,
                  (avg_rating*total_votes)   weighted_rating  ,
                  sum(total_votes) v_sum ,
                 1 movie_cnt
FROM movie m 
INNER JOIN ratings r 
ON m.id = r.movie_id 
INNER JOIN role_mapping rm 
ON m.id=rm.movie_id 
INNER JOIN names nm 
ON rm.name_id=nm.id
WHERE category='actress' AND upper(country) like '%INDIA%'    AND lower(languages) like '%hindi%'
group by name,m.id  
 )
select actor_name ,sum(total_votes) total_votes1 ,round(sum(weighted_rating)/sum(v_sum) ,2) weighted_rating_f , 
 sum(movie_cnt) movie_count  
 -- ,row_number over ( order by sum(total_votes) desc ) rank1
 from tab1    
group by actor_name
having sum(movie_cnt)>=3
)
select actor_name, total_votes1,movie_count, weighted_rating_f as actor_avg_rating, 
row_number() over ( order by weighted_rating_f desc ,total_votes1 desc ) actor_rank
 from tab2;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title,
		CASE WHEN avg_rating > 8 THEN 'Superhit movies'
			 WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
             WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
			 WHEN avg_rating < 5 THEN 'Flop movies'
		END AS avg_rating_category
FROM movie m
INNER JOIN genre g
ON m.id=g.movie_id
INNER JOIN ratings as r
ON m.id=r.movie_id
WHERE genre='thriller';







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        round(SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) ,2) AS running_total_duration,
        round(AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) ,2) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH top_3_genre AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies
    FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top_5 AS
(
	SELECT genre,
			year,
			title AS movie_name,
			worlwide_gross_income,
            case when worlwide_gross_income  like '%INR%' then
            trim(replace(worlwide_gross_income,'INR','')) * 70
            else
            trim(replace(worlwide_gross_income,'$','') )
            end worlwide_gross_income_modified
			-- DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_3_genre)
)
SELECT genre,
			year,
			movie_name,
			worlwide_gross_income,
            worlwide_gross_income_modified,
            DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income_modified DESC) AS movie_rank            
FROM top_5
order by  worlwide_gross_income_modified desc
limit 5;

-- Top 3 Genres based on most number of movies










-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company,
		COUNT(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company order by movie_count desc
LIMIT 2;




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with tab1 as ( select name, SUM(total_votes) AS total_votes,
		COUNT(rm.movie_id) AS movie_count,
		avg(avg_rating) as actress_avg_rating,
        row_number() OVER(ORDER BY COUNT(rm.movie_id) DESC, avg(avg_rating) desc) AS actress_rank
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id = rm.name_id
INNER JOIN ratings AS r
ON r.movie_id = rm.movie_id
INNER JOIN genre AS g
ON r.movie_id = g.movie_id
WHERE category = 'actress' AND avg_rating > 8 AND genre = 'drama'
group by name)
select * from tab1 where actress_rank<=3
 






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_date_info AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 final_result AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM final_result