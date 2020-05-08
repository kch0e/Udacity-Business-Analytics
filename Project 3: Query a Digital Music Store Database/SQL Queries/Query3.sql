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

/*
Output:
genre_type             num_purchases
Rock	                 835
Latin	                 386
Metal	                 264
Alternative & Punk	   244
Jazz	                  80
Blues	                  61
TV Shows	              47
Classical	              41
R&B/Soul	              41
Reggae	                30
Drama	                  29
Pop	                    28
Sci Fi & Fantasy	      20
Soundtrack	            20
Hip Hop/Rap	            17
Bossa Nova	            15
Alternative	            14
World	                  13
Electronica/Dance	      12
Heavy Metal	            12
Easy Listening	        10
Comedy	                 9
Rock And Roll	           6
Science Fiction	         6
*/
