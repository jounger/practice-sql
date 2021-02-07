-- SQL Movie-Rating Query Exercises Extras

-- Q1. Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT name FROM Movie
JOIN Rating USING(mid)
JOIN Reviewer USING(rid)
WHERE title = 'Gone with the Wind';

-- Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars FROM Movie m
JOIN Rating USING(mid)
JOIN Reviewer r USING(rid)
WHERE m.director = r.name;

-- Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
SELECT title FROM Movie
UNION
SELECT name FROM Reviewer
ORDER BY name, title;

-- Q4. Find the titles of all movies not reviewed by Chris Jackson.
SELECT title FROM Movie
WHERE mid NOT IN
(SELECT mid FROM Movie
JOIN Rating USING(mid)
JOIN Reviewer USING(rid) WHERE name = 'Chris Jackson');

-- Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT rw1.name, rw2.name
FROM Rating r1, Rating r2, Reviewer rw1, Reviewer rw2
WHERE r1.mid = r2.mid AND
rw1.name < rw2.name AND
r1.rid = rw1.rid AND
r2.rid = rw2.rid
ORDER BY rw1.name, rw2.name;

-- Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars FROM Movie
JOIN Rating USING(mid)
JOIN Reviewer USING(rid)
WHERE stars = (SELECT MIN(stars) FROM Rating);

-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
SELECT title, AVG(stars) AS Average FROM Movie
JOIN Rating USING(mid)
GROUP BY title
ORDER BY Average DESC;

-- Q8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
SELECT name FROM Movie
JOIN Rating USING(mid)
JOIN Reviewer USING(rid)
GROUP BY name
HAVING COUNT(rid) >= 3;

-- Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
SELECT  title, director FROM Movie m1
WHERE (SELECT COUNT(*) FROM Movie m2 WHERE m1.director = m2.director) > 1
ORDER BY director, title

-- Q10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
SELECT title, AVG(stars) FROM Movie
JOIN Rating USING(mid)
GROUP BY title
ORDER BY AVG(stars) DESC LIMIT 1;

-- Q11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
SELECT title, AVG(stars) FROM Movie
JOIN Rating USING(mid)
GROUP BY title
HAVING AVG(stars) = (SELECT AVG(stars) FROM Movie
JOIN Rating USING(mid)
GROUP BY title
ORDER BY AVG(stars) ASC LIMIT 1);

-- Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
SELECT director, title, MAX(stars) FROM Movie
INNER JOIN Rating USING(mid)
WHERE director IS NOT NULL
GROUP BY director;