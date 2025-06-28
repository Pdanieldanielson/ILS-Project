SELECT TOP 5
    Item_Description,
    Category_Name,
    SUM(Sale_Dollars) AS Total_Sales,
    SUM(Bottles_Sold) AS Total_Bottles_Sold,
    SUM(Volume_Sold_Liters) AS Total_Liters_Sold
FROM 
    liquor_sales_cleaned
GROUP BY 
    Item_Description, Category_Name
ORDER BY 
    Total_Sales DESC
;

/* Top 5 selling products in order = Titos, Black Velvet, Crown Royal, Fireball Whiskey, Jack Daniels */

SELECT 
    YEAR([Date]) AS Sale_Year,
    Category_Name,
    SUM(Sale_Dollars) AS Total_Sales,
    SUM(Bottles_Sold) AS Total_Bottles_Sold
FROM 
    liquor_sales_cleaned
GROUP BY 
    YEAR([Date]), Category_Name
ORDER BY 
    Sale_Year, Total_Sales DESC;

/* Best Sellers By Year */

SELECT TOP 5
    County,
    SUM(Sale_Dollars) AS Total_Sales,
    SUM(Volume_Sold_Liters) AS Total_Liters_Sold,
    COUNT(DISTINCT Store_Number) AS Unique_Stores
FROM 
    liquor_sales_cleaned
WHERE 
    [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    County
ORDER BY 
    Total_Sales DESC;

/* Highest sales by top 5 counties all time (not date specific) 
POLK, LINN, SCOTT, JOHNSON, BLACK HAWK */

SELECT TOP 5
    Vendor_Name,
    SUM(Sale_Dollars) AS Total_Sales,
    SUM(Bottles_Sold * (State_Bottle_Retail - State_Bottle_Cost)) AS Total_Profit,
    AVG((State_Bottle_Retail - State_Bottle_Cost) / State_Bottle_Cost * 100.0) AS Avg_Profit_Margin_Percent
FROM 
    liquor_sales_cleaned
WHERE 
    [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    Vendor_Name
HAVING 
    SUM(Sale_Dollars) > 10000  -- Filter for significant vendors
ORDER BY 
    Avg_Profit_Margin_Percent DESC;


SELECT TOP 1
    

/* Top 5 Vendors by Profit Margin (Sales - Cost) all time = Demerara Distillers inc, Bad Bear Enterprises LLC, Driftless Glen Distillery, Prestige Wine & Spirits, DV Spirits LLC */


SELECT 
    DATENAME(MONTH, [Date]) AS Sale_Month,
    YEAR([Date]) AS Sale_Year,
    SUM(Sale_Dollars) AS Total_Sales,
    SUM(Volume_Sold_Liters) AS Total_Liters_Sold
FROM 
    liquor_sales_cleaned
WHERE 
    [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    DATENAME(MONTH, [Date]), YEAR([Date]), MONTH([Date])
ORDER BY 
    Sale_Year, MONTH([Date]);

/* Seasonal Patterns by year */


SELECT TOP 5
    Store_Name,
    City,
    County,
    SUM(Sale_Dollars) AS Total_Sales,
    COUNT(DISTINCT Invoice_Item_Number) AS Total_Transactions,
    SUM(Sale_Dollars) / CAST(COUNT(DISTINCT Invoice_Item_Number) AS FLOAT) AS Avg_Sale_Per_Transaction
FROM 
    liquor_sales_cleaned
WHERE 
    [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    Store_Name, City, County
HAVING 
    COUNT(DISTINCT Invoice_Item_Number) > 50  -- Ensure meaningful sample size
ORDER BY 
    Avg_Sale_Per_Transaction DESC;




SELECT 
    Category_Name,
    Bottle_Volume_ml,
    SUM(Bottles_Sold) AS Total_Bottles_Sold,
    SUM(Sale_Dollars) AS Total_Sales
FROM 
    liquor_sales_cleaned
WHERE 
    [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    Category_Name, Bottle_Volume_ml
ORDER BY 
    Category_Name, Total_Bottles_Sold DESC;




SELECT 
    CASE 
        WHEN State_Bottle_Retail < 10 THEN 'Under $10'
        WHEN State_Bottle_Retail BETWEEN 10 AND 20 THEN '$10-$20'
        WHEN State_Bottle_Retail BETWEEN 20 AND 30 THEN '$20-$30'
        ELSE 'Over $30'
    END AS Price_Range,
    SUM(Sale_Dollars) AS Total_Sales,
    SUM(Bottles_Sold) AS Total_Bottles_Sold
FROM 
    liquor_sales_cleaned
WHERE 
    [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    CASE 
        WHEN State_Bottle_Retail < 10 THEN 'Under $10'
        WHEN State_Bottle_Retail BETWEEN 10 AND 20 THEN '$10-$20'
        WHEN State_Bottle_Retail BETWEEN 20 AND 30 THEN '$20-$30'
        ELSE 'Over $30'
    END
ORDER BY 
    Total_Sales DESC;





SELECT TOP 10
    City,
    County,
    SUM(Sale_Dollars) AS Total_Sales,
    SUM(Volume_Sold_Liters) AS Total_Liters_Sold
FROM 
    liquor_sales_cleaned
WHERE 
    Category_Name = 'AMERICAN VODKAS'
    AND [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    City, County
ORDER BY 
    Total_Sales DESC;




SELECT TOP 5
    Item_Description,
    Category_Name,
    Vendor_Name,
    SUM(Bottles_Sold) AS Total_Bottles_Sold,
    SUM(Sale_Dollars) AS Total_Sales
FROM 
    liquor_sales_cleaned
WHERE 
    [Date] BETWEEN '2019-01-01' AND '2025-12-31'
GROUP BY 
    Item_Description, Category_Name, Vendor_Name
HAVING 
    SUM(Bottles_Sold) < 10  -- Low sales threshold
ORDER BY 
    Total_Bottles_Sold ASC;


WITH RankedSales AS (
    SELECT
        YEAR([Date]) AS Sale_Year,
        Item_Description,
        SUM(Sale_Dollars) AS Total_Sales,
        SUM(Bottles_Sold) AS Total_Bottles_Sold,
        ROW_NUMBER() OVER (PARTITION BY YEAR([Date]) ORDER BY SUM(Sale_Dollars) DESC) AS Sales_Rank
    FROM 
        liquor_sales_cleaned
    GROUP BY 
        YEAR([Date]), Item_Description
)
SELECT 
    Sale_Year,
    Item_Description,
    Total_Sales,
    Total_Bottles_Sold
FROM 
    RankedSales
WHERE 
    Sales_Rank = 1
ORDER BY 
    Sale_Year;

WITH YearlyAverages AS (
    SELECT 
        YEAR(Date) AS Sale_Year,
        AVG(State_Bottle_Retail) AS Avg_Retail_Price,
        SUM(Bottles_Sold) AS Total_Bottles_Sold,
        SUM(Sale_Dollars) AS Total_Sales_Dollars
    FROM liquor_sales_cleaned
    WHERE 
        Date BETWEEN '2019-01-01' AND '2025-12-31'
        AND Item_Description LIKE '%TITO%'
    GROUP BY YEAR(Date)
),
YearlyChange AS (
    SELECT 
        Sale_Year,
        Avg_Retail_Price,
        Total_Bottles_Sold,
        Total_Sales_Dollars,
        LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year) AS Prev_Year_Price,
        CASE 
            WHEN LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year) IS NOT NULL 
            THEN ((Avg_Retail_Price - LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year)) / LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year)) * 100 
            ELSE NULL 
        END AS YoY_Percent_Change
    FROM YearlyAverages
)
SELECT 
    Sale_Year,
    ROUND(Avg_Retail_Price, 2) AS Avg_Retail_Price,
    Total_Bottles_Sold,
    ROUND(Total_Sales_Dollars, 2) AS Total_Sales_Dollars,
    ROUND(Prev_Year_Price, 2) AS Prev_Year_Price,
    ROUND(YoY_Percent_Change, 2) AS YoY_Percent_Change
FROM YearlyChange
ORDER BY Sale_Year;
    
SELECT 
    COUNT(*) AS Null_Count,
    MIN(State_Bottle_Retail) AS Min_Price,
    MAX(State_Bottle_Retail) AS Max_Price
FROM liquor_sales_cleaned
WHERE Item_Description LIKE '%TITO%';

SELECT 
    Sale_Year,
    SUM(Sale_Dollars) AS Actual_Sales,
    SUM(State_Bottle_Retail * Bottles_Sold) AS Calculated_Sales
FROM (
    SELECT 
        YEAR(Date) AS Sale_Year,
        State_Bottle_Retail,
        Bottles_Sold,
        Sale_Dollars
    FROM liquor_sales_cleaned
    WHERE Item_Description LIKE '%TITO%'
) t
GROUP BY Sale_Year;

SELECT DISTINCT Item_Description
FROM liquor_sales_cleaned
WHERE Item_Description LIKE '%TITO%'
;

WITH YearlyAverages AS (
    SELECT 
        YEAR(Date) AS Sale_Year,
        AVG(State_Bottle_Retail) AS Avg_Retail_Price,
        SUM(Bottles_Sold) AS Total_Bottles_Sold,
        SUM(Sale_Dollars) AS Total_Sales_Dollars
    FROM liquor_sales_cleaned
    WHERE 
        Date BETWEEN '2019-01-01' AND '2025-12-31' 
    GROUP BY YEAR(Date)
),
YearlyChange AS (
    SELECT 
        Sale_Year,
        Avg_Retail_Price,
        Total_Bottles_Sold,
        Total_Sales_Dollars,
        LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year) AS Prev_Year_Price,
        CASE 
            WHEN LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year) IS NOT NULL 
            THEN ((Avg_Retail_Price - LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year)) / LAG(Avg_Retail_Price) OVER (ORDER BY Sale_Year)) * 100 
            ELSE NULL 
        END AS YoY_Percent_Change
    FROM YearlyAverages
)
SELECT 
    Sale_Year,
    ROUND(Avg_Retail_Price, 2) AS Avg_Retail_Price,
    Total_Bottles_Sold,
    ROUND(Total_Sales_Dollars, 2) AS Total_Sales_Dollars,
    ROUND(Prev_Year_Price, 2) AS Prev_Year_Price,
    ROUND(YoY_Percent_Change, 2) AS YoY_Percent_Change
FROM YearlyChange
ORDER BY Sale_Year;