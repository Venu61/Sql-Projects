
use project;

create table countries(country_id int primary key,country_name varchar(20));

insert into countries(country_id,country_name) 
values
(1,'USA'),
(2,'China'),
(3,'Japan'),
(4,'Germany'),
(5,'Inida'),
(6,'France'),
(7,'United Kingdom'),
(8,'Brazill'),
(9,'Italy'),
(10,'Canada');

select * from countries;

create table debt_indicaters(indicator_id int primary key,indicator_name nvarchar(150));

insert into debt_indicaters(indicator_id,indicator_name)
values
(1,'external debt stock, total(DOD, current US$'),
(2,'PPG, bilateral(AMT, current US$)'),
(3,'PPG, muiltilateral(AMT, current US$)'),
(4,'GDP,(current US$)'),
(5,'short term debt(% of export of gooods, services and primary income)'),
(6,'tatol reserves(inculdes gold, current US$)'),
(7,'total reseves in months of imports'),
(8,'gross savings(% of GDP)'),
(9,'gross national expenditure(% of GDP)'),
(10,'net investments in non-financial assets(% of GDP)');

select * from debt_indicaters;

create table debt_data(data_id int primary key,country_id int foreign key references countries,
indicator_id int foreign key  references debt_indicaters,year date,debt_amount decimal,principal_repayment decimal);

insert into debt_data(data_id,country_id,indicator_id,year,debt_amount,principal_repayment) 
values
(1,1,1,'2021',5000000000,200000000),
(2,2,2,'2021',3000000000,150000000),
(3,3,3,'2021',4000000000,180000000),
(4,4,4,'2021',7000000000,250000000),
(5,5,5,'2021',2500000000,100000000),
(6,6,6,'2021',6000000000,300000000),
(7,7,7,'2021',4500000000,220000000),
(8,8,8,'2021',5500000000,270000000),
(9,9,9,'2021',3500000000,160000000),
(10,10,10,'2021',6500000000,280000000);

select * from debt_data;

create table income(income_id int primary key,country_id int foreign key references countries,income_group nvarchar(40));

insert into income(income_id,country_id,income_group) 
values
(1,1,'High'),
(2,2,'Upper-Middle'),
(3,3,'Lower-Middle'),
(4,4,'Low'),
(5,5,'High');

select * from income;

select * from countries; 
select * from debt_indicaters;
select * from debt_data;
select * from income;

--1 List all distinct countries present in the dataset.
select distinct country_name from countries;

--2 Display the distinct debt indicators or types of debt.
select indicator_name from debt_indicaters;

--3 Calculate the total debt owned by each country.
select country_name,debt_amount from debt_data inner join countries on debt_data.country_id=countries.country_id;

--4 Identify the country with the highest total debt.
select top 1 debt_amount,country_name from debt_data join countries on debt_data.country_id=countries.country_id order by debt_amount desc;

--5 Find the average debt amount across all countries.
select avg(debt_amount) as average_debt_amount from debt_data;

--6 Determine the country with the highest average debt.
select top 1 country_name,avg(debt_amount) as averagedebt
from countries  join debt_data on debt_data.country_id=countries.country_id
group by country_name
order by averagedebt desc;

--7 List all countries with debt greater than the global average.
with avgdebt as (select avg(debt_amount) as global_avg_debt from debt_data)
select country_name, debt_amount from countries 
join debt_data on countries.country_id = debt_data.country_id
cross join AvgDebt
where debt_amount > avgdebt.global_avg_debt;

--8  Find the total debt amount for each debt indicator.

select di.indicator_id, di.indicator_name,
sum(dd.debt_amount) as total_debt_amount
from debt_data dd
join debt_indicaters di ON dd.indicator_id = di.indicator_id
group by di.indicator_id, di.indicator_name;


--9 Identify the most common debt indicator.

select top 1
    debt_indicaters.indicator_id,
    debt_indicaters.indicator_name,
count(*) as indicator_count
from debt_data JOIN debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id group by debt_indicaters.indicator_id, debt_indicaters.indicator_name ORDER BY COUNT(*) DESC;

--10 Calculate the average debt amount for each debt indicator.

select  debt_indicaters.indicator_id,
    debt_indicaters.indicator_name,
avg(debt_data.debt_amount) AS average_debt_amount
from 
    debt_data
join 
    debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
group by
    debt_indicaters.indicator_id, debt_indicaters.indicator_name;

--12 Determine the debt indicator with the highest average debt.

select top 1
    debt_indicaters.indicator_id,
    debt_indicaters.indicator_name,
 avg(debt_data.debt_amount) AS average_debt_amount
from 
    debt_data
join 
    debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
group by 
    debt_indicaters.indicator_id, debt_indicaters.indicator_name
order by 
    avg(debt_data.debt_amount) DESC;
--13 List countries with debt indicators having higher-than-average debt.
with AvgDebt as 
(select avg(debt_amount) as global_avg_debt 
   from debt_data)
select 
   countries.country_id,
   countries.country_name,
   debt_indicaters.indicator_id,
   debt_indicaters.indicator_name,debt_data.debt_amount
from 
    countries
join 
    debt_data ON countries.country_id = debt_data.country_id
join 
    debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
cross join 
    AvgDebt
where 
    debt_data.debt_amount > AvgDebt.global_avg_debt;

--14 Find the total debt amount for each year.
select year(year) as debt_year,sum(debt_amount) 
AS total_debt_amount from debt_data
group by year(year)
order by year(year);

--15 Calculate the average debt amount for each year.
select year(year) as debt_year,AVG(debt_amount) 
AS average_debt_amount from debt_data 
group by year(year)
order by year(year);

--16 Identify the year with the highest total debt.
select year(year) as debt_year,SUM(debt_amount)
AS total_debt_amount from debt_data
group by year(year)
order by year(debt_amount) desc;

--17 Determine the year with the highest average debt.
select year(year) AS debt_year,
    avg(debt_amount) AS average_debt_amount
from debt_data
group by year(year)
order by avg(debt_amount) desc;

--18 List all countries with debt greater than a specified threshold.
select
    countries.country_id,
    countries.country_name,
    debt_data.debt_amount
from countries
join debt_data on countries.country_id = debt_data.country_id
where debt_data.debt_amount > 30;

--19 Find the total debt amount for each region.
select 
    countries.country_name,
    sum(debt_data.debt_amount) as total_debt_amount
from countries
join debt_data ON countries.country_id = debt_data.country_id
group by countries.country_name;

--20  Calculate the average debt amount for each region.
select 
    countries.country_name,
    avg(debt_data.debt_amount) AS average_debt_amount
from countries
join debt_data on countries.country_id = debt_data.country_id
group by countries.country_name;

--21 Identify the region with the highest total debt.
select top 1
    countries.country_name,
    sum(debt_data.debt_amount) AS total_debt_amount
from countries
join debt_data ON countries.country_id = debt_data.country_id
group by countries.country_name
order by sum(debt_data.debt_amount) desc;

--22 Determine the region with the highest average debt.
select top 1
    countries.country_name,
    avg(debt_data.debt_amount) AS average_debt_amount
from countries
join debt_data ON countries.country_id = debt_data.country_id
group by countries.country_name
order by avg(debt_data.debt_amount) desc;

--23 List all countries with debt greater than the regional average.
select 
    countries.country_name,
    debt_data.debt_amount
from countries
join debt_data ON countries.country_id = debt_data.country_id
join (select country_id,avg(debt_amount) as country_avg_debt
from debt_data
group by country_id) AS country_avg ON countries.country_id = country_avg.country_id
where debt_data.debt_amount > country_avg.country_avg_debt;

--24 Find the total debt amount for each income group.
select 
    debt_data.debt_amount,
    sum(debt_data.debt_amount) as total_debt_amount
from
debt_data
group by 
debt_data.debt_amount;

--25 Calculate the average debt amount for each income group.
select 
    debt_data.debt_amount,
    avg(debt_data.debt_amount) AS average_debt_amount
from
debt_data
group by
debt_data.debt_amount;

--26 Identify the income group with the highest total debt.
select top 1
    debt_data.debt_amount,
    SUM(debt_data.debt_amount) AS total_debt_amount
from
    debt_data
group by 
    debt_data.debt_amount
order by 
    total_debt_amount desc;

--27 Determine the income group with the highest average debt.
select top 1
    debt_data.debt_amount,
    AVG(debt_data.debt_amount) AS average_debt_amount
from
debt_data
group
     debt_data.debt_amount
order by 
average_debt_amount desc;

--28 List all countries with debt greater than the income group average.
select
    country_name,
    debt_amount
from
    countries
join
    debt_data ON countries.country_id = debt_data.country_id
join 
    (select avg(debt_amount) as avg_debt_amount
 from 
     debt_data) as avg_debt on debt_data.debt_amount > avg_debt.avg_debt_amount;
		 
--29 Find the total debt amount for each debt type and income group combination.

select 
    debt_indicaters.indicator_name AS debt_type,
    debt_data.debt_amount,
    sum(debt_data.principal_repayment) as principal_repayment
from
    debt_data
join
    debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
group by 
    debt_indicaters.indicator_name,
    debt_data.debt_amount;

--30 Calculate the average debt amount for each debt type and income group combination.
select 
    debt_indicaters.indicator_name as debt_type,
    debt_data.debt_amount,
    avg(debt_data.debt_amount) as principal_repayment
from 
    debt_data
join 
    debt_indicaters on debt_data.indicator_id = debt_indicaters.indicator_id
group by 
    debt_indicaters.indicator_name,
    debt_data.debt_amount;

--31 Identify the debt type and income group combination with the highest total debt.
select top 1
    debt_indicaters.indicator_name as debt_type,
    debt_data.debt_amount,
    sum(debt_data.debt_amount) as total_debt_amount
from 
    debt_data
join 
    debt_indicaters on debt_data.indicator_id = debt_indicaters.indicator_id
group by
    debt_indicaters.indicator_name,
    debt_data.debt_amount
order by 
    total_debt_amount desc;

--32Determine the debt type and income group combination with the highest average debt.
select top 1
    debt_indicaters.indicator_name as debt_type,
    debt_data.debt_amount,
    avg(debt_data.debt_amount) as total_average_amount
from 
    debt_data
join 
    debt_indicaters on debt_data.indicator_id = debt_indicaters.indicator_id
group by 
    debt_indicaters.indicator_name,
    debt_data.debt_amount
order by 
    total_debt_amount desc;

--33 
with CountryDebt as 
(select
    countries.country_name,
    debt_data.debt_amount,
    sum(debt_data.debt_amount) as total_debt_amount
from
    countries
join
    debt_data on countries.country_id = debt_data.country_id
group by
        countries.country_name,
        debt_data.debt_amount)
select country_name,
    debt_amount,
    total_debt_amount
from
    CountryDebt
where
    total_debt_amount > 2000000000;

--34  Find the total debt amount for each debt type and region combination.
select countries.country_name as country,
       debt_indicaters.indicator_name as debt_type,
       sum(debt_data.debt_amount) as total_debt_amount
from 
debt_data
join 
countries on debt_data.country_id = countries.country_id
join
debt_indicaters on debt_data.indicator_id = debt_indicaters.indicator_id
group by
countries.country_name, debt_indicaters.indicator_name;

--35 Calculate the average debt amount for each debt type and region combination.
select countries.country_name as country,
       debt_indicaters.indicator_name as debt_type,
       avg(debt_data.debt_amount) as total_average_amount
from debt_data
join 
countries on debt_data.country_id = countries.country_id
join
debt_indicaters on debt_data.indicator_id = debt_indicaters.indicator_id
group by 
countries.country_name, debt_indicaters.indicator_name;

--36 Identify the debt type and region combination with the highest total debt.
SELECT top 1 countries.country_name AS country,
       debt_indicaters.indicator_name AS debt_type,
       SUM(debt_data.debt_amount) AS total_debt_amount
FROM debt_data
JOIN countries ON debt_data.country_id = countries.country_id
JOIN debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY countries.country_name, debt_indicaters.indicator_name
ORDER BY total_debt_amount DESC;

--37 Determine the debt type and region combination with the highest average debt.

SELECT top 1 countries.country_name AS country,
       debt_indicaters.indicator_name AS debt_type,
       avg(debt_data.debt_amount) AS total_average_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
countries.country_name, debt_indicaters.indicator_name
ORDER BY
total_debt_amount DESC

--38 List all countries with debt greater than a specified threshold within each region.

SELECT countries.country_name AS country,
       countries.country_id AS country_id,
       debt_indicaters.indicator_name AS debt_type,
       debt_data.debt_amount AS total_debt_amount
FROM
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
WHERE
debt_data.debt_amount > 2000000000
ORDER BY 
countries.country_name;

--39 Find the total debt amount for each debt indicator and year combination.

SELECT debt_indicaters.indicator_name AS debt_indicator,
       YEAR(debt_data.year) AS year,
       SUM(debt_data.debt_amount) AS total_debt_amount
FROM
debt_data
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
debt_indicaters.indicator_name, YEAR(debt_data.year);

-- 40 Calculate the average debt amount for each debt indicator and year combination.

SELECT debt_indicaters.indicator_name AS debt_indicator,
       YEAR(debt_data.year) AS year,
       avg(debt_data.debt_amount) AS total_average_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY 
debt_indicaters.indicator_name, YEAR(debt_data.year);

--41 Identify the debt indicator and year combination with the highest total debt.
SELECT TOP 1
    debt_indicaters.indicator_name AS debt_indicator,
    YEAR(debt_data.year) AS year,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
total_debt_amount DESC;


--42 Determine the debt indicator and year combination with the highest average debt.

SELECT TOP 1
    debt_indicaters.indicator_name AS debt_indicator,
    YEAR(debt_data.year) AS year,
    AVG(debt_data.debt_amount) AS average_debt_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
average_debt_amount DESC;

--43 

SELECT countries.country_name AS country,
       YEAR(debt_data.year) AS year,
       SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
WHERE
debt_data.debt_amount > 3000000000
GROUP BY
countries.country_name, YEAR(debt_data.year)
ORDER BY
YEAR(debt_data.year), countries.country_name

--44 Find the total debt amount for each debt indicator and income group combination.
 
SELECT debt_indicaters.indicator_name AS debt_indicator,
       debt_data.debt_amount AS debt_amount,
       sum(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, debt_data.debt_amount
ORDER BY
debt_indicaters.indicator_name, debt_data.debt_amount;

--45 Calculate the average debt amount for each debt indicator and income group combination.

SELECT debt_indicaters.indicator_name AS debt_indicator,
       debt_data.debt_amount AS debt_amount,
       AVG(debt_data.debt_amount) AS average_debt_amount
FROM 
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, debt_data.debt_amount
ORDER BY
debt_indicaters.indicator_name, debt_data.debt_amount;

--46 Identify the debt indicator and income group combination with the highest total debt.

SELECT TOP 1
    debt_indicaters.indicator_name AS debt_indicator,
    debt_data.debt_amount AS debt_amount,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, debt_data.debt_amount
ORDER BY
SUM(debt_data.debt_amount) DESC;


--47 Determine the debt indicator and income group combination with the highest average debt.

SELECT TOP 1
    debt_indicaters.indicator_name AS debt_indicator,
    debt_data.debt_amount AS debt_amount,
    AVG(debt_data.debt_amount) AS average_debt_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, debt_data.debt_amount
ORDER BY
AVG(debt_data.debt_amount) DESC;


--48 List all countries with debt greater than a specified threshold within each income group and debt indicator combination.

SELECT countries.country_name AS country,
       debt_data.debt_amount AS debt_amount,
       debt_indicaters.indicator_name AS debt_indicator,
       SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
WHERE 
debt_data.debt_amount > 3000000000
GROUP BY
countries.country_name, 
debt_data.debt_amount,
debt_indicaters.indicator_name
ORDER BY
debt_indicaters.indicator_name, 
debt_data.debt_amount, 
countries.country_name;
 

 --49 Find the total debt amount for each debt indicator and region combination.

 SELECT countries.country_name AS country,
       debt_indicaters.indicator_name AS debt_indicator,
       SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
countries.country_name, debt_indicaters.indicator_name
ORDER BY
countries.country_name, debt_indicaters.indicator_name;


--50 Calculate the average debt amount for each debt indicator and region combination.

SELECT countries.country_name AS country,
       debt_indicaters.indicator_name AS debt_indicator,
       avg(debt_data.debt_amount) AS total_average_amount
FROM
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
countries.country_name, debt_indicaters.indicator_name
ORDER BY
countries.country_name, debt_indicaters.indicator_name;


--51 Identify the debt indicator and region combination with the highest total debt.

SELECT TOP 1
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_indicator,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
countries.country_name, debt_indicaters.indicator_name
ORDER BY
SUM(debt_data.debt_amount) DESC;


--52 Determine the debt indicator and region combination with the highest average debt.

SELECT TOP 1
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_indicator,
    avg(debt_data.debt_amount) AS total_average_amount
FROM
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
countries.country_name, debt_indicaters.indicator_name
ORDER BY
avg(debt_data.debt_amount) DESC;


--53 List all countries with debt greater than a specified threshold within each region and debt indicator combination.

SELECT debt_indicaters.indicator_name AS debt_type,
       YEAR(debt_data.year) AS year,
       SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
debt_indicaters.indicator_name, YEAR(debt_data.year);


--54 Find the total debt amount for each debt type and year combination.

SELECT debt_indicaters.indicator_name AS debt_type,
       YEAR(debt_data.year) AS year,
       avg(debt_data.debt_amount) AS total_average_amount
FROM
debt_data
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
debt_indicaters.indicator_name, YEAR(debt_data.year);


--55 Calculate the average debt amount for each debt type and year combination.

SELECT TOP 1
    debt_indicaters.indicator_name AS debt_type,
    YEAR(debt_data.year) AS year,
    avg(debt_data.debt_amount) AS total_average_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
SUM(debt_data.debt_amount) DESC;


---56 Identify the debt type and year combination with the highest total debt.

SELECT TOP 1
    debt_indicaters.indicator_name AS debt_type,
    YEAR(debt_data.year) AS year,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
SUM(debt_data.debt_amount) DESC;


--57 Determine the debt type and year combination with the highest average debt.

SELECT TOP 1
    debt_indicaters.indicator_name AS debt_type,
    YEAR(debt_data.year) AS year,
    avg(debt_data.debt_amount) AS total_average_amount
FROM
debt_data
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY
avg(debt_data.debt_amount) DESC;


--58 List all countries with debt greater than a specified threshold within each year and debt type combination.

SELECT countries.country_name,
       debt_indicaters.indicator_name,
       YEAR(debt_data.year) as year,
       SUM(debt_data.debt_amount)as specified_threshold 
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
WHERE 
debt_data.debt_amount > 2500000000 
GROUP BY
countries.country_name, 
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY 
YEAR(debt_data.year), 
debt_indicaters.indicator_name, countries.country_name;


--59 Find the total debt amount for each debt type and region and year combination.

SELECT countries.country_name AS country,
       debt_indicaters.indicator_name AS debt_type,
       YEAR(debt_data.year) AS year,
       SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
countries.country_name, 
debt_indicaters.indicator_name, YEAR(debt_data.year)
ORDER BY 
countries.country_name,
debt_indicaters.indicator_name, YEAR(debt_data.year);


--60 Calculate the average debt amount for each debt type and region and year combination.

SELECT 
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_type,
    YEAR(debt_data.year) AS year,
    AVG(debt_data.debt_amount) AS average_debt_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year)
ORDER BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year);


--61 Identify the debt type and region and year combination with the highest total debt. 

SELECT TOP 1
    country,
    debt_type,
    year,
    average_debt_amount
FROM
    (SELECT 
        countries.country_name AS country,
        debt_indicaters.indicator_name AS debt_type,
        YEAR(debt_data.year) AS year,
        AVG(debt_data.debt_amount) AS average_debt_amount,
        ROW_NUMBER() OVER (ORDER BY AVG(debt_data.debt_amount) DESC) AS rn
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year)) AS subquery where rn=1;


--62 Determine the debt type and region and year combination with the highest average debt.

SELECT TOP 1 WITH TIES
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_type,
    YEAR(debt_data.year) AS year,
    AVG(debt_data.debt_amount) AS average_debt_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year)
ORDER BY 
AVG(debt_data.debt_amount) DESC;

	

-- 63	List all countries with debt greater than a specified threshold within each region and year and debt type combination.

SELECT 
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_type,
    YEAR(debt_data.year) AS year,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
WHERE 
debt_data.debt_amount > 2500000000
GROUP BY
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year)
ORDER BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year);


--64 Find the total debt amount for each debt indicator and income group and year combination.

SELECT 
    debt_indicaters.indicator_name AS debt_indicator,
    debt_data.debt_amount,
    YEAR(debt_data.year) AS year,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
debt_indicaters.indicator_name, 
debt_data.debt_amount, 
YEAR(debt_data.year)
ORDER BY 
debt_indicaters.indicator_name, 
debt_data.debt_amount, 
YEAR(debt_data.year);


--65 Calculate the average debt amount for each debt indicator and income group and year combination.

SELECT 
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_indicator,
    YEAR(debt_data.year) AS year,
    AVG(debt_data.debt_amount) AS average_debt_amount
FROM 
debt_data
JOIN 
    countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year)
ORDER BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year);


--66 Identify the debt indicator and income group and year combination with the highest total debt.

SELECT TOP 1
    debt_indicaters.indicator_name AS debt_indicator,
    countries.country_name AS country,
    YEAR(debt_data.year) AS year,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name,
countries.country_name,
YEAR(debt_data.year)
ORDER BY
SUM(debt_data.debt_amount) DESC;



--67 Determine the debt indicator and income group and year combination with the highest average debt.
 
SELECT TOP 1 WITH TIES
    debt_indicaters.indicator_name AS debt_indicator,
    countries.country_name AS country,
    YEAR(debt_data.year) AS year,
    AVG(debt_data.debt_amount) AS average_debt_amount
FROM
debt_data
JOIN
countries ON debt_data.country_id = countries.country_id
JOIN
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY
debt_indicaters.indicator_name,
countries.country_name,
YEAR(debt_data.year)
ORDER BY
AVG(debt_data.debt_amount) DESC;



--68 List all countries with debt greater than a specified threshold within each income group and year and debt indicator combination.

SELECT 
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_indicator,
    YEAR(debt_data.year) AS year,
    debt_data.debt_amount AS debt_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
WHERE 
debt_data.debt_amount > 5000000000
ORDER BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year);


--69 Find the total debt amount for each debt indicator and region and year combination.

SELECT 
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_indicator,
    YEAR(debt_data.year) AS year,
    SUM(debt_data.debt_amount) AS total_debt_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year)
ORDER BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year);


--70 Calculate the average debt amount for each debt indicator and region and year combination.

SELECT 
    countries.country_name AS country,
    debt_indicaters.indicator_name AS debt_indicator,
    YEAR(debt_data.year) AS year,
    AVG(debt_data.debt_amount) AS average_debt_amount
FROM 
debt_data
JOIN 
countries ON debt_data.country_id = countries.country_id
JOIN 
debt_indicaters ON debt_data.indicator_id = debt_indicaters.indicator_id
GROUP BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year)
ORDER BY 
countries.country_name, 
debt_indicaters.indicator_name, 
YEAR(debt_data.year);


--71 

SELECT 
    debt_indicaters.indicator_name AS debt_indicator,
    countries.country_name AS country,
    YEAR(debt_data.year)AS year,
    total_debt.total_debt_amount AS highest_total_debt
FROM 
(SELECT indicator_id,country_id,year, SUM(debt_amount) AS total_debt_amount
FROM 
debt_data
GROUP BY 
indicator_id, 
country_id, 
year) AS total_debt
JOIN 
debt_indicaters ON total_debt.indicator_id = debt_indicaters.indicator_id
JOIN 
countries ON total_debt.country_id = countries.country_id
ORDER BY 
total_debt_amount DESC;



