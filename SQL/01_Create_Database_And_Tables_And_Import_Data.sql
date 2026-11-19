-- ========================================

-- Creating Bentley Database
IF DB_ID('BentleySupportAnalysis') IS NULL
BEGIN
    CREATE DATABASE BentleySupportAnalysis;
END;
GO





-- ========================================

-- Creating Customers_Raw Table

CREATE TABLE Customers_Raw
(
    CustomerID INT,
    CustomerName VARCHAR(100),
    Country VARCHAR(50),
    City VARCHAR(50),
    Email VARCHAR(100),
    CustomerType VARCHAR(50),
    RegistrationDate VARCHAR(30),
    AccountStatus VARCHAR(30)
);








-- ===========================================

-- Creating SupportTickets_Raw Table
CREATE TABLE SupportTickets_Raw
(
    TicketID VARCHAR(20),
    CustomerID INT,
    ProductName VARCHAR(100),
    IssueCategory VARCHAR(50),
    Priority VARCHAR(30),
    TicketStatus VARCHAR(30),
    CreatedDate VARCHAR(30),
    ResolvedDate VARCHAR(30),
    AssignedAgent VARCHAR(100),
    ResolutionHours VARCHAR(30),
    SatisfactionRating VARCHAR(30),
    Channel VARCHAR(30)
);








-- =============================================

-- Best practice to use truncate in case of daily refresh
TRUNCATE TABLE Customers_Raw;
GO 

-- Inserting Data into the tables  

BULK INSERT SupportTickets_Raw
FROM 'D:\Data Analysis\Data_Warehouse_Projects\Bentley_Customer_Support_Analysis\Dataset\SupportTickets_Raw.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    KEEPNULLS
);
GO

SELECT COUNT(*)
FROM SupportTickets_Raw



BULK INSERT Customers_Raw
FROM 'D:\Data Analysis\Data_Warehouse_Projects\Bentley_Customer_Support_Analysis\Dataset\Customers_Raw.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    KEEPNULLS
);
GO



