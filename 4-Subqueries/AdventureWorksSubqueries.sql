USE AdventureWorks2017

--Get Name and Surname of sales person with the biggest bonus.
SELECT Person.FirstName, Person.LastName, SalePerson.Bonus
FROM [Sales].[SalesPerson] SalePerson
INNER JOIN [Person].[Person] Person ON Person.BusinessEntityID = SalePerson.BusinessEntityID
WHERE SalePerson.Bonus = (SELECT MAX(Bonus) FROM [Sales].[SalesPerson])

--Calculate the average number of days taken to ship orders for each shipping method.
SELECT Ship.Name, AVG(DaysToShip) AS Average
FROM(
	SELECT DATEDIFF(DAY, Sales.OrderDate, Sales.ShipDate) AS DaysToShip, Sales.ShipMethodID
	FROM [Sales].[SalesOrderHeader] Sales
) AS PurchasingDays 
INNER JOIN [Purchasing].[ShipMethod] Ship ON PurchasingDays.ShipMethodID = Ship.ShipMethodID
GROUP BY Ship.Name;

--Retrieve the names of all customers who have placed orders with a total order amount greater than the average total order amount.
SELECT CONCAT(Person.FirstName, ' ', Person.LastName) AS CustomerName, MAX([Order].TotalDue) AS Max_order_amount
FROM [Sales].[SalesOrderHeader] [Order] 
INNER JOIN [Sales].[Customer] Customer ON [Order].CustomerID = Customer.CustomerID
INNER JOIN [Person].[Person] Person ON Customer.PersonID = Person.BusinessEntityID
WHERE [Order].TotalDue > (SELECT AVG(TotalDue) FROM [Sales].[SalesOrderHeader])
GROUP BY CONCAT(Person.FirstName, ' ', Person.LastName);

--Get the territories where the total sales amount exceeds the average total sales amount across all territories.
WITH TerritorySales AS (
    SELECT TerritoryID, SUM(TotalDue) AS TotalSales
    FROM [Sales].[SalesOrderHeader]
    GROUP BY TerritoryID
)
SELECT Territory.Name, TS.TotalSales
FROM TerritorySales TS
INNER JOIN [Sales].[SalesTerritory] Territory ON TS.TerritoryID = Territory.TerritoryID
WHERE TS.TotalSales > (SELECT AVG(TotalSales) FROM TerritorySales);

--Find the product IDs and names of products that have been ordered more than the average number of times across all orders.
WITH ProductOrders AS (
    SELECT ProductID, COUNT(*) AS OrderCount
    FROM [Sales].[SalesOrderDetail]
    GROUP BY ProductID
)
SELECT P.ProductID, P.Name, PO.OrderCount
FROM ProductOrders PO
INNER JOIN [Production].[Product] P ON PO.ProductID = P.ProductID
WHERE PO.OrderCount > (SELECT AVG(OrderCount) FROM ProductOrders);

--Retrieve the names of all job titles along with the average number of years of experience for employees in each job title.
SELECT JobExperience.JobTitle, AVG(Years_of_experience)
FROM (SELECT Employee.JobTitle, DATEDIFF(YEAR, Employee.HireDate, GETDATE()) AS Years_of_experience
      FROM [HumanResources].[Employee] Employee
	  ) AS JobExperience
GROUP BY JobExperience.JobTitle;

--Get the total number of orders placed by each sales representative, and then find the sales representative with the highest number of orders.
WITH Sales_Counts AS(
SELECT CONCAT(Person.FirstName, ' ', Person.LastName) AS FullName, COUNT([Order].SalesOrderID) AS NumberOfOrders
FROM [Sales].[SalesOrderHeader] [Order] 
INNER JOIN [Sales].[SalesPerson] SalePerson ON [Order].SalesPersonID = SalePerson.BusinessEntityID
INNER JOIN [Person].[Person] Person ON SalePerson.BusinessEntityID = Person.BusinessEntityID
GROUP BY CONCAT(Person.FirstName, ' ', Person.LastName)
)
SELECT FullName, NumberOfOrders
FROM Sales_Counts
WHERE NumberOfOrders = (SELECT MAX(NumberOfOrders) FROM Sales_Counts);

--Retrieve the names and email addresses of customers who have not placed any orders in the year 2014.
SELECT Person.FirstName, Person.LastName, Email.EmailAddress
FROM [Sales].[Customer] Customer
INNER JOIN [Person].[Person] Person ON Customer.PersonID = Person.BusinessEntityID
INNER JOIN [Person].[EmailAddress] Email ON Person.BusinessEntityID = Email.BusinessEntityID
WHERE Customer.CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM [Sales].[SalesOrderHeader]
    WHERE YEAR(OrderDate) = 2014);
