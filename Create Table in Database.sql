USE IowaLiquorSales;

CREATE TABLE liquor_sales_cleaned (
    Invoice_Item_Number VARCHAR(50),
    [Date] DATE,
    Store_Number INT,
    Store_Name VARCHAR(100),
    [Address] VARCHAR(100),
    City VARCHAR(50),
    Zip_Code VARCHAR(10),
    Store_Location VARCHAR(100),
    County_Number INT,
    County VARCHAR(50),
    Category FLOAT,
    Category_Name VARCHAR(100),
    Vendor_Number FLOAT,
    Vendor_Name VARCHAR(100),
    Item_Number INT,
    Item_Description VARCHAR(100),
    Pack INT,
    Bottle_Volume_ml INT,
    State_Bottle_Cost FLOAT,
    State_Bottle_Retail FLOAT,
    Bottles_Sold INT,
    Sale_Dollars FLOAT,
    Volume_Sold_Liters FLOAT,
    Volume_Sold_Gallons FLOAT,
    Longitude FLOAT,
    Latitude FLOAT
);

USE IowaLiquorSales;

BULK INSERT liquor_sales_cleaned
FROM 'C:\Users\phili\Downloads\final_cleaned_2019_2025.csv'
WITH (
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n',   -- Row delimiter
    FIRSTROW = 2,           -- Skip header row
    FORMAT = 'CSV',         -- Specify CSV format
    FIELDQUOTE = '"',       -- Handle quoted fields
    TABLOCK                 -- Improve performance with table lock
);

ALTER TABLE dbo.liquor_sales
ALTER COLUMN Zip_Code VARCHAR(10);

ALTER TABLE dbo.liquor_sales
ALTER COLUMN Pack INT NULL;

ALTER TABLE dbo.liquor_sales
ALTER COLUMN Item_Number INT NULL;

ALTER TABLE dbo.liquor_sales
ALTER COLUMN Zip_Code VARCHAR(20);  -- Increase length

ALTER TABLE dbo.liquor_sales
ALTER COLUMN County_Number FLOAT NULL;

ALTER TABLE dbo.liquor_sales
ALTER COLUMN Category FLOAT NULL;

ALTER TABLE dbo.liquor_sales
ALTER COLUMN Pack INT NULL;

ALTER TABLE dbo.liquor_sales
ALTER COLUMN Item_Number INT NULL;