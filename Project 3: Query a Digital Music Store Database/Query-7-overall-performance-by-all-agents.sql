SELECT
  e.FirstName || " " || e.LastName AS sales_agent,
  STRFTIME('%Y', i.InvoiceDate) AS year,
  COUNT(*) AS sales
FROM Employee e
JOIN Customer c
  ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
WHERE e.Title = "Sales Support Agent"
GROUP BY 1,
         2
ORDER BY 1,
				 2;
