-- ============================================================
-- India Air Quality Analytics — SQL Queries
-- Database: air_quality.db | Table: aqi
-- ============================================================

-- Q1: Top 5 most polluted cities (by avg AQI)
SELECT
    City,
    ROUND(AVG(AQI), 1) AS avg_aqi,
    ROUND(MAX(AQI), 0) AS max_aqi,
    COUNT(*)           AS days_recorded
FROM aqi
GROUP BY City
ORDER BY avg_aqi DESC
LIMIT 5;

-- Q2: Monthly AQI trend (all cities combined)
SELECT
    Month, Month_Name,
    ROUND(AVG(AQI), 1) AS avg_aqi,
    ROUND(MIN(AQI), 0) AS min_aqi,
    ROUND(MAX(AQI), 0) AS max_aqi,
    COUNT(*)           AS days_recorded
FROM aqi
GROUP BY Month, Month_Name
ORDER BY Month;

-- Q3: Unhealthy days per city (AQI > 200)
SELECT
    City,
    COUNT(*) AS unhealthy_days,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM aqi a2 WHERE a2.City = aqi.City), 1) AS pct_unhealthy,
    ROUND(AVG(AQI), 0) AS avg_aqi_on_unhealthy_days
FROM aqi
WHERE AQI > 200
GROUP BY City
ORDER BY unhealthy_days DESC
LIMIT 10;

-- Q4: Seasonal AQI averages
SELECT
    Season,
    ROUND(AVG(AQI), 1) AS avg_aqi,
    ROUND(MIN(AQI), 0) AS min_aqi,
    ROUND(MAX(AQI), 0) AS max_aqi,
    COUNT(*)           AS days_recorded
FROM aqi
GROUP BY Season
ORDER BY avg_aqi DESC;

-- Q5: Year-over-year AQI change
SELECT
    Year,
    ROUND(AVG(AQI), 1) AS avg_aqi,
    COUNT(*)           AS days_recorded
FROM aqi
GROUP BY Year
ORDER BY Year;

-- Q6: Most polluted city per year (window function)
WITH yearly_city_avg AS (
    SELECT
        Year, City,
        ROUND(AVG(AQI), 1) AS avg_aqi,
        ROW_NUMBER() OVER (PARTITION BY Year ORDER BY AVG(AQI) DESC) AS rank_in_year
    FROM aqi
    GROUP BY Year, City
)
SELECT Year, City, avg_aqi
FROM yearly_city_avg
WHERE rank_in_year = 1
ORDER BY Year;