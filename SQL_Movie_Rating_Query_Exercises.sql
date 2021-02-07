SQL Movie-Rating Query Exercises

Q1
1/1 point (graded)
Find the titles of all movies directed by Steven Spielberg.
`SELECT title FROM Movie WHERE director='Steven Spielberg';`

Q2
0/1 points (graded)
Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
`SELECT DISTINCT year FROM Movie m, Rating r WHERE m.mid = r.mid AND (r.stars = 4 OR r.stars = 5) ORDER BY m.year ASC;`

Q3
0/1 points (graded)
Find the titles of all movies that have no ratings.
`SELECT title FROM Movie WHERE mid NOT IN (SELECT mid FROM Rating);`

Q4
0/1 points (graded)
Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
`SELECT rw.name FROM Movie m, Rating r, Reviewer rw WHERE m.mid = r.mid AND r.rid = rw.rid AND r.ratingdate IS null;`

Q5
0/1 points (graded)
Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
`SELECT rw.name, m.title, r.stars, r.ratingdate FROM Movie m, Rating r, Reviewer rw WHERE m.mid = r.mid AND r.rid = rw.rid ORDER BY rw.name, m.title, r.stars;`

Q6
0/1 points (graded)
For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
`SELECT name, title FROM Movie
JOIN Rating r1 USING(mid)
JOIN Rating r2 USING(rid)
JOIN Reviewer USING(rid)
WHERE r2.mid = r1.mid AND r2.ratingdate > r1.ratingdate AND r2.stars > r1.stars;`

Q7
0/1 points (graded)
For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
`SELECT title, MAX(stars) FROM Movie
JOIN Rating USING(mid)
GROUP BY title
ORDER BY title;`

Q8
0/1 points (graded)
For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
`SELECT title, MAX(r2.stars) - MIN(r1.stars) as rating_spread FROM Movie
JOIN Rating r1 USING(mid)
JOIN Rating r2 USING(rid)
WHERE r1.mid = r2.mid
GROUP BY title
ORDER BY rating_spread DESC, title;`

Q9
0/1 points (graded)
Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
`SELECT AVG(B80.AVG) - AVG(A80.AVG) FROM
(SELECT AVG(stars) AS AVG FROM Movie
JOIN Rating USING(mid)
WHERE year < 1980
GROUP BY mid) AS B80,
(SELECT AVG(stars) AS AVG FROM Movie
JOIN Rating USING(mid)
WHERE year > 1980
GROUP BY mid) AS A80;`
