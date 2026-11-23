
-- What is the overall ticket resolution rate?
USE BentleySupportAnalysis
GO

SELECT
    COUNT(*) AS TotalTickets,
    SUM(CASE WHEN TRIM(TicketStatus) = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedTickets,
    CAST(
        SUM(CASE WHEN TRIM(TicketStatus) = 'Resolved' THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*) AS DECIMAL(10,2)
    ) AS ResolutionRatePercentage
FROM SupportTickets_Clean





-- How many tickets are pending, cancelled, or otherwise unresolved?

SELECT 
    TicketStatus,
    COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
WHERE TicketStatus <> 'Resolved'
GROUP BY TicketStatus
ORDER BY TotalTickets DESC





-- Which priority level has the highest number of unresolved tickets?

SELECT 
    Priority,
    COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
WHERE TicketStatus <> 'Resolved'
GROUP BY Priority
ORDER BY TotalTickets DESC






-- What is the monthly ticket volume, and how is it changing over time?

SELECT
    DATENAME (MONTH,CreatedDate) AS TicketMonth,
    COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
WHERE CreatedDate IS NOT NULL
GROUP BY  DATENAME (MONTH,CreatedDate)
ORDER BY TicketMonth 





-- What is the average resolution time for resolved tickets by priority?

SELECT 
    Priority,
    COUNT(*) ResolvedTickets,
    AVG(ResolutionHours) AS AverageResolvedTicket
FROM SupportTickets_Clean
WHERE TicketStatus = 'Resolved'
GROUP BY Priority
ORDER BY AverageResolvedTicket DESC





-- Which products generate the highest number of support tickets?

SELECT 
    ProductName,
    COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
GROUP BY ProductName
ORDER BY TotalTickets DESC






-- What are the most common issues for each product?
WITH IssueRanking AS (
SELECT 
    ProductName,
    IssueCategory,
    COUNT(*) AS TotalTickets,
    ROW_NUMBER() OVER (PARTITION BY ProductName ORDER BY   COUNT(*) DESC) AS Ranking
FROM SupportTickets_Clean
GROUP BY ProductName, IssueCategory
)
SELECT 
    ProductName,
    IssueCategory,
    TotalTickets
FROM IssueRanking
WHERE Ranking = 1
ORDER BY ProductName







-- Which issue categories have the longest average resolution times?

SELECT 
    IssueCategory,
    COUNT(*) AS ResolvedTicketAvgTime,
    AVG(ResolutionHours) AS AvgResolutionTime
FROM SupportTickets_Clean
WHERE TicketStatus = 'Resolved' 
GROUP BY IssueCategory
ORDER BY AvgResolutionTime DESC







-- Which products have the lowest customer satisfaction ratings?

SELECT 
    ProductName,
    COUNT(SatisfactionRating) AS SatisfactionRating,
    AVG(SatisfactionRating) AS AverageRating
FROM SupportTickets_Clean
GROUP BY ProductName
ORDER BY AverageRating








-- Which customers have submitted the most support tickets?

SELECT 
    cc.CustomerID,
    cc.CustomerName,
    COUNT(sc.TicketID) AS TotalSupportTickets
FROM Customers_Clean cc
LEFT JOIN SupportTickets_Clean sc
    ON sc.CustomerID = cc.CustomerID
GROUP BY cc.CustomerID, cc.CustomerName
ORDER BY TotalSupportTickets DESC





-- What is the ticket volume by customer type?


SELECT 
    cc.CustomerType,
    COUNT(sc.TicketID) AS TotalTickets,
    COUNT(DISTINCT cc.CustomerID) AS TotalCustomers
FROM Customers_Clean cc
LEFT JOIN SupportTickets_Clean sc
    ON sc.CustomerID = cc.CustomerID
GROUP BY cc.CustomerType
ORDER BY TotalTickets DESC





-- Which customers have multiple unresolved tickets?

SELECT 
    cc.CustomerName,
    cc.CustomerID,
    COUNT(sc.TicketID) AS TotalUnresovledTickets
FROM Customers_Clean cc
LEFT JOIN SupportTickets_Clean sc
    ON sc.CustomerID = cc.CustomerID
WHERE sc.TicketStatus != 'Resolved'
GROUP BY cc.CustomerName, cc.CustomerID
ORDER BY TotalUnresovledTickets DESC






-- Which support agents handle the highest number of tickets?

SELECT 
    AssignedAgent,
    COUNT(*) AS TotalTicketsByAgent
FROM SupportTickets_Clean
GROUP BY AssignedAgent
ORDER BY TotalTicketsByAgent DESC





-- What is the average resolution time for each support agent?

SELECT
    AssignedAgent,
    COUNT(*) AS ResolvedTickets,
    ROUND(AVG(ResolutionHours), 2) AS AverageResolutionHours
FROM SupportTickets_Clean
WHERE TRIM(TicketStatus) = 'Resolved'
  AND ResolutionHours IS NOT NULL
  AND AssignedAgent IS NOT NULL
GROUP BY AssignedAgent
ORDER BY AverageResolutionHours ASC







-- Which agents have the highest number of unresolved tickets?

SELECT
    AssignedAgent,
    COUNT(*) AS UnresolvedTickets
FROM SupportTickets_Clean
WHERE TRIM(TicketStatus) <> 'Resolved'
  AND AssignedAgent IS NOT NULL
GROUP BY AssignedAgent
ORDER BY UnresolvedTickets DESC






-- Which communication channel receives the highest number of tickets?

SELECT
    Channel,
    COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
WHERE Channel IS NOT NULL
GROUP BY Channel
ORDER BY TotalTickets DESC






-- Is there a relationship between resolution time and customer satisfaction?

SELECT
    CASE
        WHEN ResolutionHours <= 4 THEN '0-4 Hours'
        WHEN ResolutionHours <= 8 THEN '5-8 Hours'
        WHEN ResolutionHours <= 24 THEN '9-24 Hours'
        ELSE 'Over 24 Hours'
    END AS ResolutionTimeGroup,

    COUNT(*) AS TotalTickets,

    ROUND(AVG(CAST(SatisfactionRating AS DECIMAL(10,2))), 2) AS AverageRating

FROM SupportTickets_Clean

WHERE ResolutionHours IS NOT NULL
  AND SatisfactionRating IS NOT NULL

GROUP BY
    CASE
        WHEN ResolutionHours <= 4 THEN '0-4 Hours'
        WHEN ResolutionHours <= 8 THEN '5-8 Hours'
        WHEN ResolutionHours <= 24 THEN '9-24 Hours'
        ELSE 'Over 24 Hours'
    END

ORDER BY AverageRating DESC
