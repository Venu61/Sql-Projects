create database assigment;
use assigment;
create table assigment(ID int primary key,name varchar(20),age int,gender varchar,fee int);
insert into assigment(ID,name,age,gender,fee) values(1,'venu',20,'male',10000);
(2,'dinesh',21,'male',15000),
(3,'sharath',25,'male',12000),
(4,'vijay',21,'male',15000),
(5,'ayesha',21,'female',15000),
(6,'varsha',21,'female',15000),
(7,'balaji',23,'male',15200);
drop table assigment;
create table assigment(ID int primary key,name varchar(20),age int,gender varchar(20),fee int);
drop table assigment;
insert into assigment(ID,name,age,gender,fee) values
(2,'dinesh',21,'male',15000),
(3,'sharath',25,'male',12000),
(4,'vijay',21,'male',15000),
(5,'ayesha',21,'female',15000),
(6,'varsha',21,'female',15000),
(7,'balaji',23,'male',15200);
select * from assigment;


select min(fee) from assigment;
select max(fee) from assigment;
select count(fee) from assigment;
select avg(fee) from assigment;
select sum(fee) from assigment;


select  fee,count(fee) from assigment group by fee;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;

select  name,count(name) from assigment group by name;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;

select gender,count(gender) from assigment group by gender;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;

select age,count(age) from assigment group by age;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;


select ID,count(ID) from assigment group by ID;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;


select age from assigment group by age having count(age)=1;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;

select age from assigment group by age having count(age)=4;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;

select fee from assigment group by  fee having count( fee)=4;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;


select fee from assigment group by  fee having count( fee)=1;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;

select gender from assigment group by  gender having count(gender)=4;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;

select name from assigment group by  name having count(name)=1;
select * from assigment order by 1 desc;
select * from assigment order by 1 asc;


drop table assigment;
create table assigment(ID int primary key,name varchar(20),age int,gender varchar(20),fee int);
insert into assigment(ID,name,age,gender,fee) values (1,'venu',21,'male',15000),
(2,'dinesh',21,'male',15000),
(3,'sharath',25,'male',12000),
(4,'vijay',21,'male',15000),
(5,'ayesha',21,'female',15000),
(6,'varsha',21,'female',15000),
(7,'balaji',23,'male',15200);
select * from assigment;

select age from  assigment group by age having  min (age)=21;

select age from  assigment group by age having  max (age)=25;

select age from  assigment group by age having  avg (age)=23;

select age from  assigment group by age having  sum (age)=25;

select age from  assigment group by age having  count (age)=1;

select gender from  assigment group by gender having  count (*)=1;
