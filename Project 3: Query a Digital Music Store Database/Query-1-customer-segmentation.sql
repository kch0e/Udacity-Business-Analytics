WITH all_recent_customers
AS (SELECT
  c.CustomerId,
  c.FirstName,
  c.LastName,
  STRFTIME('%Y-%m', i.InvoiceDate) AS ord_date,
  COUNT(*) AS purchases
FROM Customer c
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
GROUP BY 1,
         2,
         3,
         4
HAVING STRFTIME('%Y-%m', i.InvoiceDate) > "2013-06"
ORDER BY 4,
         1),

t1
AS (SELECT
  c.CustomerId,
  c.FirstName,
  c.LastName,
  STRFTIME('%Y-%m', i.InvoiceDate) AS ord_date,
  COUNT(*) AS purchases
FROM Customer c
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
GROUP BY 1,
         2,
         3,
         4
HAVING STRFTIME('%Y-%m', i.InvoiceDate) > "2012-12"
ORDER BY 4,
         1),

all_standard_customers
AS (SELECT
  c.CustomerId,
  c.FirstName,
  c.LastName,
  STRFTIME('%Y-%m', i.InvoiceDate) AS ord_date,
  COUNT(*) AS purchases
FROM Customer c
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
GROUP BY 1,
         2,
         3,
         4
HAVING STRFTIME('%Y-%m', i.InvoiceDate) BETWEEN "2011-01" AND "2012-12"
ORDER BY 4,
         1),

t2
AS (SELECT
  c.CustomerId,
  c.FirstName,
  c.LastName,
  STRFTIME('%Y-%m', i.InvoiceDate) AS ord_date,
  COUNT(*) AS purchases
FROM Customer c
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
GROUP BY 1,
         2,
         3,
         4
HAVING STRFTIME('%Y-%m', i.InvoiceDate) > "2010-12"
ORDER BY 4,
         1),

all_losing_customers
AS (SELECT
  c.CustomerId,
  c.FirstName,
  c.LastName,
  STRFTIME('%Y-%m', i.InvoiceDate) AS ord_date,
  COUNT(*) AS purchases
FROM Customer c
JOIN Invoice i
  ON c.CustomerId = i.CustomerId
GROUP BY 1,
         2,
         3,
         4
HAVING STRFTIME('%Y-%m', i.InvoiceDate) < "2011-01"
ORDER BY 4,
         1),

recent_customers
AS (SELECT DISTINCT
  arc.CustomerId,
  arc.FirstName,
  arc.LastName
FROM all_recent_customers arc
ORDER BY 1,
         2,
         3),

potential_customers
AS (SELECT DISTINCT
  t1.CustomerId,
  t1.FirstName,
  t1.LastName
FROM t1
LEFT JOIN all_recent_customers arc
  ON t1.CustomerId = arc.CustomerId
  AND t1.FirstName = arc.FirstName
  AND t1.LastName = arc.LastName
WHERE arc.CustomerId IS NULL
ORDER BY 1,
         2,
         3),

standard_customers
AS (SELECT DISTINCT
  alsc.CustomerId,
  alsc.FirstName,
  alsc.LastName
FROM all_standard_customers alsc
LEFT JOIN t1
  ON alsc.CustomerId = t1.CustomerId
  AND alsc.FirstName = t1.FirstName
  AND alsc.LastName = t1.LastName
WHERE t1.CustomerId IS NULL
ORDER BY 1,
         2,
         3),

losing_customers
AS (SELECT
  alc.CustomerId,
  alc.FirstName,
  alc.LastName
FROM all_losing_customers alc
LEFT JOIN t2
  ON alc.CustomerId = t2.CustomerId
  AND alc.FirstName = t2.FirstName
  AND alc.LastName = t2.LastName
WHERE t2.CustomerId IS NULL
ORDER BY 1,
         2,
         3),

all_customers_list
AS (SELECT
  c.CustomerId,
  c.FirstName,
  c.LastName,
  CASE
    WHEN c.CustomerId IN (SELECT
                            CustomerId
                          FROM recent_customers)
    THEN "recent customer"
    WHEN c.CustomerId IN (SELECT
                            CustomerId
                          FROM potential_customers)
    THEN "potential customer"
    WHEN c.CustomerId IN (SELECT
                            CustomerId
                          FROM standard_customers)
    THEN "standard customer"
    WHEN c.CustomerId IN (SELECT
                            CustomerId
                          FROM losing_customers)
    THEN "losing customer"
    ELSE "unknown customer"
  END AS customer_type
FROM Customer c
ORDER BY 1,
         2,
         3),

customer_segmentation
AS (SELECT
  CASE
    WHEN customer_type = "recent customer"
    THEN 1
    ELSE 0
  END AS recent_customer,
  CASE
    WHEN customer_type = "potential customer"
    THEN 1
    ELSE 0
  END AS potential_customer,
  CASE
    WHEN customer_type = "standard customer"
    THEN 1
    ELSE 0
  END AS standard_customer,
  CASE
    WHEN customer_type = "losing customer"
    THEN 1
    ELSE 0
  END AS losing_customer,
  CASE
    WHEN customer_type = "unknown customer"
    THEN 1
    ELSE 0
  END AS unknown_customer
FROM all_customers_list)

SELECT
  SUM(cg.recent_customer) AS recent_customers,
  SUM(cg.potential_customer) AS potential_customers,
  SUM(cg.standard_customer) AS standard_customers,
  SUM(cg.losing_customer) AS losing_customers,
  SUM(cg.unknown_customer) AS unknown_customers,
  (SELECT
    COUNT(*) AS all_customers
  FROM Customer c)
  AS total_customers
FROM customer_segmentation cg;
