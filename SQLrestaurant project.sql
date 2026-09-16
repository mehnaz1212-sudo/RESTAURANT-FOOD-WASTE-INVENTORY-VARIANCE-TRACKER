
use restaurant;






---------- select -------
SELECT *
FROM dbo.cleaned_inventory;
use restaurant;


SELECT *
FROM dbo.cleaned_waste;
use restaurant;


-- show the first 10 rows
SELECT TOP 10 *
FROM dbo.cleaned_inventory;

SELECT TOP 10 *
FROM dbo.cleaned_waste;

-- no.of rows
SELECT COUNT(*) AS Inventory_Rows
FROM dbo.cleaned_inventory;

SELECT COUNT(*) AS Waste_Rows
FROM dbo.cleaned_waste;

-- Select specific columns
SELECT
    restaurant_name,
    ingredient_name,
    category,
    actual_total_usage,
    variance_qty,
    variance_cost_usd
FROM dbo.cleaned_inventory;



SELECT
    restaurant_name,
    ingredient_name,
    category,
    waste_qty,
    waste_cost_usd,
    waste_reason
FROM dbo.cleaned_waste;


------------  Duplicates ------------
SELECT 
    inventory_id,
    COUNT(*) AS Duplicate_Count
FROM dbo.cleaned_inventory
GROUP BY inventory_id
HAVING COUNT(*) > 1;





----------- DISTINCT ----------
-- all unique restaurants.
SELECT DISTINCT
    restaurant_name
FROM dbo.cleaned_waste;


-- all categories.
SELECT DISTINCT
    category
FROM dbo.cleaned_waste;


-- all waste reasons.
SELECT DISTINCT
    waste_reason
FROM dbo.cleaned_waste;

---------          DATA VALIDATION       ----------
-- duplicate Inventory IDs
SELECT
    inventory_id,
    COUNT(*) AS Record_Count
FROM dbo.cleaned_inventory
GROUP BY inventory_id
HAVING COUNT(*) > 1;


SELECT
    waste_log_id,
    COUNT(*) AS Record_Count
FROM dbo.cleaned_waste
GROUP BY waste_log_id
HAVING COUNT(*) > 1;


-- Checking NULL Inventory IDs
SELECT *
FROM dbo.cleaned_inventory
WHERE inventory_id IS NULL;




-- Checking NULL Waste IDs
SELECT *
FROM dbo.cleaned_waste
WHERE waste_log_id IS NULL;


-- Checking negative waste
SELECT *
FROM dbo.cleaned_waste
WHERE waste_qty < 0;

-- Checking negative waste cost
SELECT *
FROM dbo.cleaned_waste
WHERE waste_cost_usd < 0;


--------      where     --------
-- inventory records where variance quantity is greater than 10.
SELECT *
FROM dbo.cleaned_inventory
WHERE variance_qty > 10;


-- waste records where waste quantity is greater than 10.
SELECT *
FROM dbo.cleaned_waste
WHERE waste_qty > 10;


-- waste records where waste cost is greater than 100.
SELECT *
FROM dbo.cleaned_waste
WHERE waste_cost_usd > 100;




------------ AND / OR   --------
-- High quantity AND high cost:
SELECT *
FROM dbo.cleaned_waste
WHERE waste_qty > 10
  AND waste_cost_usd > 100;


-- Either high quantity OR high cost:
SELECT *
FROM dbo.cleaned_waste
WHERE waste_qty > 10
   OR waste_cost_usd > 100;



-------- ORDER BY  ---------
-- Most expensive waste first:
SELECT *
FROM dbo.cleaned_waste
ORDER BY waste_cost_usd DESC;

-- Top 10 most expensive waste transactions
SELECT TOP 10 *
FROM dbo.cleaned_waste
ORDER BY waste_cost_usd DESC;


--------    Aggregate Functions COUNT(), SUM(), AVG(), MIN(), MAX() ---------
-- Total waste quantity
SELECT
    SUM(waste_qty) AS Total_Waste_Quantity
FROM dbo.cleaned_waste;


-- Total waste cost
SELECT
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste;


-- Average waste cost
SELECT
    AVG(waste_cost_usd) AS Average_Waste_Cost
FROM dbo.cleaned_waste;


-- Maximum waste cost
SELECT
    MAX(waste_cost_usd) AS Maximum_Waste_Cost
FROM dbo.cleaned_waste;


-- Minimum waste cost
SELECT
    MIN(waste_cost_usd) AS Minimum_Waste_Cost
FROM dbo.cleaned_waste;


-------------   GROUP BY    -----------
-- Waste by restaurant
SELECT
    restaurant_name,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY restaurant_name
ORDER BY Total_Waste_Cost DESC;


-- Waste by category
SELECT
    category,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY category
ORDER BY Total_Waste_Cost DESC;


-- Waste by reason
SELECT
    waste_reason,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY waste_reason
ORDER BY Total_Waste_Cost DESC;


-- Waste by ingredient
SELECT
    ingredient_name,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY ingredient_name
ORDER BY Total_Waste_Cost DESC;

-----------   HAVING  -------------
-- Restaurants whose total waste exceeds $1,000:
SELECT
    restaurant_name,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY restaurant_name
HAVING SUM(waste_cost_usd) > 1000
ORDER BY Total_Waste_Cost DESC;




------------  CASE WHEN  ----------
-- Waste severity
SELECT
    waste_log_id,
    restaurant_name,
    waste_cost_usd,
    CASE
        WHEN waste_cost_usd >= 100 THEN 'High'
        WHEN waste_cost_usd >= 50 THEN 'Medium'
        ELSE 'Low'
    END AS Waste_Severity
FROM dbo.cleaned_waste;

--Inventory variance status
SELECT
    inventory_id,
    restaurant_name,
    ingredient_name,
    variance_qty,
    CASE
        WHEN variance_qty > 0 THEN 'Over Usage'
        WHEN variance_qty < 0 THEN 'Under Usage'
        ELSE 'No Variance'
    END AS Variance_Status
FROM dbo.cleaned_inventory;




select * from dbo.cleaned_inventory;
select * from dbo.cleaned_waste;

-------------  INNER JOIN ----------
--common columns
SELECT TOP 5
    restaurant_id,
    ingredient_id
FROM dbo.cleaned_inventory;


SELECT TOP 5
    restaurant_id,
    ingredient_id
FROM dbo.cleaned_waste;


SELECT
    i.restaurant_name,
    i.ingredient_name,
    i.category,
    i.variance_qty,
    i.variance_cost_usd,
    w.waste_qty,
    w.waste_cost_usd,
    w.waste_reason
FROM dbo.cleaned_inventory AS i
INNER JOIN dbo.cleaned_waste AS w
    ON i.restaurant_id = w.restaurant_id
   AND i.ingredient_id = w.ingredient_id;


   --------------  LEFT JOIN ------------
-- every Inventory record, whether or not it has Waste.
SELECT
    i.restaurant_name,
    i.ingredient_name,
    i.variance_qty,
    w.waste_qty,
    w.waste_cost_usd
FROM dbo.cleaned_inventory AS i
LEFT JOIN dbo.cleaned_waste AS w
    ON i.restaurant_id = w.restaurant_id
   AND i.ingredient_id = w.ingredient_id;


---------- union -----------
-- Unique restaurants from both tables:
SELECT restaurant_name
FROM dbo.cleaned_inventory

UNION

SELECT restaurant_name
FROM dbo.cleaned_waste;


------------  UNION ALL  ------------
SELECT restaurant_name
FROM dbo.cleaned_inventory

UNION ALL

SELECT restaurant_name
FROM dbo.cleaned_waste;


--------------- SUBQUERY ---------
--waste records above the average waste cost
SELECT *
FROM dbo.cleaned_waste
WHERE waste_cost_usd >
(
    SELECT AVG(waste_cost_usd)
    FROM dbo.cleaned_waste
)
ORDER BY waste_cost_usd DESC;


----------- CTE ----------
WITH Restaurant AS
(
    SELECT
        restaurant_name,
        SUM(waste_cost_usd) AS Total_Waste_Cost
    FROM dbo.cleaned_waste
    GROUP BY restaurant_name
)
SELECT
    restaurant_name,
    Total_Waste_Cost
FROM Restaurant
ORDER BY Total_Waste_Cost DESC;

------------ RANK --------
--Rank restaurants according to total waste cost
WITH RestaurantWaste AS
(
    SELECT
        restaurant_name,
        SUM(waste_cost_usd) AS Total_Waste_Cost
    FROM dbo.cleaned_waste
    GROUP BY restaurant_name
)
SELECT
    restaurant_name,
    Total_Waste_Cost,
    RANK() OVER
    (
        ORDER BY Total_Waste_Cost DESC
    ) AS Waste_Rank
FROM RestaurantWaste;

------- TOP 3 RESTAURANTS --------
WITH RestaurantWaste AS
(
    SELECT
        restaurant_name,
        SUM(waste_cost_usd) AS Total_Waste_Cost
    FROM dbo.cleaned_waste
    GROUP BY restaurant_name
),
RankedRestaurants AS
(
    SELECT
        restaurant_name,
        Total_Waste_Cost,
        RANK() OVER
        (
            ORDER BY Total_Waste_Cost DESC
        ) AS Waste_Rank
    FROM RestaurantWaste
)
SELECT *
FROM RankedRestaurants
WHERE Waste_Rank <= 3;





----------   ROW_NUMBER --------
WITH RestaurantWaste AS
(
    SELECT
        restaurant_name,
        SUM(waste_cost_usd) AS Total_Waste_Cost
    FROM dbo.cleaned_waste
    GROUP BY restaurant_name
)
SELECT
    restaurant_name,
    Total_Waste_Cost,
    ROW_NUMBER() OVER
    (
        ORDER BY Total_Waste_Cost DESC
    ) AS Row_Number
FROM RestaurantWaste;


------------  RANK WITHIN CATEGORY  -------------
WITH IngredientWaste AS
(
    SELECT
        category,
        ingredient_name,
        SUM(waste_cost_usd) AS Total_Waste_Cost
    FROM dbo.cleaned_waste
    GROUP BY
        category,
        ingredient_name
)
SELECT
    category,
    ingredient_name,
    Total_Waste_Cost,
    RANK() OVER
    (
        PARTITION BY category
        ORDER BY Total_Waste_Cost DESC
    ) AS Category_Rank
FROM IngredientWaste;


----------  TOP INGREDIENT IN EACH CATEGORY ---------
WITH IngredientWaste AS
(
    SELECT
        category,
        ingredient_name,
        SUM(waste_cost_usd) AS Total_Waste_Cost
    FROM dbo.cleaned_waste
    GROUP BY
        category,
        ingredient_name
),
RankedIngredients AS
(
    SELECT
        category,
        ingredient_name,
        Total_Waste_Cost,
        RANK() OVER
        (
            PARTITION BY category
            ORDER BY Total_Waste_Cost DESC
        ) AS Category_Rank
    FROM IngredientWaste
)
SELECT
    category,
    ingredient_name,
    Total_Waste_Cost
FROM RankedIngredients
WHERE Category_Rank = 1;



--------------  SQL Server DATE FUNCTIONS  -------------
--Waste by year
SELECT
    YEAR(log_date) AS Waste_Year,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY YEAR(log_date)
ORDER BY Waste_Year;


--Waste by month
SELECT
    YEAR(log_date) AS Waste_Year,
    MONTH(log_date) AS Waste_Month,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY
    YEAR(log_date),
    MONTH(log_date)
ORDER BY
    Waste_Year,
    Waste_Month;


--Year-Month
SELECT
    FORMAT(log_date, 'yyyy-MM') AS Year_Month,
    SUM(waste_cost_usd) AS Total_Waste_Cost
FROM dbo.cleaned_waste
GROUP BY FORMAT(log_date, 'yyyy-MM')
ORDER BY Year_Month;


--LAG()
--previous month's waste.
WITH MonthlyWaste AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(log_date),
            MONTH(log_date),
            1
        ) AS Month_Start,
        SUM(waste_cost_usd) AS Monthly_Waste
    FROM dbo.cleaned_waste
    GROUP BY
        YEAR(log_date),
        MONTH(log_date)
)
SELECT
    Month_Start,
    Monthly_Waste,
    LAG(Monthly_Waste) OVER
    (
        ORDER BY Month_Start
    ) AS Previous_Month_Waste
FROM MonthlyWaste
ORDER BY Month_Start;




--------  Running Total ------
WITH MonthlyWaste AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(log_date),
            MONTH(log_date),
            1
        ) AS Month_Start,
        SUM(waste_cost_usd) AS Monthly_Waste
    FROM dbo.cleaned_waste
    GROUP BY
        YEAR(log_date),
        MONTH(log_date)
)
SELECT
    Month_Start,
    Monthly_Waste,
    SUM(Monthly_Waste) OVER
    (
        ORDER BY Month_Start
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS Cumulative_Waste
FROM MonthlyWaste
ORDER BY Month_Start;



----------- SELF JOIN   -----------
SELECT
    A.restaurant_name AS Restaurant_1,
    B.restaurant_name AS Restaurant_2
FROM
    (SELECT DISTINCT restaurant_name FROM dbo.cleaned_waste) AS A
INNER JOIN
    (SELECT DISTINCT restaurant_name FROM dbo.cleaned_waste) AS B
    ON A.restaurant_name < B.restaurant_name;


------------- NULL Handling IS NULL, IS NOT NULL, ISNULL(), COALESCE()----------
SELECT *
FROM dbo.cleaned_waste
WHERE waste_cost_usd IS NULL;


--Replace NULL with zero
SELECT
    restaurant_name,
    ISNULL(waste_cost_usd, 0) AS Waste_Cost
FROM dbo.cleaned_waste;

--------------end ---------------