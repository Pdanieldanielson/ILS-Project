SELECT
	County as Location,
	FORMAT(SUM(Sale_Dollars), 2) AS Sales
FROM 
	ILS_5M2
Group by 
	County
Order by 
	Sales DESC;