--What is the query that brings the list of employees who are still working in our company? note: employees with empty date of dismissal are employees who continue to work

SELECT * FROM PERSON
WHERE OUTDATE IS NULL

--Write the query that brings the number of women and men who are still working in our company based on department.

SELECT D.DEPARTMENT,
CASE
	WHEN P.GENDER='E' THEN 'ERKEK'
	WHEN P.GENDER='K' THEN 'KADIN'
END AS GENDER
,COUNT(P.ID) AS PERSONCOUNT 
FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID=P.DEPARTMENTID

WHERE OUTDATE IS NULL

GROUP BY D.DEPARTMENT,GENDER
ORDER BY 1  , 3

--Write the query that brings the number of women and men who are still working in our company based on department.

SELECT DEPARTMENT,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID=D.ID AND GENDER='E' AND OUTDATE IS NULL) AS MALE_PERSONCOUNT ,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID=D.ID AND GENDER='K' AND OUTDATE IS NULL) AS FEMALE_PERSONCOUNT
FROM
DEPARTMENT D 
ORDER BY D.DEPARTMENT

--a new chief has been appointed to the planning department of our company and we want to determine his salary. what is the query that returns the minimum, maximum and average chief salary for the planning department? (note: the salaries of the dismissed personnel are also included.)

--Method 1--


SELECT PT.POSITION,
MIN(SALARY) AS MIN_SALARY,
MAX(SALARY) AS MAX_SALARY,
ROUND(AVG(SALARY),0) AS AVG_SALARY
FROM PERSON P
INNER JOIN POSITION PT ON PT.ID=P.POSITIONID
WHERE POSITION='PLANLAMA ŞEFİ'

GROUP BY POSITION


--Method 2--


SELECT POS.POSITION,
MIN(P.SALARY) AS MIN_SALARY,
MAX(P.SALARY) AS MAX_SALARY,
ROUND(AVG(P.SALARY),0) AS AVG_SALARY
FROM POSITION POS
INNER JOIN PERSON P ON P.POSITIONID=POS.ID
WHERE POS.POSITION='PLANLAMA ŞEFİ'

GROUP BY POSITION


--Subquery


SELECT 
POS.POSITION ,
(SELECT MIN(SALARY) FROM PERSON WHERE POSITIONID=POS.ID) AS MIN_SALARY,
(SELECT MAX(SALARY) FROM PERSON WHERE POSITIONID=POS.ID) AS MAX_SALARY,
(SELECT ROUND(AVG(SALARY),0) FROM PERSON WHERE POSITIONID=POS.ID) AS AVG_SALARY
FROM POSITION POS
WHERE POS.POSITION='PLANLAMA ŞEFİ'

--We want to list how many people are currently employed in each position and how much their average salaries are. write the query that brings this result.

---Method 1---


SELECT
 POS.POSITION,COUNT(P.ID) AS PERSONCOUNT,
 ROUND(AVG(P.SALARY),0) AS AVG_SALARY
 FROM POSITION POS
 INNER JOIN PERSON P ON P.POSITIONID=POS.ID
 GROUP BY POS.POSITION
 ORDER BY POS.POSITION


-- Subquery


SELECT 
POS.POSITION,
(SELECT COUNT(*) FROM PERSON WHERE POSITIONID=POS.ID) AS PERSONCOUNT,
(SELECT ROUND(AVG(SALARY),0) FROM PERSON WHERE POSITIONID=POS.ID) AS AVG_COUNT
FROM POSITION POS
ORDER BY POS.POSITION

--Write the query that lists the number of personnel hired by years on the basis of men and women.

SELECT DISTINCT YEAR(P.INDATE) YEAR_ ,
(SELECT COUNT(*) FROM PERSON WHERE GENDER='E' AND YEAR(INDATE)=YEAR(P.INDATE)) AS MALE_PERSONCOUNT ,
(SELECT COUNT(*) FROM PERSON WHERE GENDER='K' AND YEAR(INDATE)=YEAR(P.INDATE)) AS FEMALE_PERSONCOUNT
FROM PERSON P
ORDER BY 1

--Write the query that returns the information about how long each employee has been working in months.

SELECT NAME_+' '+SURNAME AS PERSON, 
INDATE,OUTDATE,DATEDIFF(MONTH,INDATE,GETDATE()) AS WORKINGTIME
FROM PERSON WHERE OUTDATE IS NULL
UNION ALL
SELECT NAME_+' '+SURNAME AS PERSON, 
INDATE,OUTDATE,DATEDIFF(MONTH,INDATE,OUTDATE) AS WORKINGTIME
FROM PERSON WHERE OUTDATE IS NOT NULL

--on its 5th anniversary, our company will print an agenda with the initials of everyone's name and surname on it and present it to its employees. for this purpose, type the query that brings the answer to the question of at least how many agendas will be printed from which letter combination. note: for those with two names, the initials of the first name will be used.

SELECT  
SUBSTRING(NAME_,1,1)+'.'+SUBSTRING(SURNAME,1,1)+'.' AS SHORTNAME,
COUNT(*) PERSONCOUNT
FROM PERSON
GROUP BY SUBSTRING(NAME_,1,1),SUBSTRING(SURNAME,1,1)
ORDER BY COUNT(*) DESC

--Write the query that will list the departments with an average salary of more than 5.500 tl.

					
SELECT D.DEPARTMENT,ROUND(AVG(SALARY),0) AS AVGSALARY FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID=P.DEPARTMENTID 
GROUP BY D.DEPARTMENT
HAVING AVG(SALARY) > 5500


--Subquery


SELECT *,
(SELECT ROUND(AVG(SALARY),0) FROM PERSON WHERE DEPARTMENTID=D.ID) AS AVGSALARY
FROM DEPARTMENT D
WHERE (SELECT ROUND(AVG(SALARY),0) FROM PERSON WHERE DEPARTMENTID=D.ID)>5500
ORDER BY 1

--Write the query that will calculate the average seniority of the departments in months and pull it as shown in the figure.


SELECT DEPARTMENT,AVG(WORKINGTIME)
FROM
(
SELECT D.DEPARTMENT,
CASE WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH,INDATE,OUTDATE)
ELSE DATEDIFF(MONTH,INDATE,GETDATE()) END AS WORKINGTIME
FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID=P.DEPARTMENTID
) T GROUP BY DEPARTMENT
ORDER BY 1

--write the query that returns the name and position of each staff member and the name and position of the unit manager to whom he/she reports.

SELECT P.NAME_+' '+P.SURNAME AS PERSON,POS.POSITION,
P2.NAME_+' '+P2.SURNAME AS MANAGERNAME,
POS2.POSITION AS MANAGERPOSITION

FROM PERSON P
INNER JOIN POSITION POS ON POS.ID=P.POSITIONID
INNER JOIN PERSON P2 ON P.MANAGERID=P2.ID
INNER JOIN POSITION POS2 ON POS2.ID=P2.POSITIONID