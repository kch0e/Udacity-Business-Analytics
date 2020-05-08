WITH most_earned_artist
AS (SELECT
  ar.ArtistId,
  ar.Name AS artist_name,
  SUM(il.UnitPrice * il.Quantity) AS earned
FROM Artist ar
JOIN Album al
  ON ar.ArtistId = al.ArtistId
JOIN Track t
  ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il
  ON t.TrackId = il.TrackId
GROUP BY 1,
         2
ORDER BY 3 DESC
LIMIT 1)

SELECT
  ar.ArtistId,
  ar.Name AS artist_name,
  g.Name AS genre_type,
  SUM(il.UnitPrice * il.Quantity) AS earned
FROM Artist ar
JOIN Album al
  ON ar.ArtistId = al.ArtistId
JOIN Track t
  ON al.AlbumId = t.AlbumId
JOIN Genre g
  ON t.GenreId = g.GenreId
JOIN InvoiceLine il
  ON t.TrackId = il.TrackId
WHERE ar.Name = (SELECT
  artist_name
FROM most_earned_artist)
GROUP BY 1,
         2,
         3
ORDER BY 4 DESC;

/*
Output:
ArtistId		artist_name		genre_type		earned
90					Iron Maiden		Metal					69.3
90					Iron Maiden		Rock					53.46
90					Iron Maiden		Heavy Metal		11.88
90					Iron Maiden		Blues					 3.96
*/
