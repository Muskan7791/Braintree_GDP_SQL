 /*
 2\. List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.

   The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)

   The list should include the columns:

   - rank
   - continent_name
   - country_code
   - country_name
   - growth_percent
   */

   Use Braintree;

WITH cte1 AS (
    SELECT country_code, gdp_per_capita AS gdp_2011
    FROM per_capita
    WHERE YEAR = 2011 ), -- Generate a table with country code and gdp values only for 2011
cte2 AS (
    SELECT country_code, gdp_per_capita AS gdp_2012
    FROM per_capita
    WHERE YEAR = 2012 ), -- Generate a table with country code and gdp values only for 2012
cte3 AS (
    SELECT cont.continent_name, cntr.country_code, cntr.country_name, cte1.gdp_2011, cte2.gdp_2012,
        round(((cte2.gdp_2012 - cte1.gdp_2011) / cte1.gdp_2011) * 100, 2) AS growth_percent
		-- Calculate growth_percent using the formula and tables gdp_2012, gdp_2011
    FROM continent_map cm
        JOIN continents cont ON cont.continent_code = cm.continent_code
        JOIN countries cntr ON cntr.country_code = cm.country_code
        JOIN cte1 ON (cte1.country_code = cm.country_code AND cte1.gdp_2011 ! = 0)
        JOIN cte2 ON (cte2.country_code = cm.country_code AND cte2.gdp_2012 ! = 0)), -- Join all tables to get country and continent names
cte4 AS(
    SELECT cte3.*, RANK() OVER(PARTITION BY cte3.continent_name ORDER BY cte3.growth_percent desc) AS rank
    FROM cte3) -- Window function to get gdp_rank 
SELECT cte4.rank, cte4.continent_name, cte4.country_code, cte4.country_name,
    concat(cte4.growth_percent, '%') AS growth_percent-- Concat in the end to avoid error during window function
FROM cte4
WHERE cte4.rank BETWEEN 10 AND 12; -- Desired Result