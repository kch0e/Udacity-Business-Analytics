WITH customer_type
AS (SELECT
  CASE
    WHEN Company IS NULL
    THEN 1
    ELSE 0
  END AS domestic_customer,
  CASE
    WHEN Company IS NULL
    THEN 0
    ELSE 1
  END AS business_customer
FROM Customer)

SELECT
  SUM(domestic_customer) AS domestic_customers,
  SUM(business_customer) AS business_customers
FROM customer_type;

/*
Output:
domestic_customers      business_customers
49	                    10
*/
