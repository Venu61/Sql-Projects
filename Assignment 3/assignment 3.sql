use orders;
----create an orders &customers table ,insert above values in it.

 create table orders(order_numb int primary key,customer_numb int,order_date date,order_total float);
 insert into orders(order_numb,customer_numb,order_date,order_total) values(1001,002,'10-10-09',250.85),
 (1002,002,'2-21-10',125.89),
 (1003,003,'11-15-09',1567.99),
 (1004,004,'11-12-09',180.92),
 (1005,004,'12-15-09',565.00),
 (1006,006,'11-12-09',25.00),
 (1007,006,'10-08-09',85.00),
 (1008,006,'2-12-09',109.12);
 SELECT * FROM orders;

 create table customers(customer_numb int primary key,first_name varchar(20),last_name varchar(20));
 insert into customers(customer_numb,first_name,last_name) values(001,'Jane','Doe'),
 (002,'John','Doe'),
 (003,'Jane','Smith'),
 (004,'John','Smith'),
 (005,'Jane','Jones'),
 (006,'John','Jones');
 select * from customers;
 SELECT * FROM orders;
 
 -----make an inner join on customers & orders tables on the customer_id column.

SELECT * FROM orders inner join customers on orders.customer_numb=customers.customer_numb; 

------ make left & right joins on customers & orders tables on the customer_id column.

SELECT * FROM orders left join customers on orders.customer_numb=customers.customer_numb; 

SELECT * FROM orders right join customers on orders.customer_numb=customers.customer_numb; 

---update the orders table ,set the amount to be 100 where customer_id is 3

UPDATE Orders SET order_total= 100 WHERE customer_numb = 3;
 SELECT * FROM orders;

 ---Alter the 'Customers' table to add a new column 'Email' of type VARCHAR(50). Update at least two customer records with their email addresses.


 alter table customers 
 add email varchar(50);
  select * from customers;
update customers set email='vijay@gmail.com' where customer_numb=1;select * from orders;

update customers set email='venu@gmail.com' where customer_numb=2;
 select * from customers;

 -----Perform a self-join on the 'Customers' table based on the 'city' column, retrieving customers from the same city.

SELECT * FROM customers self join customers on customers.customer_numb=customers.customer_numb; 

-----Delete all records from the 'Orders' table for customers whose 'customer_id' is not present in the 'Customers' table.

DELETE FROM Orders
WHERE NOT EXISTS(
    SELECT 2
    FROM Customers
    WHERE Customers.customer_numb = Orders.customer_numb
);
select * from customers;

---Create a new column 'order_status' in the 'Orders' table with default value 'Pending'.


alter table orders
 add order_status1  varchar(50) default('pending') not null;
 select * from orders;

 -----Update the 'Customers' table to set the 'country' column to 'Unknown' for customers with no specified country.

 alter table customers
 add country varchar(50) default('unkonwn') not null;
  select * from customers;

  -----Find the average order amount from the 'Orders' table.

  select avg(order_total) from orders;

  ----Explain the significance of foreign keys in the context of the 'customer_id' column in the 'Orders' table.

  Where we know that a primary key and foreign key maintain a parent/child relationship between the tables. Here,the customer_numb in the customer table matches the value in the order table customer_numb which is the primary key for the customer_numb column.
Create orders(customer_numb int foreign key (customer_numb) references customers(customer_numb));




 ----How would you retrieve the names of customers who have not placed any orders?

SELECT Customers.first_name,customers.last_name
FROM Customers
LEFT JOIN Orders ON Customers.customer_numb = Orders.customer_numb
WHERE Orders.customer_numb IS NULL;

----Write an SQL query to count the number of distinct cities in the 'Customers' table.

SELECT COUNT(DISTINCT first_name) AS NumberOffirst_name
FROM Customers;
SELECT COUNT(DISTINCT last_name) AS NumberOflast_name
FROM Customers;

----Explain the purpose of the DELETE statement in SQL and provide an example from the given tasks.
       
	 From delete statment we can delete column in the table 

delete from  orders where order_numb=1004;
select * from orders;

-----What considerations would you take into account when adding a new column to an existing table in a production database?

ALTER TABLE orders
add production varchar(200);
select * from orders;

----if you wanted to find the customer who spent the most on orders, how would you structure your SQL query?

SELECT customer_numb, SUM(order_total) AS total_spent
FROM orders
GROUP BY customer_numb
ORDER BY total_spent desc

-----Describe scenarios where using a default value for a column, like 'order_status' in the 'Orders' table, would be beneficial.

Using a default value for 'order_status' in the 'Orders' table is beneficial for simplifying data.

-----How would you handle situations where a customer's information needs to be updated in both the 'Customers' and 'Orders' tables simultaneously?


 The table names need not be repeated unless the same column names exist in both tables. 
 The table names are only required in the FROM, JOIN, and ON clauses, and in the latter, only because the relating column, CustomerID, has the same name in both tables.
 
 --------How would you handle situations where a customer's information needs to be updated in both the 'Customers' and 'Orders' tables simultaneously?

By using the update statement we can update the information in both customers and orders table 
byprfoeming inner join on function we can update  the both customers and orders table simultaneously

      --------Example

UPDATE Customers
SET Email = 'dinu@gmail.com'
WHERE Customer_numb=005;
 select * from customers;
 
UPDATE Orders
SET Order_Date = '2-2-2024'
WHERE Customer_numb=004;
SELECT * FROM orders;


------In a left join between 'Customers' and 'Orders,' what records are included in the result set?

when we are performing leftjoin between customers and order all the record in the customers table appears with join of order table, but on order table some values appears as NULL.

-------Explain the purpose and usage of the SQL GROUP BY clause. Provide an example using the 'Orders' table, demonstrating how it can be used to summarize data.

The Purpose of the Group by clause in SQL is, it will help to applying the Aggregation functions to the group of rows of the same kind.
Ex: Select Customer_numb from Orders group by customers;

------Describe the role of the SQL HAVING clause. How is it different from the WHERE clause, and in what scenarios would you use HAVING?
Having clause is used for the group by functions, where it helps in defining filters on the grouped query based on the aggregation function.
Where clause is used to filter specific rows based on certain condition while having clause is used to filter group of rows where the query based on conditions involving aggregated values.

-----In the context of the 'Orders' table, what is a primary key, and why is it important?

In orders table the primary key is used for order_numb where the primary key does not allows the duplicate values in rows in the table. It has different unique values for each row in the table.


------Write an SQL query to find the customer who placed the earliest order based on the 'order_date' in the 'Orders' table.

 Select  min(order_date) from orders;


-------Explain the concept of indexing in databases. How can it optimize query performance, and when would you consider adding an index to a table

 Indexing  helps us to retrieve the data from table .
With proper index in place, the database system can then first go through the index to find out where to retrieve the data, and then go to these locations directly to get the needed data
