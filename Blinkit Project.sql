select * from Blinkit;

UPDATE Blinkit
SET Item_Fat_Content = 
CASE 
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

select DISTINCT(Item_Fat_Content) from Blinkit

-- 1.Total Sales 
SELECT CAST(SUM(Total_Sales)/1000000 AS decimal(10,2)) Total_Sales_Millions FROM Blinkit

-- 2. Average Sales
SELECT CAST(AVG(Total_Sales) AS decimal(10,1))AS Avg_Sales FROM Blinkit

-- 3. Number of Items 
SELECT COUNT(*) AS No_of_Items FROM Blinkit

-- 4. Average Rating 
SELECT CAST(AVG(Rating) AS decimal(10,2))AS Avg_Rating FROM Blinkit;

-- Business Requirement
-- 1.Total Sales by Fat content
SELECT Item_Fat_Content, 
    CAST(SUM(Total_Sales)AS decimal(10,2)) AS Total_Sales,
	CAST(SUM(Total_Sales)/1000 AS decimal(10,2)) Total_Sales_Thousands,
	CAST(AVG(Total_Sales) AS decimal(10,1))AS Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating) AS decimal(10,2))AS Avg_Rating
FROM Blinkit
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;

-- 2.. Total Sales By Item Type
SELECT  Item_Type, 
	CAST(SUM(Total_Sales) AS decimal(10,2)) Total_Sales,
	CAST(AVG(Total_Sales) AS decimal(10,1))AS Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating) AS decimal(10,2))AS Avg_Rating
FROM Blinkit
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- 3.Fat content by outlet for total sales
SELECT  Outlet_Location_Type, Item_Fat_Content,
	CAST(SUM(Total_Sales) AS decimal(10,2)) Total_Sales
FROM Blinkit
GROUP BY Outlet_Location_Type,Item_Fat_Content


SELECT Outlet_Location_Type,
	ISNULL([Low Fat],0) AS Low_Fat,
	ISNULL([Regular],0) AS Regular
FROM
(
 SELECT  Outlet_Location_Type, Item_Fat_Content,
	CAST(SUM(Total_Sales) AS decimal(10,2)) Total_Sales
FROM Blinkit
GROUP BY Outlet_Location_Type,Item_Fat_Content
)AS SourceTable
PIVOT
(
 SUM(Total_Sales)                                          
 FOR Item_Fat_Content IN ([Low Fat],[Regular])
 )AS PIVOTTABLE
 ORDER BY Outlet_Location_Type;

 -- 4. Total Sales by outlet Establishment 
 SELECT  Outlet_Establishment_Year,
	CAST(SUM(Total_Sales) AS decimal(10,2)) Total_Sales,
	CAST(AVG(Total_Sales) AS decimal(10,1))AS Avg_Sales,
	COUNT(*) AS No_of_Items,
	CAST(AVG(Rating) AS decimal(10,2))AS Avg_Rating
FROM Blinkit
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;

-- 5.Percentage of sales by outlet size
SELECT 
    Outlet_Size,
    CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales,
    CAST(SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER () AS decimal(10,2)) AS Sales_Percentage
FROM Blinkit
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- 6.  by outlet location
SELECT  
    Outlet_Location_Type,
    CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS decimal(10,1)) AS Avg_Sales,
    COUNT(*) AS No_of_Items,
    CAST(AVG(Rating) AS decimal(10,2)) AS Avg_Rating
FROM Blinkit
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- 7. All metrics by outlet type
SELECT Outlet_Type,
    CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales,
	CAST(SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER () AS decimal(10,2)) AS Sales_Percentage,
    CAST(AVG(Total_Sales) AS decimal(10,1)) AS Avg_Sales,
    COUNT(*) AS No_of_Items,
    CAST(AVG(Rating) AS decimal(10,2)) AS Avg_Rating
FROM Blinkit
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
