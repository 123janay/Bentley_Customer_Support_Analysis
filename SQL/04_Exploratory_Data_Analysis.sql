
USE BentleySupportAnalysis
GO

-- Total customers
SELECT
	COUNT(*) AS Total_Customers
FROM Customers_Clean



-- Total support tickets
SELECT
	COUNT(*) AS Total_Tickets
FROM SupportTickets_Clean



-- Total unique customers who submitted tickets
SELECT 
	COUNT(DISTINCT CustomerID) AS UniqueCustomersWithTickets
FROM SupportTickets_Clean



-- -- Tickets by status
SELECT 
	TicketStatus,
	COUNT(TicketStatus) AS TicketsByStatus
FROM SupportTickets_Clean 
GROUP BY TicketStatus
ORDER BY TicketStatus DESC




--  Tickets by status
SELECT 
	Priority,
	COUNT(Priority) AS TicketsByStatus
FROM SupportTickets_Clean 
GROUP BY Priority
ORDER BY Priority DESC




--  Tickets by Channel
SELECT 
	Channel,
	COUNT(*) AS TicketsByStatus
FROM SupportTickets_Clean 
GROUP BY Channel
ORDER BY Channel DESC



-- Tickets by IssueCategory
SELECT 
	IssueCategory,
	COUNT(*) AS TicketsByStatus
FROM SupportTickets_Clean 
GROUP BY IssueCategory
ORDER BY IssueCategory DESC





-- Tickets by Product
SELECT 
	ProductName,
	COUNT(*) AS TicketByProduct
FROM SupportTickets_Clean
GROUP BY ProductName
ORDER BY TicketByProduct DESC



-- Tickets by Assigned Agent
SELECT 
	AssignedAgent,
	COUNT(*) AS TotalTicketsByAgents
FROM SupportTickets_Raw
GROUP BY AssignedAgent
ORDER BY TotalTicketsByAgents DESC

 

-- Satisfaction Rating Distribution
SELECT 
	SatisfactionRating,
	COUNT(*) AS RatingDistribution
FROM SupportTickets_Clean
GROUP BY SatisfactionRating
ORDER BY RatingDistribution DESC




-- Resolution Hours Overview
SELECT 
	MIN(ResolutionHours) AS MinimumHour,
	MAX(ResolutionHours) AS MaximumHour,
	AVG(ResolutionHours) AS AvgHour
FROM SupportTickets_Clean



-- Tickets created by month
SELECT 
	YEAR(CreatedDate) AS TicketsByYear,
	DATENAME(MONTH, CreatedDate) AS TicketsByMonth,
	COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
WHERE CreatedDate IS NOT NULL
GROUP BY YEAR(CreatedDate), DATENAME(MONTH, CreatedDate)
ORDER BY TicketsByYear, TicketsByMonth



-- Tickets per customer
SELECT 
	CustomerID,
	COUNT(*) AS TicketsByCustomer
FROM SupportTickets_Clean
GROUP BY CustomerID
ORDER BY TicketsByCustomer DESC



-- Ticket count by customer type
SELECT 
	cc.CustomerType,
	COUNT(*) AS TicketsByCustomerType
FROM Customers_Clean cc
LEFT JOIN SupportTickets_Clean sc
	ON sc.CustomerID = cc.CustomerID
GROUP BY cc.CustomerType
ORDER BY TicketsByCustomerType DESC




-- Find which types of issues are reported for each product.
SELECT 
	ProductName,
	IssueCategory,
	COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
GROUP BY ProductName, IssueCategory
ORDER BY ProductName, TotalTickets DESC



-- Explore how ticket statuses are distributed across different priority levels
SELECT 
	TicketStatus,
	Priority,
	COUNT(*) AS TotalTickets
FROM SupportTickets_Clean
GROUP BY TicketStatus, Priority
ORDER BY TicketStatus, TotalTickets DESC
	






-- Satisfaction by communication channel
SELECT 
	Channel,
	AVG(SatisfactionRating) AS AverageRating,
	COUNT(SatisfactionRating) AS RatedTickets
FROM SupportTickets_Clean
GROUP BY Channel
ORDER BY RatedTickets DESC




-- Missing data overview in the clean table
SELECT 
	COUNT(*) AS TotalTickets,
	COUNT(CreatedDate) AS TotalTicketsWithCreatedDate,
	COUNT(ResolvedDate) AS TotalTicketsWithResolveddDate,
	COUNT(ResolutionHours) AS TotalTicketsWithResolutionHours,
	COUNT(SatisfactionRating) AS TotalTicketsWithSatisfactionRating
FROM SupportTickets_Clean




-- Short Summary Report on EDA
SELECT 'Total Customers' AS Analysis, COUNT(*) AS Results
FROM SupportTickets_Clean
UNION ALL
SELECT 'Total Customers',COUNT(*) FROM Customers_Clean
UNION ALL
SELECT 'Total Tickets', COUNT(*) FROM SupportTickets_Clean
UNION ALL
SELECT 'Unique Customers With Tickets', COUNT(DISTINCT CustomerID) FROM SupportTickets_Clean
UNION ALL
SELECT 'Resolved Tickets', COUNT(*) FROM SupportTickets_Clean WHERE TicketStatus = 'Resolved'
UNION ALL
SELECT 'Unresolved Tickets', COUNT(*) FROM SupportTickets_Clean WHERE TicketStatus <> 'Resolved'
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT ProductName) FROM SupportTickets_Clean 
UNION ALL
SELECT 'Total Issue Categories', COUNT(DISTINCT IssueCategory) FROM SupportTickets_Clean 
UNION ALL
SELECT 'Total Support Agents', COUNT(DISTINCT AssignedAgent) FROM SupportTickets_Clean 
UNION ALL
SELECT 'Rated Tickets', COUNT(SatisfactionRating) FROM SupportTickets_Clean 
UNION ALL
SELECT 'Missing Satisfaction Ratings', COUNT(*) FROM SupportTickets_Clean WHERE SatisfactionRating IS NULL
