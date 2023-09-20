/* 
7\. Find the country with the highest average gdp_per_capita for each continent for all years. 
Now compare your list to the following data set. Please describe any and all mistakes that you 
can find with the data set below. Include any code that you use to help detect these mistakes.

   rank | continent_name | country_code | country_name | avg_gdp_per_capita 
   ---- | -------------- | ------------ | ------------ | -----------------
      1 | Africa         | SYC          | Seychelles   |         $11,348.66
      1 | Asia           | KWT          | Kuwait       |         $43,192.49
      1 | Europe         | MCO          | Monaco       |        $152,936.10
      1 | North America  | BMU          | Bermuda      |         $83,788.48
      1 | Oceania        | AUS          | Australia    |         $47,070.39
      1 | South America  | CHL          | Chile        |         $10,781.71
*/
USE Braintree;

WITH cte1 AS
(
    SELECT
        cont.continent_name,
        cntr.country_code,
        cntr.country_name,
        ROUND(AVG(pc.gdp_per_capita), 2) AS avg_gdp_per_capita		-- Get average GDP
    FROM
        continent_map cm
        JOIN continents cont ON cont.continent_code = cm.continent_code
        JOIN countries cntr ON cntr.country_code = cm.country_code
        JOIN per_capita pc ON pc.country_code = cntr.country_code
    GROUP BY
        cont.continent_name,
        cntr.country_code,
        cntr.country_name		-- Join all table and group by
),
cte2 AS
(
    SELECT
        DENSE_RANK() OVER (PARTITION BY cte1.continent_name ORDER BY cte1.avg_gdp_per_capita DESC) AS rank,		-- Dense rank on continent partition
        cte1.*
    FROM
        cte1
)
SELECT
    cte2.rank,
    cte2.continent_name,
    cte2.country_code,
    cte2.country_name,
    CONCAT('$', cte2.avg_gdp_per_capita) AS avg_gdp_per_capita		-- Concat in the end to avoid error in Window function
FROM
    cte2
WHERE
    rank = 1;

/*From our result we can observe that only the record for South America is correct. 
All other records have error in either the country_code/country_name or the avg_gdp_per_capita.*/