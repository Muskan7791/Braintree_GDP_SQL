/*
5\. Find the sum of gpd_per_capita by year and the count of countries for each year that have non-null gdp_per_capita where 
(i) the year is before 2012 and 
(ii) the country has a null gdp_per_capita in 2012. Your result should have the columns:

   - year
   - country_count
   - total
   */

SELECT 
    year,
    COUNT(DISTINCT country_code) AS country_count,		-- Extract the desired columns with alias name
    CONCAT('$', CAST(ROUND(SUM(gdp_per_capita), 2) AS DECIMAL(18, 2))) AS total -- CAST as DECIMAL so that CONCAT doesn't remove the decimals
FROM per_capita
WHERE
    gdp_per_capita != 0
    AND year < 2012		--Condition 1 i.e. non-null gdp_per_capita and year < 2012
    AND country_code IN (
        SELECT country_code
        FROM per_capita
        WHERE gdp_per_capita = 0	--Condition 2 i.e. null gdp_per_capita for year = 2012
        AND year = 2012
    )
GROUP BY year;