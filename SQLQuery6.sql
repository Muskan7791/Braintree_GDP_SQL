/*
6\. All in a single query, execute all of the steps below and provide the results as your final answer:

   a. create a single list of all per_capita records for year 2009 that includes columns:

   - continent_name
   - country_code
   - country_name
   - gdp_per_capita

   b. order this list by:

   - continent_name ascending
   - characters 2 through 4 (inclusive) of the country_name descending

   c. create a running total of gdp_per_capita by continent_name

   d. return only the first record from the ordered list for which each continent's running total of gdp_per_capita meets or exceeds $70,000.00 with the following columns:

   - continent_name
   - country_code
   - country_name
   - gdp_per_capita
   - running_total
   */

WITH cte1 AS (
    SELECT
        cont.continent_name,
        cntr.country_code,
        cntr.country_name,
        pc.gdp_per_capita,
        SUM(pc.gdp_per_capita) OVER (PARTITION BY cont.continent_name	
            ORDER BY SUBSTRING(cntr.country_name, 2, 3) DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total	--Window function to get running total (all previous rows + current row)
    FROM
        continent_map cm
        JOIN continents cont ON cont.continent_code = cm.continent_code
        JOIN countries cntr ON cntr.country_code = cm.country_code
        JOIN per_capita pc ON pc.country_code = cntr.country_code
    WHERE
        pc.year = 2009	-- Condition for year = 2009
),
cte2 AS (
    SELECT
        cte1.*,
        ROW_NUMBER() OVER (PARTITION BY cte1.continent_name ORDER BY cte1.running_total) AS row_count	-- To get the first row where running_total > 70000
    FROM
        cte1
    WHERE
        cte1.running_total > 70000
)
SELECT
    cte2.continent_name,
    cte2.country_code,
    cte2.country_name,
    CONCAT('$', ROUND(cte2.gdp_per_capita, 2)) AS gdp_per_capita,		--Concat in the end to avoid error in window function
    CONCAT('$', ROUND(cte2.running_total, 2)) AS running_total
FROM
    cte2
WHERE
    cte2.row_count = 1
ORDER BY
    cte2.continent_name ASC,
    SUBSTRING(cte2.country_name, 2, 3) DESC;		--Order by 2nd to 4th character of country_name descending