SELECT * FROM CENSUS_NY FETCH FIRST 10 ROWS ONLY;

--To find out the total population in each county in the state of New York in 2000
SELECT COUNTY, SUM(TOTAL_POP_APRIL_2000) FROM CENSUS_NY GROUP BY COUNTY ORDER BY SUM(TOTAL_POP_APRIL_2000) DESC;

--To find out the total population in each county in the state of New York in 2010
SELECT COUNTY, SUM(TOT_POP_APRIL_2010) FROM CENSUS_NY GROUP BY COUNTY ORDER BY SUM(TOT_POP_APRIL_2010) DESC;

--Populous City or Village in 2000
SELECT GEOGRAPHIC_AREA, COUNTY, TOTAL_POP_APRIL_2000 FROM CENSUS_NY ORDER BY TOTAL_POP_APRIL_2000 DESC;

--Populous City or Village in 2010
SELECT GEOGRAPHIC_AREA, COUNTY, TOT_POP_APRIL_2010 FROM CENSUS_NY ORDER BY TOT_POP_APRIL_2010 DESC;

--Least populous City or Village in 2000
SELECT GEOGRAPHIC_AREA, COUNTY, TOTAL_POP_APRIL_2000 FROM CENSUS_NY ORDER BY TOTAL_POP_APRIL_2000 ASC;

--Least populous City or Village in 2010
SELECT GEOGRAPHIC_AREA, COUNTY, TOT_POP_APRIL_2010 FROM CENSUS_NY ORDER BY TOT_POP_APRIL_2010 ASC;

--To find out the leastpopulation in each county in the state of New York in 2000
SELECT COUNTY, MIN(TOTAL_POP_APRIL_2000) FROM CENSUS_NY GROUP BY COUNTY ORDER BY MIN(TOTAL_POP_APRIL_2000) ASC;

--To find out the leastpopulation in each county in the state of New York in 2010
SELECT COUNTY, MIN(TOT_POP_APRIL_2010) FROM CENSUS_NY GROUP BY COUNTY ORDER BY MIN(TOT_POP_APRIL_2010) ASC;