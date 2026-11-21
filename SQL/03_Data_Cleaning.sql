-- ======================================================================
-- Creating clean table where we will sort out the data quality issues and import the clean data

CREATE TABLE Customers_Clean
(
    CustomerID INT,
    CustomerName VARCHAR(100),
    Country VARCHAR(50),
    City VARCHAR(50),
    Email VARCHAR(100),
    CustomerType VARCHAR(50),
    RegistrationDate DATE,
    AccountStatus VARCHAR(30)
);
GO



CREATE TABLE SupportTickets_Clean
(
    TicketID VARCHAR(20),
    CustomerID INT,
    ProductName VARCHAR(100),
    IssueCategory VARCHAR(50),
    Priority VARCHAR(30),
    TicketStatus VARCHAR(30),
    CreatedDate DATE,
    ResolvedDate DATE,
    AssignedAgent VARCHAR(100),
    ResolutionHours DECIMAL(10,2),
    SatisfactionRating INT,
    Channel VARCHAR(30)
);
GO

-- ======================================================================
-- Cleaning the data and inseting it into the Customers_Clean table
INSERT INTO Customers_Clean 
(
    CustomerID,
    CustomerName,
    Country,
    City,
    Email,
    CustomerType,
    RegistrationDate,
    AccountStatus
)
SELECT 
    CustomerID,
    TRIM(CustomerName) AS CustomerName,
    TRIM(Country) AS Country,
    CASE WHEN CITY IS NULL THEN 'n/a'
        ELSE City
    END AS City,
    CASE WHEN Email IS NULL THEN 'n/a'
        ELSE Email
    END AS Email,
    CustomerType,
    TRY_CONVERT(DATE, RegistrationDate) RegistrationDate,
     CASE
        WHEN AccountStatus LIKE '%Inactive%' THEN 'Inactive'
        ELSE 'Active'
    END AS AccountStatus
FROM Customers_Raw

SELECT *
FROM Customers_Clean









-- ======================================================================
-- Cleaning the data and inseting it into the SupportTicket_Raw table
INSERT INTO SupportTickets_Clean 
(
    TicketID,
    CustomerID,
    ProductName,
    IssueCategory,
    Priority,
    TicketStatus,
    CreatedDate,
    ResolvedDate,
    AssignedAgent,
    ResolutionHours,
    SatisfactionRating
)
SELECT 
    TicketID,
    CustomerID,
    CASE WHEN TRIM(ProductName) IN ('Micro Station', 'MicroStation') THEN 'Micro Station'
		 ELSE TRIM(ProductName)
	END	AS ProductName,
    IssueCategory,
    Priority,
    TicketStatus,
    TRY_CONVERT(DATE, CreatedDate) AS CreatedDate,
    TRY_CONVERT(DATE, ResolvedDate) AS ResolvedDate,
    AssignedAgent,
    ABS(CAST(ResolutionHours AS DECIMAL (10,2))) AS ResolutionHours,
    CASE WHEN SatisfactionRating = 7 THEN 1 
	          ELSE SatisfactionRating
	END AS SatisfactionRating
FROM SupportTickets_Raw

SELECT *
FROM SupportTickets_Clean