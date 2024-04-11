--1
--From the Person.Person table write a query in SQL to return all rows and a subset of the columns 
--(FirstName, LastName, businessentityid) from the person table in the AdventureWorks database. 
--The third column heading is renamed to Employee_id. Arranged the output in ascending order by lastname.

SELECT FirstName, LastName, BusinessEntityID AS Employee_id
FROM Person.Person
ORDER BY LastName;

--2
--From the Person.PersonPhone table write a query in SQL to find the persons whose last name starts 
--with letter 'L'. Return BusinessEntityID, FirstName, LastName, and PhoneNumber. 
--Sort the result on lastname and firstname.

SELECT Person.BusinessEntityID, Person.FirstName, Person.LastName, Phone.PhoneNumber
FROM Person.PersonPhone Phone INNER JOIN Person.Person Person ON Phone.BusinessEntityID = Person.BusinessEntityID
WHERE Person.LastName LIKE 'L%'
ORDER BY Person.LastName, Person.FirstName;

--3
--From the following tables: Sales.SalesPerson, Person.Person, Person.Address
--Write a query in SQL to retrieve the salesperson for each PostalCode who belongs to a territory and 
--SalesYTD is not zero. Return row numbers of each group of PostalCode, last name, salesytd, postalcode column. 
--Sort the salesytd of each postalcode group in descending order. Shorts the postalcode in ascending order.

SELECT Address.PostalCode, Person.LastName, Sales.SalesYTD
FROM Person.Person Person INNER JOIN Sales.SalesPerson Sales ON Person.BusinessEntityID = Sales.BusinessEntityID
						  INNER JOIN Person.BusinessEntityAddress Business ON Sales.BusinessEntityID = Business.BusinessEntityID
						  INNER JOIN Person.Address Address ON Business.AddressID = Address.AddressID
WHERE Sales.SalesYTD != 0 AND Sales.TerritoryID IS NOT NULL
GROUP BY Address.PostalCode, Person.LastName, Sales.SalesYTD
ORDER BY Sales.SalesYTD DESC, Address.PostalCode ASC

--4
--From the following table: Sales.SalesOrderDetail 
--Write a query in SQL to retrieve the total cost of each salesorderID that exceeds 100000. 
--Return SalesOrderID, total cost.

SELECT SalesOrderId, SUM(LineTotal) AS Total_Cost
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderId
HAVING SUM(LineTotal) > 100000