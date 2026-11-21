
USE BentleySupportAnalysis
GO


-- Checking for duplicates in ID column

SELECT 
	CustomerID,
	COUNT(*) AS Total_Customers
FROM Customers_Raw
GROUP BY CustomerID
HAVING COUNT(*) > 1


-- Checking for NULL, '' and extra spaces in CustomerName column
SELECT 
	LEN(CustomerName) AS Customer_Name_Len,
	LEN(TRIM(CustomerName)) AS Len_After_Trimming,
	LEN(CustomerName) - LEN(TRIM(CustomerName)) AS Len_Difference
FROM Customers_Raw


SELECT *
FROM Customers_Raw
WHERE CustomerName != TRIM(CustomerName)



-- Checking for NULL, '' and extra spaces in Country column
SELECT 
	LEN(Country) AS Country_Len,
	LEN(TRIM(Country)) AS Len_After_Trimming,
	LEN(Country) - LEN(TRIM(Country)) AS Len_Difference
FROM Customers_Raw


SELECT *
FROM Customers_Raw
WHERE Country != TRIM(Country)




-- Checking for NULL, '' and extra spaces in City column
SELECT 
	LEN(City) AS City_Len,
	LEN(TRIM(Country)) AS Len_After_Trimming,
	LEN(City) - LEN(TRIM(City)) AS Len_Difference
FROM Customers_Raw

SELECT *
FROM Customers_Raw
WHERE City IS NULL

SELECT *
FROM Customers_Raw
WHERE City != TRIM(City)






-- Checking for NULL, '' and extra spaces in Email column
SELECT 
	LEN(Email) AS Email_Len,
	LEN(TRIM(Email)) AS Len_After_Trimming,
	LEN(Email) - LEN(TRIM(Email)) AS Len_Difference
FROM Customers_Raw

SELECT *
FROM Customers_Raw
WHERE Email IS NULL

SELECT *
FROM Customers_Raw
WHERE Email != TRIM(Email)





-- Checking for NULL, '' and extra spaces in CustomerType column

SELECT *
FROM Customers_Raw
WHERE CustomerType IS NULL 


SELECT *
FROM Customers_Raw
WHERE CustomerType != TRIM(CustomerType)


SELECT DISTINCT CustomerType
FROM Customers_Raw






-- Checking the date column
SELECT *
FROM Customers_Raw
WHERE RegistrationDate IS NULL

SELECT 
	RegistrationDate,
	COUNT(*)
FROM Customers_Raw
GROUP BY RegistrationDate

SELECT 
   TRY_CONVERT(DATE, RegistrationDate)
FROM Customers_Raw
WHERE TRY_CONVERT(DATE, RegistrationDate) IS NULL


SELECT *
FROM Customers_Raw
WHERE TRIM(RegistrationDate) = ''



-- Checking the AccountStatus column

SELECT 
	AccountStatus,
	COUNT(*)
FROM Customers_Raw
GROUP BY AccountStatus

SELECT 
	DISTINCT AccountStatus
FROM Customers_Raw



SELECT *
FROM Customers_Raw
WHERE AccountStatus IS NULL OR AccountStatus = ''



SELECT *
FROM Customers_Raw
WHERE AccountStatus != LTRIM(RTRIM(AccountStatus))


SELECT 
	LEN(AccountStatus),
	LEN(TRIM(AccountStatus)),
	LEN(AccountStatus) - LEN(TRIM(AccountStatus))
FROM Customers_Raw

SELECT DISTINCT
    CASE
        WHEN AccountStatus LIKE '%Inactive%' THEN 'Inactive'
        ELSE 'Active'
    END AS AccountStatus
FROM Customers_Raw







-- ==============================================================
-- Checking Data Quality issues in SupportTickets_Raw table

-- Checking the TicketID column

SELECT 
	TicketID,
	COUNT(*) AS TotalTickets
FROM SupportTickets_Raw
GROUP BY TicketID
HAVING COUNT(*) > 1 OR TicketID IS NULL


SELECT 
	LEN(TicketID),
	LEN(TRIM(TicketID)),
	LEN(TicketID) - LEN(TRIM(TicketID))
FROM SupportTickets_Raw


SELECT *
FROM SupportTickets_Raw
WHERE TicketID != TRIM(TicketID)




-- Checking the CustomerID Column

SELECT 
	CustomerID,
	COUNT(*) AS TotalCustomers
FROM SupportTickets_Raw
GROUP BY CustomerID
HAVING COUNT(*) > 1


SELECT *
FROM SupportTickets_Raw
WHERE CustomerID NOT IN 
(
	SELECT CustomerID
	FROM Customers_Raw
)






-- Checking the ProductName Column

SELECT 
	LEN(ProductName),
	LEN(TRIM(ProductName)),
	LEN(ProductName) - LEN(TRIM(ProductName))
FROM SupportTickets_Raw








-- Checking the IssueCategory Column
SELECT 
	LEN(IssueCategory),
	LEN(TRIM(IssueCategory)),
	LEN(IssueCategory) - LEN(TRIM(IssueCategory))
FROM SupportTickets_Raw

SELECT *
FROM SupportTickets_Raw
WHERE IssueCategory != TRIM(IssueCategory)

SELECT *
FROM SupportTickets_Raw
WHERE IssueCategory IS NULL






-- Checking the IssueCategory Column
SELECT 
	DISTINCT Priority
FROM SupportTickets_Raw

SELECT *
FROM SupportTickets_Raw
WHERE Priority != TRIM(Priority)

SELECT *
FROM SupportTickets_Raw
WHERE Priority IS NULL





-- Checking the TicketStatus Column
SELECT 
	DISTINCT TicketStatus
FROM SupportTickets_Raw

SELECT 
	 TicketStatus
FROM SupportTickets_Raw
GROUP BY TicketStatus


SELECT *
FROM SupportTickets_Raw
WHERE TicketStatus != TRIM(TicketStatus) OR TicketStatus = ''

SELECT 
DISTINCT TicketStatus
FROM SupportTickets_Raw





-- Checking the CreatedDate Column

SELECT 
	CreatedDate
FROM SupportTickets_Raw

SELECT *
FROM SupportTickets_Raw
WHERE TRY_CONVERT(DATE, CreatedDate) IS NULL

SELECT
    CreatedDate,
    TRY_CONVERT(DATE, CreatedDate) AS CleanCreatedDate
FROM SupportTickets_Raw






-- Checking the ResolvedDate Column
SELECT
    ResolvedDate,
    TRY_CONVERT(DATE, ResolvedDate) AS CleanCreatedDate
FROM SupportTickets_Raw

SELECT *
FROM SupportTickets_Raw
WHERE TRY_CONVERT(DATE, ResolvedDate) < TRY_CONVERT(DATE, CreatedDate)



-- Checking the ResolvedDate Column

SELECT 
	AssignedAgent
FROM SupportTickets_Raw
WHERE AssignedAgent IS NULL OR AssignedAgent = ''


SELECT 
	LEN(AssignedAgent),
	LEN(TRIM(AssignedAgent)),
	LEN(AssignedAgent) - LEN(TRIM(AssignedAgent))
FROM SupportTickets_Raw





-- Checking the ResolvedDate Column

SELECT *
FROM SupportTickets_Raw
WHERE NULLIF(LTRIM(RTRIM(ResolutionHours)), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(10,2), ResolutionHours) IS NULL


SELECT *
FROM SupportTickets_Raw
WHERE ResolutionHours < 0 OR ResolutionHours = 0

SELECT 
	CustomerID,
	ResolutionHours,
	ABS(CAST(ResolutionHours AS DECIMAL (10,2))) AS Clean
FROM SupportTickets_Raw




-- Checking the ResolvedDate Column

SELECT 
	SatisfactionRating
FROM SupportTickets_Raw
WHERE SatisfactionRating IS NULL


SELECT
	SatisfactionRating
FROM SupportTickets_Raw
GROUP BY SatisfactionRating
ORDER BY SatisfactionRating


SELECT *
FROM SupportTickets_Raw
WHERE TRY_CONVERT(INT, SatisfactionRating) NOT BETWEEN 1 AND 5
  AND SatisfactionRating IS NOT NULL


SELECT 
	SatisfactionRating,
	CASE WHEN SatisfactionRating = 7 THEN 1 
	ELSE SatisfactionRating
	END
FROM SupportTickets_Raw