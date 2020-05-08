tistId,
  ar.Name AS artist_name,
  t.Composer
FROM Artist ar
JOIN Album al
  ON ar.ArtistId = al.ArtistId
JOIN Track t
  ON al.AlbumId = t.AlbumId
ORDER BY 1),

composer_employed
AS (SELECT
  ArtistId,
  artist_name,
  Composer,
  CASE
		WHEN artist_name = Composer
		THEN "self composer"
    WHEN Composer  LIKE (artist_name || "%")
		THEN "self composer"
    WHEN Composer  LIKE ("%" || artist_name)
		THEN "self composer"
    WHEN Composer  LIKE ("&" || artist_name || "%")
		THEN "self composer"
		WHEN artist_name LIKE (Composer || "%")
		THEN "self composer"
    WHEN artist_name LIKE ("%" || Composer)
		THEN "self composer"
    WHEN artist_name LIKE ("&" || Composer || "%")
		THEN "self composer"
		WHEN Composer IS NULL
		THEN "no composer"
    ELSE "outside composer"
	END AS composer_type
FROM composer_list
ORDER BY 4 DESC, 2),

composer_segmentation
AS (SELECT
  CASE
    WHEN composer_type = "self composer"
    THEN 1
    ELSE 0
  END AS self_composer,
  CASE
    WHEN composer_type = "outside composer"
    THEN 1
    ELSE 0
  END AS outside_composer,
  CASE
    WHEN composer_type = "no composer"
    THEN 1
    ELSE 0
  END AS no_composer
FROM composer_employed)

SELECT (SELECT
         COUNT(*)
       FROM composer_list)
       AS total_songs,
       SUM(self_composer) AS self_composed,
       SUM(outside_composer) AS outside_composed,
       SUM(no_composer) AS none_composed
FROM composer_segmentation;

/*
Output:
total_songs		self_composed		outside_composed		none_composed
3503					524							2001								978
*/
