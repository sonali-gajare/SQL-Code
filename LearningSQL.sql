-- select and where

SELECT * FROM Parks_and_Recreation.employee_demographics;
use Parks_and_Recreation;

select * from employee_demographics 
where gender = 'female';
 
select * from Parks_and_Recreation.employee_demographics 
where age >=  40;

select * from employee_demographics
where first_name like 'a%';

select * from employee_demographics
where first_name like 'a__';

select * from employee_demographics
where first_name like 'a___%';

-- group by and order by

select gender, AVG(age), MAX(age) ,COUNT(age)
from employee_demographics
GROUP BY gender;

select * from employee_salary;

select occupation, salary
from employee_salary
GROUP BY occupation, salary;

select * from employee_demographics;
 
 select * 
 from employee_demographics
 order by first_name desc;
 
 select * 
 from employee_demographics
 order by age DESC,gender DESC;
 
 -- Having vs Where
 
 select gender, AVG(age) as avg_age
 from employee_demographics
 group by gender
 having avg_age >= 40;
 
 
 
 -- limit and Alias
 
 select * 
 from employee_demographics
 order by first_name
 limit 3;
 
 select * 
 from employee_demographics
 order by first_name
 limit 0,3;
 
 select * 
 from employee_demographics
 order by age DESC
 limit 2,1;
 
-- Alias 
SELECT gender, AVG(age) AS Avg_age
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender;

-- JOINS

select * from employee_demographics;
select * from employee_salary;

select * from employee_demographics
JOIN 
employee_salary
ON employee_demographics.employee_id = employee_salary.employee_id;


select * from employee_demographics dem
INNER JOIN
employee_salary sal
ON dem.employee_id = sal.employee_id;

select * from employee_demographics dem
LEFT JOIN
employee_salary sal
ON dem.employee_id = sal.employee_id;

select * from employee_demographics dem
RIGHT JOIN
employee_salary sal
ON dem.employee_id = sal.employee_id;

-- self join
select * 
from employee_salary emp1
JOIN employee_salary emp2
ON emp1.employee_id = emp2.employee_id;

select emp1.employee_id as santa, emp1.first_name as Santa_name, emp2.employee_id, emp2.first_name
from employee_salary emp1
JOIN employee_salary emp2
ON emp1.employee_id + 1 = emp2.employee_id;

select * from parks_departments;

-- join multiple tables

select * 
from employee_demographics dem
INNER JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
JOIN parks_departments pak
ON pak.department_id = sal.dept_id;

-- Unions
select first_name,last_name
from employee_demographics
UNION
select occupation,salary
from employee_salary;

select employee_id,first_name,last_name
from employee_demographics
UNION
select employee_id,first_name,last_name
from employee_salary;

-- Union will get rid of duplicates. Union is actually shorthand for Union Distinct

select employee_id,first_name,last_name
from employee_demographics
UNION ALL
select employee_id,first_name,last_name
from employee_salary;

select employee_id,first_name,last_name
from employee_demographics
where age > 40
UNION
select employee_id,first_name,last_name
from employee_salary
where salary >= 70000
order by first_name;

-- String Functions

select first_name, LENGTH(first_name)
from employee_demographics;

select first_name, UPPER(first_name)
from employee_demographics;

select first_name, LOWER(first_name)
from employee_demographics;

-- trim will remove white spaces from front and end
SELECT TRIM('   sky is Beautiful       '); 

SELECT LTRIM('   sky is Beautiful                            ');

SELECT RTRIM('               sky is Beautiful                              ');

select LEFT('Sonali',3);
select RIGHT('Sonali',3);

select first_name, LEFT(first_name,3)
from employee_demographics;

select first_name, RIGHT(first_name,3)
from employee_demographics;

select SUBSTRING('Sonali',1,2);
-- result So

select birth_date, SUBSTRING(birth_date,1,4) year
from employee_demographics;

select first_name, REPLACE(first_name,'a','z')
from employee_demographics;

select LOCATE('li','Sonali');

select first_name, LOCATE('a',first_name)
from employee_demographics;

select CONCAT('Sonali',' ','Gajare');

select CONCAT(first_name,' ',last_name) full_name
from employee_demographics;

-- Case statements

select first_name,last_name,
CASE 
        WHEN age >=30 THEN 'NOT YOUNG'
END 
from employee_demographics;

select first_name,last_name,
CASE 
        WHEN age <=30 THEN 'YOUNG'
        WHEN age BETWEEN 31 AND 50 THEN 'MIDDLE AGE'
        WHEN age >=50 THEN 'OLD'
END AS 'Category'
from employee_demographics;

-- Pawnee Council sent out a memo of their bonus and pay increase structure so we need to follow it
-- Basically if they make less than 45k then they get a 5% raise - very generous
-- if they make more than 45k they get a 7% raise
-- they get a bonus of 10% if they work for the Finance Department

select first_name, last_name, salary,
CASE 
		WHEN salary <=45000 THEN salary + (salary * 0.5)
        WHEN salary >45000 THEN salary + (salary * 0.7)
END as new_salary,
CASE 
		WHEN dept_id =6 THEN salary * 0.10
END as bonus
from employee_salary;       

-- Subqueries

select * from employee_demographics
where employee_id IN
			(select employee_id from employee_salary 
			 where dept_id = 1);

-- use subqueries in select and from

select first_name, salary,
(select AVG(salary) from employee_salary) AS avg_salary
from employee_salary;

select * from
(select gender, AVG(age) avg_age,MIN(age) min_age,MAX(age) max_age,COUNT(age) age_count
	from employee_demographics 
    GROUP BY gender) AS agg_table;

select gender,avg(min_age) from
(select gender, AVG(age) avg_age,MIN(age) min_age,MAX(age) max_age,COUNT(age) age_count
	from employee_demographics 
    GROUP BY gender) AS agg_table 
GROUP BY gender;
 
 -- Window Function
 
 select gender, ROUND(avg(salary))
 from employee_demographics dem
 JOIN employee_salary sal
 ON dem.employee_id = sal.employee_id
 GROUP BY gender;
 
 select dem.first_name,dem.last_name,gender,salary,
 AVG(salary) 
 over()
 from employee_demographics dem
 JOIN employee_salary sal
 ON dem.employee_id = sal.employee_id;

 
select dem.first_name,dem.last_name,gender,salary,
AVG(salary)
over(PARTITION BY gender)
from employee_demographics dem
	JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    

select dem.employee_id,dem.first_name,dem.last_name,gender,salary,
SUM(salary)
over(PARTITION BY gender ORDER BY employee_id) AS SUM_SALARY
from employee_demographics dem
	JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
select dem.employee_id,dem.first_name,dem.last_name,gender,salary,
ROW_NUMBER() over(PARTITION BY gender)
from employee_demographics dem
	JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
select dem.employee_id,dem.first_name,dem.last_name,gender,salary,
ROW_NUMBER() over(PARTITION BY gender ORDER BY salary DESC) AS SALARY_ORDER
from employee_demographics dem
	JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
select dem.employee_id,dem.first_name,dem.last_name,gender,salary,
ROW_NUMBER() over(PARTITION BY gender ORDER BY salary DESC) AS ROW_NUM,
RANK() over(PARTITION BY gender ORDER BY salary DESC) AS RANK_NUM
from employee_demographics dem
	JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;   
    
select dem.employee_id,dem.first_name,dem.last_name,gender,salary,
ROW_NUMBER() over(PARTITION BY gender ORDER BY salary DESC) AS ROW_NUM,
RANK() over(PARTITION BY gender ORDER BY salary DESC) AS RANK_1,
dense_rank() over(PARTITION BY gender ORDER BY salary DESC) RANK_2
from employee_demographics dem
	JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;    
    
 -- CTE
 WITH CTE_example AS
 (
 select gender,max(salary),min(salary),avg(salary),count(salary),sum(salary)
 from employee_demographics dem
 JOIN employee_salary sal
 ON dem.employee_id = sal.employee_id
 GROUP BY gender)
 
 select * from CTE_example;
 
 select * from CTE_example; -- this will not work
 
 WITH CTE_example AS
 (
 select gender,max(salary),min(salary),avg(salary),count(salary),sum(salary)
 from employee_demographics dem
 JOIN employee_salary sal
 ON dem.employee_id = sal.employee_id
 GROUP BY gender)
 
 select gender, ROUND(AVG(`sum(salary)`/`count(salary)`)/2)
 from CTE_example
 GROUP BY gender;
 
-- multiple CTEs

with CTE_EXAMPLE AS
(
select employee_id,gender,birth_date 
from employee_demographics dem
where birth_date > '1985-01-01'
),
CTE_EXAMPLE2 AS
(
select employee_id,salary
from employee_salary
where salary >= 50000
)
 select * from CTE_EXAMPLE cte1
 LEFT JOIN CTE_EXAMPLE2 cte2
 ON cte1.employee_id = cte2.employee_id;
 
-- renaming the column in CTE. no backtick 
WITH CTE_example3(gender,max_salary,min_salary,avg_salary,count_salary,sum_salary) AS
 (
 select gender,max(salary),min(salary),avg(salary),count(salary),sum(salary)
 from employee_demographics dem
 JOIN employee_salary sal
 ON dem.employee_id = sal.employee_id
 GROUP BY gender)
 
 select gender, ROUND(AVG(sum_salary/count_salary)/2)
 from CTE_example3
 GROUP BY gender;

-- Temp table

create TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
fav_movie varchar(50));

INSERT INTO temp_table
VALUES ('Sonali','Gajare','Jab we met');

select * from temp_table;

CREATE TEMPORARY TABLE table_over_50k
select * from employee_salary
where salary >= 50000;

select * from table_over_50k;

-- Stored Procedure
select * from employee_salary 
where salary >= 60000;

CREATE PROCEDURE high_salaries()
select * from employee_salary 
where salary >= 60000;

CALL high_salaries();

-- if we tried to add another query to this stored procedure it wouldn't work. It's a separate query:
CREATE PROCEDURE large_salaries2()
SELECT *
FROM employee_salary
WHERE salary >= 60000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- Best practice is to use a delimiter and a Begin and End to really control what's in the stored procedure

DELIMITER $$
CREATE PROCEDURE large_salaries()
BEGIN
select * from employee_salary
where salary >=50000;
select * from employee_salary
where salary >=50000;
END $$


CALL large_salaries;

-- we can also add parameter

DELIMITER $$
CREATE PROCEDURE large_salaries123(emp_id INT)
BEGIN
select * from employee_salary
where salary >=50000
and emp_id = employee_id;
END $$
DELIMITER ;

CALL large_salaries123(1);

-- Triggers

-- a Trigger is a block of code that executes automatically executes when an event takes place in a table.

SELECT * FROM employee_demographics;

DELIMITER $$
CREATE TRIGGER employee_insert
AFTER INSERT ON employee_salary
FOR EACH ROW
BEGIN
INSERT INTO employee_demographics(employee_id,first_name,last_name)values(NEW.employee_id,NEW.first_name,NEW.last_name);
END $$
DELIMITER ;

-- test it out

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

select * from employee_salary;

SELECT * FROM employee_demographics;

-- EVENTS
-- Events are task or block of code that gets executed according to a schedule.

SHOW EVENTS;

DROP EVENT IF EXISTS delete_retires;

DELIMITER $$
CREATE EVENT delete_retires
ON SCHEDULE EVERY 30 SECOND
DO BEGIN
DELETE FROM employee_demographics
        WHERE age >= 60;
END $$
        
        SELECT * 		
FROM parks_and_recreation.employee_demographics;










