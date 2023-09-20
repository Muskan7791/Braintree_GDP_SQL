/*
3\. For the year 2012, create a 3 column, 1 row report showing the percent share of gdp_per_capita for the following regions:

   (i) Asia, (ii) Europe, (iii) the Rest of the World. Your result should look something like

   Asia  | Europe | Rest of World 
   ------ | ------ | -------------
   25.0%  | 25.0%  | 50.0%
   */

With Cte1 as
	(SELECT cont.continent_name, sum(pc.gdp_per_capita) AS continent_gdp
	FROM per_capita pc
	    JOIN continent_map cm ON pc.country_code = cm.country_code
	    JOIN continents cont ON cont.continent_code = cm.continent_code
	    JOIN countries cntr ON cntr.country_code = cm.country_code
	WHERE pc.year = 2012
	GROUP BY cont.continent_name)	
SELECT
    concat(round(((SELECT Cte1.continent_gdp
                    FROM Cte1
                    WHERE Cte1.continent_name = 'Asia') 
						/ 
				  (SELECT SUM(Cte1.continent_gdp) AS total_gdp
                    FROM Cte1)) * 100,1),'%') AS Asia,
    concat(round(((SELECT Cte1.continent_gdp
                    FROM Cte1
                    WHERE Cte1.continent_name = 'Europe') 
						/ 
				  (SELECT SUM(Cte1.continent_gdp) AS total_gdp
                    FROM Cte1)) * 100,1),'%') AS Europe,
	concat(round(((SELECT SUM(Cte1.continent_gdp)
                    FROM Cte1
                    WHERE Cte1.continent_name NOT IN('Asia', 'Europe')) 
						/ 
				  (SELECT SUM(Cte1.continent_gdp) AS total_gdp
                    FROM Cte1)) * 100,1),'%') AS 'Rest of World'

/*The values may not be matching with the one provided in description. 
But I have checked the csv files and found the result to be accurate.*/