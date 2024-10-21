use coffee;


SELECT ROUND(SUM(unit_price * transaction_qty), 0) AS Total_Sales 
FROM  [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE MONTH(transaction_date) = 5;




/* TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH*/
WITH MonthlySales AS (
    SELECT 
        MONTH(transaction_date) AS month,
        ROUND(SUM(unit_price * transaction_qty), 0) AS total_sales
    FROM 
        [dbo].[Coffee Shop Sales.xlsx - Transactions]
    WHERE 
        MONTH(transaction_date) IN (4, 5) 
    GROUP BY 
        MONTH(transaction_date)
)

SELECT 
    month,
    total_sales,
    CASE 
        WHEN LAG(total_sales, 1) OVER (ORDER BY month) IS NULL THEN NULL
        ELSE 
            (total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) * 100.0 / LAG(total_sales, 1) OVER (ORDER BY month)
    END AS mom_increase_percentage
FROM 
    MonthlySales
ORDER BY 
    month;



	/*CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS*/
	SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    transaction_date = '2023-05-18';


	/*DAILY SALES FOR MONTH(5) SELECTED*/
	SELECT 
    DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty), 1) AS total_sales
FROM 
    [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    MONTH(transaction_date) = 5 
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);



	/*COMPARING DAILY SALES WITH AVERAGE SALES_ When Month = 5 */
	SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        [dbo].[Coffee Shop Sales.xlsx - Transactions]
    WHERE 
        MONTH(transaction_date) = 5  
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;


	/*SALES BY WEEKDAY / WEEKEND IN MAY*/
	SELECT 
    CASE 
        WHEN DATEPART(WEEKDAY, transaction_date) IN (1, 7) THEN 'Weekends'  
        ELSE 'Weekdays'
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_sales
FROM 
    [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    MONTH(transaction_date) = 5  
GROUP BY 
    CASE 
        WHEN DATEPART(WEEKDAY, transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;


/*SALES BY STORE LOCATION*/
SELECT 
    store_location,
    SUM(unit_price * transaction_qty) AS Total_Sales
FROM 
    [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    MONTH(transaction_date) = 5  
GROUP BY 
    store_location
ORDER BY 
    SUM(unit_price * transaction_qty) DESC;




/*SALES BY PRODUCT CATEGORY*/
SELECT 
    product_category,
    ROUND(SUM(unit_price * transaction_qty), 1) AS Total_Sales
FROM 
    [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    MONTH(transaction_date) = 5  
GROUP BY 
    product_category
ORDER BY 
    SUM(unit_price * transaction_qty) DESC;



/*SALES BY PRODUCTS (TOP 10)*/
SELECT TOP 10
    product_type,
    ROUND(SUM(unit_price * transaction_qty), 1) AS Total_Sales
FROM 
    [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    MONTH(transaction_date) = 5  
GROUP BY 
    product_type
ORDER BY 
    SUM(unit_price * transaction_qty) DESC;




/*SALES BY DAY | HOUR*/
SELECT 
    ROUND(SUM(unit_price * transaction_qty), 0) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    DATEPART(WEEKDAY, transaction_date) = 3 -- Lọc cho thứ Ba (1 là Chủ Nhật, 2 là Thứ Hai, ..., 7 là Thứ Bảy)
    AND DATEPART(HOUR, transaction_time) = 8 -- Lọc cho giờ thứ 8 (8:00 AM đến 8:59 AM)
    AND MONTH(transaction_date) = 5; -- Lọc cho tháng 5
	------------------------------------
SELECT 
    CASE 
        WHEN DATEPART(WEEKDAY, transaction_date) = 2 THEN 'Monday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 3 THEN 'Tuesday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 4 THEN 'Wednesday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 5 THEN 'Thursday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 6 THEN 'Friday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty), 0) AS Total_Sales,
    DATEPART(WEEKDAY, transaction_date) AS Weekday_Order 
FROM 
   [dbo].[Coffee Shop Sales.xlsx - Transactions]
WHERE 
    MONTH(transaction_date) = 5 -- Lọc cho tháng 5
GROUP BY 
    CASE 
        WHEN DATEPART(WEEKDAY, transaction_date) = 2 THEN 'Monday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 3 THEN 'Tuesday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 4 THEN 'Wednesday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 5 THEN 'Thursday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 6 THEN 'Friday'
        WHEN DATEPART(WEEKDAY, transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END,
    DATEPART(WEEKDAY, transaction_date) 
ORDER BY 
    Weekday_Order;