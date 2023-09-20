/*
4a\. What is the count of countries and sum of their related gdp_per_capita values for the year 2007 
where the string 'an' (case insensitive) appears anywhere in the country name?

   4b\. Repeat question 4a, but this time make the query case sensitive.
*/

SELECT
    COUNT(cont.country_name) AS country_count,
    CONCAT('$',CAST(ROUND(SUM(pc.gdp_per_capita),2) AS DECIMAL(18,2))) AS total_gdp
FROM
    countries cont
    JOIN per_capita pc ON cont.country_code = pc.country_code
WHERE
    YEAR = 2007
    AND LOWER(cont.country_name) LIKE '%an%';

/*The result is same in both the cases*/
