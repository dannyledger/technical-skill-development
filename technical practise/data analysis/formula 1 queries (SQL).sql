/*
1. How many races were held in each decade (e.g., 1950s, 1960s, etc.)?

- Count the total number of races per decade by using a CASEstatement on the yearcolumn from the racestable to assign labels like 1950s(1950-1959), 1960s (1960-1969), etc., through the 2020s (grouping what doesn't fall into these categories as other), aliasing this result as decade. 
- Next, count the number of races in each of these decade groups, aliasing the result as number_of_races.
- Finally, use GROUP BY to group the decade counts correctly and then ORDER BY to organize the output chronologically.
*/

SELECT 
	CASE
    	WHEN year BETWEEN 1950 AND 1959 THEN '1950s'
        WHEN year BETWEEN 1960 AND 1969 THEN '1960s'
    	WHEN year BETWEEN 1970 AND 1979 THEN '1970s'
        WHEN year BETWEEN 1980 AND 1989 THEN '1980s'
    	WHEN year BETWEEN 1990 AND 1999 THEN '1990s'
        WHEN year BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN year BETWEEN 2010 AND 2009 THEN '2000s'
        WHEN year BETWEEN 2020 AND 2029 THEN '2000s'
        ELSE 'other'
    END AS decade,
    COUNT(raceID) AS number_of_races
FROM races
GROUP BY decade
ORDER BY decade;

/*
2. Identify F1 Powerhouses - Constructors with 100+ Wins

- Start by retrieving the constructor names and their total wins(aliased as total_wins) from the results table. Use a JOIN to connect the results with the constructors table. 
- Filter the results to include only records where the position is1, as this indicates a win. 
- Then, group the results by constructorId and name to calculate the total number of wins for each constructor. 
- Finally, use the HAVING clause to include only constructors with more than 100 wins and order the results in descending order by total wins.
*/

SELECT
	c.name AS constructor_name, 
	COUNT(r.resultID) AS total_wins
FROM results r 
JOIN constructors c ON r.constructorID = c.constructorID
WHERE r.position = 1
GROUP BY c.constructorID, c.name
HAVING COUNT(r.resultID) > 100
ORDER BY total_wins DESC;

/*
3. Identify Packed F1 Seasons - Find Years with Over 20 Races

- Write a query to find the years in which more than 20 races were held. Use the races table and group the data by the year column. 
- For each year, count the number of races using the COUNT() function. Filter the results using the HAVING clause to include only years where the total race count exceeds 20. 
- Your query should return the yearand total raceIdaliased as race_count
*/

SELECT year, COUNT(raceID) as race_count
FROM races
GROUP BY year
HAVING COUNT(raceID) > 20;

/*
4. Identify Drivers with Over 200 Career Points

- Write a query to identify drivers who have accumulated more than 200 points in their career. Return the driverIdand their total points aliased as total_points.
-Use the results table and group the data by driverId. For each driver, calculate their total points using the SUM() function.
- Filter the results using the HAVING clause to include only drivers whose total points exceed 200.
*/

SELECT
	driverID, SUM(points) AS total_points
FROM results 
GROUP BY driverID
HAVING SUM(points) > 200;

/*
5. Find Races Held at High-Altitude Circuits (Above 800 Meters)

- Use a subquery in the WHERE clause to find races held at circuits with an altitude greater than 800 meters. 
- Start by identifying the circuitId values for circuits with alt (altitude) greater than 800 in the circuits table. 
- Then, filter the races table to return only the name (aliased as race_name) and year of races held at those circuits. 
- Finally, organize the results by year in ascending order, and then by race_name.
*/ 

SELECT name AS race_name, year
FROM races
WHERE circuitID 
	IN (SELECT circuitID 
        FROM circuits 
        WHERE alt > 800)
ORDER BY year, name;

/*
6. Categorize Driver Performance Tiers Based on Career Points

- Write a query to categorize drivers based on their total points in a season.
- First, using the results table, calculate the sum total points (aliased as total_points) for each driver by grouping the data by driverId
- Use a CASE statement to assign a performance category:
    - Elite for drivers with more than 300 points,
    - Good for drivers with points between 100 and 300,
    - Average for drivers with less than 100 points.
    - Alias this CASEstatement result as performance_category.
- Your query should return the driverId, total_points, and performance_category
*/ 

SELECT driverID, SUM(points) AS total_points,
	CASE
    	WHEN SUM(points) > 300 THEN 'Elite'
        WHEN SUM(points) BETWEEN 100 AND 300 THEN 'Good'
        ELSE 'Average'
    END AS performance_category
FROM results
GROUP BY driverID;

/* 
7. Categorize Constructors by Region Based on Nationality

- Classify each constructor as either Europeanor Non-European based on their registered nationality.
- Query the constructorstable, selecting the constructorIdand name.
- Use a CASEstatement to determine the region: if the nationality is one of the specified European ones (British, German, Italian, French, Dutch), assign European; otherwise, assign Non-European. Give this resulting category the alias region.
*/

SELECT constructorID, name,
	CASE
    	WHEN nationality IN ('British', 'German', 'Italian', 'French', 'Dutch') THEN 
        'European'
        ELSE 'Non-European'
    END AS region
FROM constructors;

/* 
8. Identify Drivers Who Never Raced for Ferrari

- Write a query to list the full names (forename and surname) of drivers who have participated in races but have never driven for the Ferrari team. 
- Your primary filtering logic involves two conditions combined with the AND Operator
- Use subqueries to:
    - Ensure the driver has participated in any race by checking if their driverIdis INa subquery that selects distinct driverIdsfrom the resultstable
    - Check if their driverIdis NOT IN the result of another subquery; this inner subquery should find all distinct driverIdsfrom results associated with Ferrari's constructorIdin race results where the constructorId corresponds to Ferrari.
- Finally, sort the results alphabetically by surname.
*/

SELECT
    forename, surname
FROM drivers
WHERE driverID 
	IN (SELECT DISTINCT driverID FROM results) 
  		AND driverID NOT IN (SELECT DISTINCT driverID
    						 FROM results
    						 WHERE constructorID = (SELECT constructorID
                                                    FROM constructors
                                                    WHERE name = 'Ferrari' LIMIT 1))
ORDER BY surname; 

/* 
9. List races held on circuits in the UK

- Write a query to list the names of races held on circuits located in the UK. Use a subquery to:
- Identify circuitId values for circuits located in the UK from the circuits table.
- Filter the races table to include only those with matching circuitId values.
*/

SELECT name
FROM races
WHERE circuitID IN (
    SELECT circuitID
    FROM circuits
    WHERE country = 'UK'
);

/* 
10. Calculate Average Points Per Race for Top Drivers

- Start by joining the drivers table with the results table. For each driver, you need two key aggregated values: their average points (aliased as average_points_per_race ) and their total race count (aliased as total_races). 
- Group your results by driver details (driverId, forename, surname) to ensure these aggregations are performed per driver. Since the condition (> 100 races) applies to the total race count (an aggregated value), use the HAVINGclause to filter your grouped results, keeping only those where total_races exceeds 100. 
- Finally, return the driver's full name and their calculated average points and total_races, ordering by average_points_per_race descending to see the top performers first.
*/

SELECT d.forename, d.surname, 
	AVG(r.points) AS average_points_per_race, 
    COUNT(r.raceID) AS total_races
FROM drivers d
JOIN results r ON d.driverID = r.driverID
GROUP BY d.driverID, d.forename, d.surname
HAVING COUNT(r.raceID) > 100
ORDER BY average_points_per_race DESC;

/* 
11. Find the Most Common Race Status

- Investigate the typical outcomes of race entries by finding the top 5 most frequently occurring statuses. Start by joining the resultstable with the statustable using their common statusId. 
- Return the status and use COUNT() to count the number of times each status occurs, aliasing this count as status_count. To ensure the count aggregates correctly for each unique status, group by both the statusIdand statusdescription. 
- Finally, to identify the most common statuses, order by the status_countin descending order and restrict the output to only the top five entries.
*/

SELECT
    s.status,
    COUNT(r.resultID) AS status_count
FROM results r
JOIN status s ON r.statusID = s.statusID
GROUP BY s.statusID, s.status
ORDER BY status_count DESC
LIMIT 5;

/* 
12. Calculate the average lap times for drivers who won at least one race.

- Calculate the average lap time (in milliseconds) for drivers who have achieved at least one race victory in their career. From the lapTimestable, retrieve the driverIdand calculate the average milliseconds, aliasing the result as avg_lap_time.
- Only include lap times from drivers who have ever won a race. The list of winning driver IDs for the INoperator should come from a subquery; this subquery should select the distinct driverIds from the resultstable where the position equals 1.
- Finally, ensure you group this result by driverIdso that the average lap time is calculated individually for each qualifying driver.
*/ 

SELECT driverId, 
    AVG(milliseconds) AS avg_lap_time
FROM laptimes
WHERE driverID IN (
    SELECT driverID
    FROM results
    WHERE position = 1
)
GROUP BY driverID;

/* 
13. Identify Constructors' First Win Year

- Identify the year each constructor achieved their first race win by selecting the constructor's name and the earliest year (MIN(year)) (aliased as first_win_year) they won a race. 
- Use a JOIN between the constructors, results, and races tables to link constructors to their race results and the respective years, filtering for results where the position is 1 (indicating a win).
- Group the data by constructorId and name to ensure the calculation is specific to each constructor and order the results by the first win year and then alphabetically by constructor name.
*/ 

SELECT
    c.name AS constructor_name,
    MIN(ra.year) AS first_win_year
FROM constructors c
JOIN results res ON c.constructorId = res.constructorId
JOIN races ra ON res.raceId = ra.raceId
WHERE res.position = 1 
GROUP BY c.constructorId, c.name 
ORDER BY first_win_year , constructor_name;

/* 
14. Identify Peak Performance Seasons

- Determine which 5 seasons saw the highest points tally achieved by the leading constructor in that particular year. This involves a two-step process using a subquery.
- Inner Query: First, calculate the sum total points(aliased as total_points) from the resultstable accumulated by each constructorIdwithin each season. To do this, join resultsand races, and GROUP BY both year(aliased as season) and constructorId. Alias this subquery as season_points
- Outer Query: Operating on the results of the inner query, group by the season and use the MAX(total_points) aggregate function to find the single highest score achieved by any constructor within that specific season. Alias this as max_points_in_season.
- Final Selection: Order by these maximum seasonal scores in descending order and select only the top 5 seasons based on how high the leading constructor scored.
- The final query should return the constructorId, season, and max_points
*/ 

SELECT constructorID, season, 
    MAX(total_points) AS max_points
FROM (
    SELECT constructorID, ra.year AS season, SUM(res.points) AS total_points
    FROM results res
    JOIN races ra ON res.raceID = ra.raceID
    GROUP BY constructorId, ra.year
) AS season_points
GROUP BY season
ORDER BY max_points DESC
LIMIT 5;



