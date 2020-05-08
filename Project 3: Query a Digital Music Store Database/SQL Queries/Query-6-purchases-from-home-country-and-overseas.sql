WITH purchase_location
AS (SELECT
  i.InvoiceId,
  i.BillingCountry,
  CASE
    WHEN i.BillingCountry = e.Country
    THEN "home country"
    ELSE "over seas"
  END AS sold_in
FROM Employee e
JOIN Customer c
  ON e.EmployeeId = c.SupportRepId
JOIN Invoice i
  ON c.CustomerId = i.CustomerId),

purchase_location_segmentation
AS (SELECT
  CASE
    WHEN sold_in = "home country"
    THEN 1
    ELSE 0
  END AS home_country_purchase,
  CASE
    WHEN sold_in = "over seas"
    THEN 1
    ELSE 0
  END AS over_seas_purchase
FROM purchase_location)

SELECT (SELECT
         COUNT(*)
        FROM purchase_location)AS total_purchases,
       SUM(home_country_purchase) AS home_country_purchases,
       SUM(over_seas_purchase) AS over_seas_purchases
FROM purchase_location_segmentation;

/*
Output:
total_purchases		home_country_purchases		over_seas_purchases
412								56												356
*/
