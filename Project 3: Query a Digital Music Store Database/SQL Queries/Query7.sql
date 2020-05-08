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

/*
Output:
sales_agent			year		sales
Jane Peacock		2009		25
Jane Peacock		2010		34
Jane Peacock		2011		28
Jane Peacock		2012		28
Jane Peacock		2013		31
Margaret Park		2009		30
Margaret Park		2010		27
Margaret Park		2011		28
Margaret Park		2012		29
Margaret Park		2013		26
Steve Johnson		2009		28
Steve Johnson		2010		22
Steve Johnson		2011		27
Steve Johnson		2012		26
Steve Johnson		2013		23
*/
