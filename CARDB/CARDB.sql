--write the query that brings the information about how many vehicles from each brand according to the vehicle brands as shown in the figure.

SELECT BRAND,COUNT(*) AS COUNT_ FROM WEBOFFERS W

GROUP BY BRAND
ORDER BY 2 DESC

--Write the query that brings the information about how many vehicles from each brand according to the vehicle brands and how much of the total corresponds to the percentage as shown in the figure.

SELECT BRAND,COUNT(*) AS COUNT_ , 
ROUND(COUNT(*)/30229.01*100,2)
FROM WEBOFFERS W
GROUP BY BRAND
ORDER BY 2 DESC

--write the query that brings the information about how many vehicle advertisements in which city as shown in the figure.

--Method 1
SELECT C.CITY,COUNT(*) AS COUNT_ FROM WEBOFFERS W 
INNER JOIN CITY C ON C.ID=W.CITYID
GROUP BY C.CITY
ORDER BY 2 DESC
--Method 2 Subquery
SELECT CITY,
(SELECT COUNT(*) FROM WEBOFFERS WHERE CITYID=C.ID) AS COUNT_
FROM CITY C
ORDER BY 2 DESC

--we are looking for a volkswagen passat vehicle in istanbul. our criteria are as follows. --from: from the owner. --model:between 2014-2018 --gear:automatic --fuel:diesel --sorting:by kilometre and price

SELECT C.CITY,T.TOWN,D.DISTRICT,W.TITLE,W.BRAND,
W.MODEL,W.KM,W.PRICE,W.SHIFTTYPE,W.FUEL,W.COLOR,W.YEAR_
FROM WEBOFFERS W
INNER JOIN CITY C ON C.ID=W.CITYID
INNER JOIN TOWN T ON T.ID=W.TOWNID
INNER JOIN DISTRICT D ON D.ID=W.DISTRICTID
WHERE C.CITY ='İSTANBUL' 
AND W.BRAND ='VOLKSWAGEN' 
AND W.MODEL='PASSAT' 
AND W.SHIFTTYPE IN ('OTOMATİK VİTES' , 'YARI OTOMATİK VİTES')
AND W.FUEL='DİZEL'
AND W.FROMWHO='SAHİBİNDEN' 
AND W.YEAR_ BETWEEN 2014 AND 2018

GROUP BY C.CITY,T.TOWN,D.DISTRICT,W.TITLE,W.BRAND,
W.MODEL,W.KM,W.PRICE,W.SHIFTTYPE,W.FUEL,W.COLOR,W.YEAR_
ORDER BY 7 ,8

--write the query that lists bmw brand vehicles in ankara, istanbul and izmir. here the city names sent to the query will be sent not one by one, but by combining them with commas.'ankara,istanbul,izmir'


SELECT U.NAMESURNAME,C.CITY,T.TOWN,D.DISTRICT,W.TITLE FROM WEBOFFERS W

INNER JOIN CITY C ON C.ID=W.CITYID
INNER JOIN USER_ U ON U.ID=W.USERID
INNER JOIN TOWN T ON T.ID=W.TOWNID
INNER JOIN DISTRICT D ON D.ID=W.DISTRICTID
WHERE W.BRAND='BMW'
AND C.CITY IN (SELECT * FROM string_split ('ANKARA,İSTANBUL,İZMİR',','))


GROUP BY U.NAMESURNAME,C.CITY,T.TOWN,D.DISTRICT,W.TITLE

