--Date function

select getdate() as present_date_time; 


select DATEADD(DAY,5,getdate());

select DATEADD(MM,5,getdate());

select DATEADD(YYYY,5,getdate());


select DATEDIFF(day,'2024-02-01','2024-01-25')

select DATEDIFF(MM,'2024-02-01','2024-01-25')

select DATEDIFF(YYYY,'2024-02-01','2020-01-25')

select day('2024-02-10')
select month('2024-02-10')
select year('2024-02-10')


select DATENAME(WEEKDAY,'2024-02-10');
select DATENAME(MONTH,'2024-02-10');
select DATENAME(YEAR,'2024-02-10');

select FORMAT(01-02-2024,'yyyy-mm-dd hh:mm:ss')AS formatted_datetime;


select CONVERT(datetime,'2024-02-01 01:02',120);


select FORMAT(123456789,'##-##-####');

select DATEPART(MONTH,'2024-02-10');
select DATENAME(MONTH,'2024-02-10');


