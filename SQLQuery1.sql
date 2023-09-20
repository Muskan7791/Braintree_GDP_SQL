/*1\. Data Integrity Checking & Cleanup

   - Alphabetically list all of the country codes in the continent_map table that appear more than once. 
   Display any values where country_code is null as country_code = "FOO" and make this row appear first in the list, 
   even though it should alphabetically sort to the middle. Provide the results of this query as your answer.

   - For all countries that have multiple rows in the continent_map table, delete all multiple records leaving
   only the 1 record per country. The record that you keep should be the first one when sorted by the continent_code
   alphabetically ascending. Provide the query/ies and explanation of step(s) that you follow to delete these records.*/

USE Braintree;

-- PART 1
-- Replace '' empty strings with NULL
UPDATE
    continent_map
SET
    country_code = NULL
WHERE
    country_code = '';

-- Select Statement To Pull Up Duplicate Country Codes, FOO on top
SELECT
    COALESCE(country_code, 'FOO') AS c_code
FROM
    continent_map
GROUP BY
    country_code
HAVING
    COUNT(*) > 1
ORDER BY
    country_code;

-- PART 2
--Create a temporary table with a new column ID as a row_number on the table after order by contry_code, continent_code

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            country_code,
            continent_code asc
    ) AS 'rnk', --To create rank column based on continent_code 
    country_code,
    continent_code INTO t1
FROM
    continent_map; -- temporary table with all data of continent_map and rnk column

SELECT
    MIN(rnk) AS ID INTO t2
FROM
    t1
GROUP BY
    country_code; -- temporary table with only those records where continent_code is alphabetically first
 
--Delete the rows that dont have a min rank number after group by country_code
DELETE FROM t1 WHERE rnk NOT IN(SELECT ID FROM t2) ;

--Reset continent_map table
DELETE FROM continent_map;

--Refill continent_map from temp_table
INSERT INTO continent_map
  SELECT country_code, continent_code FROM t1;
 
--drop temporary tables
 DROP TABLE t1;
 DROP TABLE t2;
