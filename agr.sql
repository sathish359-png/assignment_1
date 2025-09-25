SHOW tables;
select	* from agricultural;
SHOW COLUMNS FROM agricultural;
CREATE DATABASE agri_db;
DESCRIBE agricultural;

--------#Year-wise Trend of Rice Production Across States (Top 3)

SELECT 
    Year, 
    `State Name`, 
    SUM(`RICE PRODUCTION (1000 tons)`) AS total_rice_production
FROM agricultural
GROUP BY Year, `State Name`
ORDER BY Year, total_rice_production DESC 
LIMIT 3;


-----Top 5 Districts by Wheat Yield Increase Over the Last 5 Years

SELECT 
    Year,
    `Dist Name`,
    COUNT(`WHEAT YIELD (Kg per ha)`) AS Wheat_Yield_Count
FROM agricultural
GROUP BY Year, `Dist Name`
ORDER BY Year, Wheat_Yield_Count ASC
LIMIT 5;


----States with the Highest Growth in Oilseed Production (5-Year Growth Rate)
SELECT 
    Year,
    COUNT(`State Name`) AS States_Count,
    SUM(`OILSEEDS PRODUCTION (1000 tons)`) AS Total_Oilseeds_Production
FROM agricultural
GROUP BY Year
ORDER BY Year, Total_Oilseeds_Production DESC
LIMIT 5;


-------District-wise Correlation Between Area and Production for Major Crops (Rice, Wheat, and Maize)

SELECT
    `Dist Name`,
    CORR(`RICE AREA (1000 ha)`, `RICE PRODUCTION (1000 tons)`) AS rice_corr,
    CORR(`WHEAT AREA (1000 ha)`, `WHEAT PRODUCTION (1000 tons)`) AS wheat_corr,
    CORR(`MAIZE AREA (1000 ha)`, `MAIZE PRODUCTION (1000 tons)`) AS maize_corr
FROM agricultural
GROUP BY `Dist Name`
ORDER BY `Dist Name`;



-----Yearly Production Growth of Cotton in Top 5 Cotton Producing States

WITH top_states AS (
    SELECT 
        `State Name`,
        SUM(`COTTON PRODUCTION (1000 tons)`) AS total_cotton
    FROM agricultural
    GROUP BY `State Name`
)
SELECT *
FROM top_states
ORDER BY total_cotton DESC
LIMIT 5;


------Districts with the Highest Groundnut Production

SELECT 
    `Dist Name`,
    `State Name`,
    `GROUNDNUT PRODUCTION (1000 tons)`
FROM agricultural
ORDER BY `GROUNDNUT PRODUCTION (1000 tons)` DESC
LIMIT 10;




----Annual Average Maize Yield Across All States

SELECT
    `Year`,
    AVG(`MAIZE YIELD (Kg per ha)`) AS avg_maize_yield
FROM agricultural
GROUP BY `Year`
ORDER BY `Year`;


------Total Area Cultivated for Oilseeds in Each State

SELECT
    `State Name`,
    SUM(
        `GROUNDNUT AREA (1000 ha)` +
        `SESAMUM AREA (1000 ha)` +
        `RAPESEED AND MUSTARD AREA (1000 ha)` +
        `SAFFLOWER AREA (1000 ha)` +
        `CASTOR AREA (1000 ha)` +
        `LINSEED AREA (1000 ha)` +
        `SUNFLOWER AREA (1000 ha)` +
        `SOYABEAN AREA (1000 ha)`
    ) AS total_oilseed_area_1000_ha
FROM agricultural
GROUP BY `State Name`
ORDER BY total_oilseed_area_1000_ha DESC;



----Districts with the Highest Rice Yield

SELECT
    `Dist Name`,
    `State Name`,
    `RICE YIELD (Kg per ha)` AS rice_yield
FROM agricultural
ORDER BY rice_yield DESC
LIMIT 10;

----Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years

WITH top_states AS (
    SELECT
        `State Name`,
        SUM(`RICE PRODUCTION (1000 tons)` + `WHEAT PRODUCTION (1000 tons)`) AS total_production
    FROM agricultural
    GROUP BY `State Name`
    ORDER BY total_production DESC
    LIMIT 5
)

SELECT
    a.`State Name`,
    a.`Year`,
    a.`RICE PRODUCTION (1000 tons)` AS rice_production,
    a.`WHEAT PRODUCTION (1000 tons)` AS wheat_production
FROM agricultural a
JOIN top_states t
    ON a.`State Name` = t.`State Name`
WHERE a.`Year` >= (SELECT MAX(`Year`) - 9 FROM agricultural)  -- last 10 years
ORDER BY a.`State Name`, a.`Year`;

