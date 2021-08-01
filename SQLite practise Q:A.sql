--SQL PRACTISE QUESTION AND ANSWERS
----CREATE TABLE 1

create table YTtrial (
    EMP_ID INT PRIMARY KEY,
    NAME TEXT NOT NULL,
    GENDER TEXT NOT NULL,
	ROLE TEXT NOT NULL,
	DOJ DATE NOT NULL,
	DEPT_ID INT NOT NULL,
	SALARY INT NOT NULL,
    MGR_ID INT NOT NULL
);

Insert into YTtrial (EMP_ID,NAME,GENDER,ROLE,DOJ,DEPT_ID,SALARY, MGR_ID)
values (1,"John","M","Associate", "2000-12-12", 1, 3000, 10);

Insert into YTtrial (EMP_ID,NAME,GENDER,ROLE,DOJ,DEPT_ID,SALARY, MGR_ID)
values (2,"Jane","F","Associate","2014-06-04", 1, 2000, 10);

Insert into YTtrial (EMP_ID,NAME,GENDER,ROLE,DOJ,DEPT_ID,SALARY, MGR_ID)
values (3,"Shaun","M","Associate","2019-09-07", 1, 1000, 12);

Insert into YTtrial (EMP_ID,NAME,GENDER,ROLE,DOJ,DEPT_ID,SALARY, MGR_ID)
values (4,"Ron","M","Associate","2012-08-10", 2, 6000, 14);

Insert into YTtrial (EMP_ID,NAME,GENDER,ROLE,DOJ,DEPT_ID,SALARY, MGR_ID)
values (5,"Kate","F","Associate","2017-02-11", 2, 5000, 16);

Insert into YTtrial (EMP_ID,NAME,GENDER,ROLE,DOJ,DEPT_ID,SALARY, MGR_ID)
values (6,"Leo","M","Associate","2018-02-02", 2, 4000, 16);

--
--UPDATE YTtrial
--SET DOJ = '12-12-2000'
--WHERE EMP_ID = 1;
--
--UPDATE YTtrial
--SET DOJ = '06-04-2014'
--WHERE EMP_ID = 2;
--
--UPDATE YTtrial
--SET DOJ = '07-09-2019'
--WHERE EMP_ID = 3;
--
--UPDATE YTtrial
--SET DOJ = '10-08-2012'
--WHERE EMP_ID = 4;
--
--UPDATE YTtrial
--SET DOJ = '11-02-2017'
--WHERE EMP_ID = 5;
--
--UPDATE YTtrial
--SET DOJ = '02-02-2018'
--WHERE EMP_ID = 6;



--CREATE TABLE 2

create table Department (
    DEPT_ID INT NOT NULL,
	  NAMED TEXT NOT NULL
);

Insert into Department (DEPT_ID,NAMED)
values (1,"IT");

Insert into Department (DEPT_ID,NAMED)
values (2,"OPERATIONS");

Insert into Department (DEPT_ID,NAMED)
values (3,"HR");




----QUESTION 1
----THIRD HIGHEST SALARY IN RESPECTIVE DEPARTMENT

WITH W1 AS 
(SELECT * ,dense_rank() OVER (Partition by DEPT_ID order by Salary desc)AS RANK FROM YTtrial )
SELECT * FROM W1 where RANK =3; 



--QUESTION 2
--LIST DEPARTMENT NAME ALONG WITH EMPLOYEE COUNT, WHICH HAS HIGHEST NUMBER OF EMPLOYEES

with w1 as
(Select * from YTtrial as a left join department as b on 
a.DEPT_ID = b.DEPT_ID)
select NAMED, COUNT(DEPT_ID) from w1 GROUP BY NAMED ORDER BY COUNT(DEPT_ID) DESC;



--QUESTION 3
--OLDEST EMPLOYEE IN EACH DEPARTMENT ALONG WITH THEIR DEPARTMENT NAMES

with w2 AS
(with w1 as
(Select * from YTtrial as a left join department as b on 
a.DEPT_ID = b.DEPT_ID 
ORDER BY DATE(DOJ) DESC, NAMED)
select Name, DOJ, NAMED, RANK() OVER(PARTITION BY NAMED ORDER BY DATE(DOJ) desc) AS RANK  from w1)
SELECT NAME,NAMED FROM W2 where rank =3;



--QUESTION 4
--EMPLOYEE WHOSE SALARY IS GREATER THAN THE AVERAGE SALARY OF THEIR DEPARTMENT

with w1 as 
(Select dept_id, avg(salary) as avg from YTtrial  group by dept_id)
select * from YTtrial as a inner join w1 as b on 
a.dept_id = b.dept_id
where SALARY > avg;




--QUESTION 5
--LIST DETAILS OF ALL FEMALE ASSOCIATE WHOSE NAME STARTS WITH K AND ENDS WITH E

WITH W1 as
(Select * from YTtrial as a left join department as b on 
a.DEPT_ID = b.DEPT_ID)
select * from w1 where Gender = 'F' and NAME like "K%E";




--QUESTION 6
--FIND DEPARTMENTS WHICH DO NOT HAVE ANY EMPLOYEE ASSIGNED TO IT

WITH W1 as
(Select * from department as a left join YTtrial as b on 
a.DEPT_ID = b.DEPT_ID)
select Named from w1 group by named having count(emp_id) <1;




--QUESTION 7
--EMPLOYEE WITH 4TH HIGHEST SALARY

with w1 as
(Select name, salary, row_number() over (order by salary desc) as row from YTtrial)
select * from w1 where row =4;





--QUESTION 8
--DETAILS OF EMPLOYEES WHO ARE ON ASSOCIATE ROLE IN IT DEPARTMENT AND WHO HAVE COMPLETED 10 
--YEARS AGO WITH THE ORGANIZATION, GRANT THEM BONUS OF 100% ON THEIR SALARY

WITH W1 as
(Select * from YTtrial as a left join department as b on 
a.DEPT_ID = b.DEPT_ID)
select Name, AVG(salary) as Bonus, salary from w1 where NAMED = 'IT' AND ROLE = 'Associate' AND date('now') - date(DOJ) >= 10  ;
 




--QUESTION 9
--LIST DETAILS OF ALL EMPLOYEES WHO DONT HAVE A MANAGER AND EARN SALARY < 3000

Select * from YTtrial where MGR_ID is null and Salary < 3000;





--QUESTION10
--LIST DETAILS OF ALL EMPLOYEES WHO JOINED BETWEEN 2012 AND 2016 IN HR DEPARTMENT AND REPORT TO MGR_ID 20

WITH W1 as
(Select * from YTtrial as a left join department as b on 
a.DEPT_ID = b.DEPT_ID) 
SELECT * FROM W1 WHERE NAMED = 'HR' AND  AND DATE(DOJ) < '2016' AND DATE(DOJ) > '2012' ;

  



--QUESTION11
--LIST EMPLOYEE NAME AND SALARY ALONG WITH THE DIFFERENCE OF THEIR SALARY IN COMPARISION TO THE PERSON EARNING MAX SALARY IN THEIR DEPARTMENT

WITH W2 AS
(SELECT DEPT_ID,MAX(SALARY) as MAXSALARY FROM YTtrial GROUP BY DEPT_ID)

SELECT *, (MAXSALARY - SALARY) AS DIFF FROM W2 AS A LEFT JOIN  YTtrial AS B ON
A.DEPT_ID = B.DEPT_ID;






--QUESTION12
--DEPARTMENT NAME ALONG WITH EMPLOYEE COUNT WHOSE SALARY IS HIGHER THAN THE AVERAGE EMPLOYEE SALARY IN THE ORGANIZATION. 


WITH W3 as
(WITH W2 AS 
(SELECT DEPT_ID, AVG(SALARY) as AVGSALARY FROM YTtrial GROUP BY DEPT_ID)
SELECT * FROM W2 as A LEFT JOIN  YTtrial as B ON
A.DEPT_ID = B.DEPT_ID)
Select Name,NAMED, count(NAME) from W3  as C Left join Department as D ON
C.DEPT_ID = D.DEPT_ID WHERE (SALARY - AVGSALARY >0)
GROUP BY NAMED;







--QUESTION13
--LIST THE DEPARTMENT NAME ALONG WITH EMPLOYEE ID OF ALL THE EMPLOYEES WHO WORK AS A MANAGER IN THAT DEPARTMENT.


WITH W1 AS
(SELECT * FROM YTtrial AS A LEFT JOIN DEPARTMENT as B on A.DEPT_ID = B.DEPT_ID)
 SELECT DISTINCT NAMED, GROUP_CONCAT( MGR_ID,', ') AS MGR FROM W1 GROUP BY NAMED ORDER BY  MGR_ID;





--QUESTION14
--LIST THE MOST RECENT JOINER DETAILS FROM EACH DEPARTMENT WITHOUT USING SELF JOIN (HINT: TRY USING ANALYTICAL FUNCTION (LAG/ LEAD) 

WITH W1 as
(select *, LAG(DOJ, 1, 0) OVER (ORDER BY DOJ ) AS LAG FROM YTtrial ORDER BY DEPT_ID)
Select * ,  MAX(LAG) from W1 GROUP BY DEPT_ID;


--QUESTION15
--LIST THE DEPARTMENT NAMES OF ALL DEPARTMENTS WHICH HAVE ATLEAST 10 EMPLOYEES WHO ARE WORKING IN THE ORGANIZATION SINCE LAST 5 YEARS

WITH W1 AS
(SELECT DEPT_ID, COUNT(EMP_ID) AS EMPCOUNT FROM YTtrial WHERE DOJ > 2014-01-01 GROUP BY DEPT_ID )
SELECT * FROM W1 WHERE EMPCOUNT > 10 ;



--Select * from YTtrial;
--SELECT * from department;
