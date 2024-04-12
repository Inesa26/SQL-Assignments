--Retrieve the products that have been ordered at least 100 times. Sort Asc by Name
SELECT Product.Name, COUNT(Product.ProductID) AS Number_of_orders
FROM [Purchasing].[PurchaseOrderDetail] Purchase 
INNER JOIN [Production].[Product] Product ON Purchase.ProductID = Product.ProductID
GROUP BY Product.Name
HAVING COUNT(Product.ProductID) >= 100
ORDER BY Product.Name;

--Find the top 7 customers who have spent the most money on purchases. Sort the result on FirstName and LastName.
SELECT TOP 7 Person.FirstName, Person.LastName, SUM([Order].TotalDue) AS Total_spent
FROM [Sales].[Customer] Customer 
INNER JOIN [Person].[BusinessEntity] Business ON Customer.PersonID = Business.BusinessEntityID
INNER JOIN [Person].[Person] Person ON Business.BusinessEntityID = Person.BusinessEntityID
INNER JOIN [Sales].[SalesOrderHeader] [Order] ON [Order].CustomerID = Customer.CustomerID
GROUP BY Person.FirstName, Person.LastName
ORDER BY Person.FirstName, Person.LastName;

--Retrieve the number of active employees per each department
SELECT Department.Name, COUNT(*) AS Number_of_employees
FROM [HumanResources].[Department] Department 
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] History ON Department.DepartmentID = History.DepartmentID
WHERE History.EndDate IS NULL
GROUP BY Department.Name;

--Calculate the total number of sales made in each year.
SELECT YEAR(OrderDate) AS [Year], COUNT(*) AS Number_of_sales
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY [Year];

--Calculate the total number of orders processed by each salesperson in the year 2013. Order by number of sales in DESC order
SELECT CONCAT(Person.FirstName, ' ', Person.LastName) AS SalesPerson, COUNT(*) AS Number_of_orders
FROM  [Sales].[SalesOrderHeader] Sales 
INNER JOIN [Person].[Person] Person ON Sales.SalesPersonID = Person.BusinessEntityID
WHERE YEAR(Sales.OrderDate) = 2013
GROUP BY CONCAT(Person.FirstName, ' ', Person.LastName) 
ORDER BY COUNT(*) DESC;

--Calculate the total sales amount for each quarter of the year, broken down by territory.
SELECT Territory.Name, YEAR(Sales.OrderDate) AS [Year], DATEPART(QUARTER, Sales.OrderDate) AS [Quarter], COUNT(*) AS Total_sales
FROM [Sales].[SalesOrderHeader] Sales 
INNER JOIN [Sales].[SalesTerritory] Territory ON Sales.TerritoryID = Territory.TerritoryID
GROUP BY Territory.Name, YEAR(Sales.OrderDate), DATEPART(QUARTER, Sales.OrderDate)
ORDER BY Territory.Name, YEAR(Sales.OrderDate), DATEPART(QUARTER, Sales.OrderDate);

--List of customers who have made purchases in product category 4 - Accessories.
SELECT DISTINCT CONCAT(Person.FirstName, ' ', Person.LastName) AS CustomerName
FROM [Sales].[SalesOrderHeader] [Order] 
INNER JOIN [Sales].[SalesOrderDetail] OrderDetails ON [Order].SalesOrderID = OrderDetails.SalesOrderID
INNER JOIN [Production].[Product] Product ON OrderDetails.ProductID = Product.ProductID
INNER JOIN [Sales].[Customer] Customer ON [Order].CustomerID = Customer.CustomerID
INNER JOIN [Person].[Person] Person ON Customer.PersonID = Person.BusinessEntityID
WHERE Product.ProductSubcategoryID = 4;

--Calculate the average order value for each month of the year - 2012.
SELECT DATENAME(month, [Order].OrderDate) AS [Month], AVG([Order].TotalDue) AS [Average_order_value]
FROM [Sales].[SalesOrderHeader] [Order] 
WHERE YEAR([Order].OrderDate) = 2012
GROUP BY DATENAME(month, [Order].OrderDate);