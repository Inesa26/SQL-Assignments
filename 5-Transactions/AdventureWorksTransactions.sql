-- Create a new salesperson.
BEGIN TRANSACTION AddSalesPersonTransaction;
BEGIN TRY
    DECLARE @NewBusinessEntityID INT;
    
	INSERT INTO Person.BusinessEntity (ModifiedDate)
    VALUES (GETDATE());
   
    SET @NewBusinessEntityID = SCOPE_IDENTITY();
 
    INSERT INTO [Person].[Person] ([BusinessEntityID], [PersonType], [NameStyle], [Title], 
	                               [FirstName], [LastName], [EmailPromotion])
    VALUES (@NewBusinessEntityID, 'EM', 0, 'Mrs.', 'Inesa', 'Godorozea', 1);

    INSERT INTO [HumanResources].[Employee] ([BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode],
	                                         [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate])
    VALUES (@NewBusinessEntityID, '9876543210', 'adventure-works\iness', 0x5AE178, 'Engineer', '1993-01-25', 'M', 'F', GETDATE() );
    
    INSERT INTO [Sales].[SalesPerson] ([BusinessEntityID], [TerritoryID], [SalesQuota], [Bonus], [CommissionPct])
    VALUES (@NewBusinessEntityID, 2, 250000, 500, 0.01);
    
    COMMIT TRANSACTION AddSalesPersonTransaction;
    PRINT 'New salesperson added successfully.';
END TRY
BEGIN CATCH
   
    ROLLBACK TRANSACTION AddSalesPersonTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH

---- Create a new order
BEGIN TRANSACTION AddOrderTransaction;
BEGIN TRY
    DECLARE @NewOrderID INT;

    IF EXISTS (
        SELECT *
        FROM [Production].[ProductInventory] PI
        WHERE PI.ProductID = 712 
        AND PI.Quantity >= 6 
    )
    BEGIN

        INSERT INTO Sales.SalesOrderHeader ([RevisionNumber], [OrderDate], [DueDate], [Status], [OnlineOrderFlag], [CustomerID], [SalesPersonID], 
                                            [TerritoryID], [BillToAddressID], [ShipToAddressID], [ShipMethodID], [TaxAmt], [Freight])
        VALUES (8, GETDATE(), DATEADD(DAY, 12, GETDATE()), 5, 1, 9, 20778, 10, 16731, 16731, 5, 55.9279, 17.4775);

        SET @NewOrderID = SCOPE_IDENTITY();

        INSERT INTO Sales.SalesOrderDetail ([SalesOrderID], [CarrierTrackingNumber], [OrderQty], [ProductID], 
		                                    [SpecialOfferID], [UnitPrice], [UnitPriceDiscount])
        VALUES (@NewOrderID, '4E0A-4J89-AI', 6, 712, 1, 5.1865, 0.00);

        COMMIT TRANSACTION AddOrderTransaction;
        PRINT 'New order added successfully.';
    END
    ELSE
    BEGIN
     
        ROLLBACK TRANSACTION AddOrderTransaction;
        PRINT 'Transaction rolled back: Product is not available in sufficient quantity.';
    END
END TRY
BEGIN CATCH

    ROLLBACK TRANSACTION AddOrderTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;

--Update an existing order
BEGIN TRANSACTION UpdateOrderTransaction;
BEGIN TRY
    UPDATE [Sales].[SalesOrderHeader]
    SET [TerritoryID] = 9
    WHERE  [SalesOrderID] = (SELECT MAX(SalesOrderID) FROM [Sales].[SalesOrderHeader])
    
    COMMIT TRANSACTION UpdateOrderTransaction;
    PRINT 'Order updated successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION UpdateOrderTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH

--Delete a salesperson
BEGIN TRANSACTION DeleteSalesPersonTransaction;
BEGIN TRY
    DECLARE @BusinessEntityIDToDelete INT;

    SET @BusinessEntityIDToDelete = (SELECT BusinessEntityID
	FROM [Person].[Person]
	WHERE [FirstName] = 'Inesa' AND [LastName] = 'Godorozea');
    DELETE FROM [Sales].[SalesPerson]
    WHERE [BusinessEntityID] = @BusinessEntityIDToDelete;

    UPDATE [HumanResources].[EmployeeDepartmentHistory]
    SET[HumanResources].[EmployeeDepartmentHistory].EndDate = GETDATE()
    WHERE [BusinessEntityID] = @BusinessEntityIDToDelete;

	UPDATE [HumanResources].[Employee]
    SET [CurrentFlag] = 0
    WHERE [BusinessEntityID] = @BusinessEntityIDToDelete;

    COMMIT TRANSACTION DeleteSalesPersonTransaction;
    PRINT 'Salesperson deleted successfully.';
END TRY
BEGIN CATCH
  
    ROLLBACK TRANSACTION DeleteSalesPersonTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH

--Add persons contact information (Email, Phone Number, Address)
BEGIN TRANSACTION AddContactInformationTransaction;
BEGIN TRY
   DECLARE @PersonID INT;
   SET @PersonID = (SELECT BusinessEntityID FROM [Person].[Person] WHERE FirstName = 'Inesa' AND LastName = 'Godorozea');

    INSERT INTO [Person].[EmailAddress]([BusinessEntityID], [EmailAddress])
    VALUES (@PersonID, 'InesaGodorozea@adventure-works.com');
    
    INSERT INTO [Person].[PersonPhone]([BusinessEntityID], [PhoneNumber], [PhoneNumberTypeID])
    VALUES (@PersonID,'79-927-987', 1);

	INSERT INTO [Person].[BusinessEntityAddress]([BusinessEntityID], [AddressID], [AddressTypeID])
	VALUES(@PersonID, 381, 3);

COMMIT TRANSACTION AddContactInformationTransaction;
    PRINT 'Contact information added successfully.';
END TRY
BEGIN CATCH
  
    ROLLBACK TRANSACTION AddContactInformationTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH
  
--Add new special offer 
BEGIN TRANSACTION AddNewOfferTransaction;
BEGIN TRY
  
    INSERT INTO [Sales].[SpecialOffer] ([Description], [DiscountPct], [Type], [Category], [StartDate], [EndDate])
    VALUES ('New Special Offer', 10, 'Promotion', 'Accessories', '2024-03-15', '2024-04-01');
    
    COMMIT TRANSACTION AddNewOfferTransaction;
    PRINT 'New special offer added successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION AddNewOfferTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;

--Remove special offers expired in 2024
BEGIN TRANSACTION RemoveExpiredOffersTransaction;
BEGIN TRY
    DELETE FROM [Sales].[SpecialOffer]
    WHERE YEAR(EndDate) = 2024;
    
    COMMIT TRANSACTION RemoveExpiredOffersTransaction;
    PRINT 'Expired special offers removed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION RemoveExpiredOffersTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;

--Add product review
BEGIN TRANSACTION AddProductReviewTransaction;
BEGIN TRY
   
    INSERT INTO [Production].[ProductReview]([ProductID], [ReviewerName], [ReviewDate], [EmailAddress], [Rating], [Comments])
    VALUES (350, 'Inesa Godorozea', GETDATE(), 'InesaGodorozea@adventure-works.com', 5, 'I am surprised, very good quality, will buy more.');

    COMMIT TRANSACTION AddProductReviewTransaction;
    PRINT 'New product review added successfully.';
END TRY
BEGIN CATCH
   
    ROLLBACK TRANSACTION AddProductReviewTransaction;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;