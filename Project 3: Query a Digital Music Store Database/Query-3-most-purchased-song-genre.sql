SELECT
  g.Name AS genre_type,
  COUNT(*) AS num_purchases
FROM Genre g
JOIN Track t
  ON g.GenreId = t.GenreId
JOIN InvoiceLine il
  ON t.TrackId = il.TrackId
GROUP BY 1
ORDER BY 2 DESC;
