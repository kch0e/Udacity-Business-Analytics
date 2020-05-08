WITH best_sales_agent
AS (SELECT
  e.FirstName,
  e.LastName,
  CASE
    WHEN COUNT(*) IS NULL
    THEN "0"
    ELSE COUNT(*)
  END AS assists
FROM Employee e
JOIN Customer c
  ON e.EmployeeId = c.SupportRepId
WHERE e.Title = "Sales Support Agent"
GROUP BY 1,
         2
ORDER BY 3 DESC
LIMIT 1)

SELECT
  e.FirstName,
  e.LastName,
  STRFTIME('%Y', i.InvoiceDate) AS year,
  COUNT(*) AS sales
FROM Employee e
JOIN Customer c
  ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
JOIN best_sales_agent bsa
  ON e.FirstName = bsa.FirstName
  AND e.LastName = bsa.LastName
GROUP BY 1,
         2,
         3
ORDER BY 3,
         1,
         2;
