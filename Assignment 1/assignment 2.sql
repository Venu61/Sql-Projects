create database class1;
use class1;
--user1
insert into class2 values('dinesh');
select SCOPE_IDENTITY();
select @@IDENTITY
select IDENT_CURRENT('class2');




create table class1(id int identity(1,1),value varchar(25));
create table class2(id int identity(1,1),value varchar(25));
insert into class1 values('venu');
select SCOPE_IDENTITY();
select @@IDENTITY


select * from class1;
select SCOPE_IDENTITY();
select @@IDENTITY
select * from class1;
select * from class2;
create trigger trforinsert on class1 for insert 
as 
begin
   insert into class2 values('dinesh')
end
select * from class2;