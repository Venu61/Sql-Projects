use project;
create table customers(customer_id int primary key,name varchar(100),email varchar(100),phone varchar(20),address varchar(255));
insert into customers(customer_id,name,email,phone,address) values(1,'john smith','john.smith@example.com','123-456-7890','123 main st,anytown,usa'),
(2,'alice brown','alice.brown@example.com','987-654-3210','456 oak st,anycity,usa'),
(3,'bob johnson','bob.johnson@example.com','555-123-4567','789 elm st,anyville,usa'),
(4,'emily davis','emily.davis@example.com','111-222-3333','456 maple st,anothercity,usa'),
(5,'michael wilson','michael.wilson@example.com','444-555-6666','789 pine st,anothertown,usa');

select * from customers;

create table Books(book_id int primary key,title nvarchar(100),author varchar(225),genre varchar(50),price decimal(10,2),quantity_avaliable int);
insert into Books(book_id,title,author,genre,price,quantity_avaliable) values(1,'To kill a mockingbird','Harper Lee','Fiction','15.99',50),
(2,'1984','george orwell','Fiction','12.99',30),
(3,'the great gatsby','F.scott fitzgerlad','Fiction','10.99',40),
(4,'pride and prejudice','jane austen','Romance','11.99',25),
(5,'the catcher in the rye','j.d.salinger','Fiction','14.49',20),
(6,'animal farm','george orwell','Fiction','11.49',35),
(7,'lord of the flies','william golding','Fiction','13.99',15),
(8,'1984','george orwell','Fiction','12.99',30),
(9,'romeo and juilet','william shakespeare','Romance','9.99',40),
(10,'the hobbit','j.r.r.tolkien','Fantasy','16.99',60);

select * from Books;

create table orders (order_id int primary key ,customer_id int,order_date date,total_amount decimal(10,2)
FOREIGN KEY(customer_id) REFERENCES customers(customer_id) );
insert into orders(order_id,customer_id,order_date,total_amount) values
(101,1,'2024-02-15',31.98),
(102,2,'2024-02-15',23.98),
(103,3,'2024-02-15',31.47),
(104,4,'2024-02-15',40.97),
(105,5,'2024-02-15',37.47),
(106,1,'2024-02-16',50.97),
(107,2,'2024-02-16',28.98),
(108,3,'2024-02-16',32.47),
(109,4,'2024-02-16',45.97),
(110,5,'2024-02-16',49.47);
select * from orders;

create table order_item(order_item_id int primary key,order_id int,book_id int,quantity int,subtotal decimal(10,2),
 FOREIGN KEY(order_id) References orders(order_id),
 FOREIGN KEY(book_id) References books(book_id));
insert into order_item(order_item_id,order_id,book_id,quantity,subtotal) values(1,101,1,2,'31.98'),
(2,102,2,1,'12.99'),
(3,102,3,1,'10.99'),
(4,103,4,1,'11.99'),
(5,103,5,3,'29.97'),
(6,104,6,2,'22.98'),
(7,104,7,1,'13.99'),
(8,105,8,2,'25.98'),
(9,105,9,1,'9.99'),
(10,106,10,3,'50.97');

select * from order_item;
select * from customers;
select * from orders;
select * from Books;

---Retrieve the total number of books available in the inventory.

SELECT SUM(quantity_avaliable) AS total_books_available FROM Books;


--List all books priced between $10 and $20.

SELECT * FROM Books WHERE price BETWEEN 10 AND 20;


---Display the top 10 bestselling books based on the number of copies sold.

SELECT Books.title, SUM(oi.quantity) AS total_sold FROM Books 
 INNER  JOIN order_item oi ON Books.book_id = oi.book_id
GROUP BY Books.title
ORDER BY total_sold DESC;

----Find the total revenue generated from book sales in the past month.

SELECT SUM(order_item.subtotal) AS total_revenue FROM order_item 
 INNER JOIN orders  ON order_item.order_id = orders.order_id
WHERE YEAR(orders.order_date) = 2024
  AND MONTH(orders.order_date) = 2;


---List all customers who have placed orders in the last three months.


SELECT DISTINCT customer_id
FROM Orders
WHERE order_date >= DATEADD(MONTH, -3, GETDATE());

---Update the price of a specific book.
 
 update Books set price = 100 where book_id=5; 
 select * from Books;

 ---Remove a book from the inventory.

 DELETE from Books where book_id = 5;

 ---Find the total number of orders placed by each customer:


SELECT customer_id, COUNT(*) AS TotalOrders
FROM Orders
GROUP BY customer_id;


---Calculate the average order value:

SELECT AVG(total_amount) AS average_order_value FROM orders;

---Display the details of orders containing more than five books.

SELECT * FROM orders
WHERE order_id IN (SELECT order_id FROM order_item GROUP BY order_id
   HAVING COUNT(*) > 5);

---List all books ordered by a specific customer.
SELECT Books.* FROM order_item 
INNER JOIN books  ON order_item.book_id = Books.book_id
INNER JOIN orders  ON order_item.order_id = orders.order_id
WHERE orders.customer_id = 1;

---Identify customers who have not placed any orders.

SELECT * FROM customers 
LEFT JOIN orders  ON customers.customer_id = orders.customer_id
WHERE orders.order_id IS NULL;

---Retrieve the latest order for each customer.

SELECT * FROM orders o
 LEFT JOIN (SELECT customer_id, MAX(order_date) AS latest_order_date FROM orders GROUP BY customer_id) 
 latest ON o.customer_id = latest.customer_id AND o.order_date = latest.latest_order_date;

---Calculate the total number of books sold in each genre.

SELECT genre, SUM(quantity) AS total_sold FROM order_item oi
JOIN Books b ON oi.book_id = b.book_id
GROUP BY genre;

---Find the bestselling author based on total book sales.

SELECT  top 1 author, SUM(quantity) AS total_books_sold FROM order_item oi
JOIN books b ON oi.book_id = b.book_id
GROUP BY author
ORDER BY total_books_sold DESC;


---Display the oldest and newest books in the inventory.

-- Oldest book
SELECT TOP 1 * FROM Books
ORDER BY book_id;

-- Newest book
SELECT TOP 1 * FROM Books
ORDER BY book_id DESC;

---List all customers who reside in a particular city.

SELECT *
FROM customers
WHERE address LIKE '%anycity%';


---Retrieve orders placed on a specific date.

SELECT *
FROM orders
WHERE order_date = '2024-02-15';

---Find the average price of books in each genre.

SELECT genre, AVG(price) AS average_price
FROM Books
GROUP BY genre;

---Identify duplicate entries in the Books table.

SELECT title, author, COUNT(*) FROM Books
GROUP BY title, author
HAVING COUNT(*) > 1;

---Retrieve the most recent orders.

SELECT TOP 5*
FROM orders
ORDER BY order_date DESC;

---Calculate the total number of books sold each month.

SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(quantity) AS total_books_sold
FROM orders
INNER JOIN order_item ON orders.order_id = order_item.order_id
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

---Display the top 5 customers with the highest total order amount

SELECT TOP 5 c.customer_id, SUM(o.total_amount) AS total_order_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_order_amount DESC;

---List all books with a quantity available less than 10.

SELECT * FROM Books
WHERE quantity_avaliable<10;

---Find orders with a total amount exceeding $100.

SELECT * FROM orders WHERE total_amount > 100;


---Retrieve orders placed by a specific customer in the last week.

SELECT * FROM orders WHERE customer_id = (SELECT customer_id FROM customers WHERE name = 'John Smith') AND order_date >= DATEADD(WEEK, -1, GETDATE());

---Display the distribution of orders by month.

SELECT YEAR(order_date) AS order_year,MONTH(order_date) AS order_month,COUNT(*) AS order_count FROM  orders
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY order_year,order_month;


---Calculate the total revenue generated by each genre.

SELECT genre,SUM(total_amount) AS total_revenue FROM orders o
INNER JOIN order_item oi ON o.order_id = oi.order_id
INNER JOIN Books b ON oi.book_id = b.book_id
GROUP BY genre;


----List all customers who have spent more than $500 in total.

SELECT  c.customer_id,c.name,SUM(o.total_amount) AS total_spent FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(o.total_amount) > 500;

----Find the customer who placed the earliest order.

SELECT TOP 1 c.customer_id, c.name, MIN(o.order_date) AS earliest_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY earliest_order_date;

---Display the average order value per month.

SELECT YEAR(order_date) AS year,
       MONTH(order_date) AS month,
       AVG(total_amount) AS average_order_value
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

---Retrieve orders containing a specific book.

SELECT o.order_id, o.customer_id, o.order_date, o.total_amount FROM orders o
 INNER JOIN order_item oi ON o.order_id = oi.order_id
INNER JOIN Books b ON oi.book_id = b.book_id
WHERE b.title = 'To kill a mockingbird';

---Identify books that have never been ordered.

SELECT * FROM Books WHERE book_id NOT IN ( SELECT DISTINCT book_id FROM order_item);

---Calculate the total number of orders placed each year.

SELECT YEAR(order_date) AS year, COUNT(*) AS total_orders FROM orders
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

---Find the total revenue generated by each customer.

SELECT customers.customer_id, customers.name, SUM(orders.total_amount) AS total_revenue FROM customers 
INNER JOIN orders  ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name
ORDER BY total_revenue DESC;


---Display the distribution of book prices.

SELECT  COUNT(*)  as bookprices FROM  Books 
ORDER BY  MIN(price);

---List all orders containing books authored by a specific author.

SELECT DISTINCT orders.* FROM orders 
LEFT  JOIN order_item  ON orders.order_id = order_item.order_id
LEFT JOIN Books  ON order_item.book_id = Books.book_id
WHERE Books.author = 'george orwell';


---Retrieve orders placed within a specific time range.

SELECT * FROM orders
WHERE order_date BETWEEN '2024-02-15' AND '2024-02-16';

---Calculate the percentage of orders containing multiple books.

SELECT COUNT(*)  AS PERCENTAGEOFORDERS FROM order_item ;

---Find the customer who has placed the most orders.

SELECT TOP 1 customers.customer_id,customers.name,COUNT(orders.order_id) AS total_orders FROM customers 
INNER JOIN orders  ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name
ORDER BY  total_orders DESC;

---Find the customer who has placed the most orders.

SELECT TOP 1 customers.customer_id, customers.name, COUNT(orders.order_id) AS num_orders
FROM customers 
JOIN orders  ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name
ORDER BY num_orders DESC;

---Display the total number of books sold each day.

SELECT o.order_date, SUM(oi.quantity) AS total_books_sold
FROM orders o
JOIN order_item oi ON o.order_id = oi.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

---List all customers who have placed orders for books in a specific genre.

SELECT DISTINCT c.customer_id, c.name
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_item oi ON o.order_id = oi.order_id
INNER JOIN books b ON oi.book_id = b.book_id
WHERE b.genre = 'Fiction';

---Retrieve orders with a total amount within a certain range.

SELECT *
FROM orders
WHERE total_amount BETWEEN 20.00 AND 40.00;

---Find the book with the highest price.

SELECT * FROM Books WHERE price = (SELECT MAX(price) FROM Books);

---Calculate the average quantity of books ordered per customer.

SELECT AVG(total_quantity) AS average_quantity_per_customer FROM (
    SELECT c.customer_id, SUM(oi.quantity) AS total_quantity
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_item oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id
) AS customer_orders;



SELECT AVG(total_amount) AS average_quantity_per_customer FROM orders;


---Identify customers who have placed orders for the same book multiple times.

SELECT order_id
FROM order_item
GROUP BY order_id, book_id
HAVING COUNT(*) > 1;


---Retrieve orders containing books priced above the average price.

SELECT orders.* FROM orders 
INNER JOIN order_item oi ON orders.order_id = oi.order_id
INNER JOIN books b ON oi.book_id = b.book_id
WHERE b.price > (SELECT AVG(price) FROM books);

---Display the total number of orders placed on weekdays vs. weekends.

SELECT COUNT(*) AS num_orders
FROM orders
GROUP BY CASE WHEN DATEPART(WEEKDAY, order_date) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END;

---Find the customer who has ordered the most expensive book.

SELECT top 1 customers.customer_id, customers.name FROM customers 
JOIN orders o ON customers.customer_id = o.customer_id
JOIN order_item oi ON o.order_id = oi.order_id
JOIN books b ON oi.book_id = b.book_id
ORDER BY b.price DESC;

---Retrieve orders containing books published in a specific year.

SELECT orders.*
FROM orders 
JOIN order_item oi ON orders.order_id = oi.order_id
JOIN books b ON oi.book_id = b.book_id
WHERE b.title LIKE '2024';


---Find the total number of unique customers who have placed orders.

SELECT COUNT(DISTINCT customer_id) AS total_unique_customers
FROM orders;

---Retrieve orders with a total amount less than $50.

SELECT * FROM orders WHERE total_amount < 50.00;

---Display the top 10 customers who have purchased the most books.

SELECT TOP 10 customers.customer_id, customers.name, COUNT(order_item.order_item_id) AS num_books_purchased
FROM customers 
INNER JOIN orders  ON customers.customer_id = orders.customer_id
INNER JOIN order_item  ON orders.order_id = order_item.order_id
GROUP BY customers.customer_id, customers.name
ORDER BY num_books_purchased DESC;


---List all books ordered in descending order of their price.

SELECT * FROM books ORDER BY price DESC;

---Calculate the total revenue generated from book sales in the past year.

SELECT SUM(total_amount) AS total_revenue FROM orders
WHERE order_date >= DATEADD(YEAR, -1, GETDATE());


---Find the total number of orders placed on each day of the week.

SELECT DATEPART(WEEKDAY, order_date) AS day_of_week, COUNT(*) AS num_orders FROM orders
GROUP BY DATEPART(WEEKDAY, order_date);


---Retrieve orders containing books with titles containing a specific keyword.

SELECT orders.* FROM orders 
JOIN order_item ON orders.order_id = order_item.order_id
JOIN books b ON order_item.book_id = b.book_id
WHERE b.title LIKE '%1984%';

----Identify customers who have placed orders in consecutive months

SELECT DISTINCT customers.customer_id FROM   orders
INNER JOIN orders o2  ON orders.customer_id = orders.customer_id 
INNER JOIN customers  ON orders.customer_id = customers.customer_id
ORDER BY customers.customer_id;


---Calculate the total profit margin (revenue minus cost) for each book.

SELECT Books.book_id,Books.title,SUM((order_item.quantity * Books.price) - (order_item.quantity * Books.price)) AS profit_margin FROM Books 
INNER JOIN order_item  ON Books.book_id = order_item.book_id
GROUP BY Books.book_id, Books.title;

---List all customers who have placed orders for books of multiple genres.

SELECT DISTINCT customers.customer_id, customers.name FROM customers 
INNER JOIN orders  ON customers.customer_id = orders.customer_id
INNER JOIN order_item  ON orders.order_id = order_item.order_id
INNER JOIN Books  ON order_item.book_id = Books.book_id
GROUP BY customers.customer_id, customers.name
HAVING COUNT(DISTINCT Books.genre) > 1;


---Find orders with a total amount less than the average order value.

SELECT * FROM orders
WHERE total_amount < (SELECT AVG(total_amount) FROM orders);

---Retrieve the oldest order placed by each customer.
SELECT customer_id, MIN(order_date) AS oldest_order_date FROM orders
GROUP BY customer_id;

---Display the distribution of book prices within each genre.
SELECT genre, MIN(price) AS min_price FROM books
GROUP BY genre;

SELECT genre, MAX(price) AS min_price FROM books
GROUP BY genre;
  
SELECT genre, AVG(price) AS min_price FROM books
GROUP BY genre;

SELECT genre, COUNT(price) AS min_price FROM books
GROUP BY genre;       


---Calculate the total quantity of each book sold.

SELECT book_id, SUM(quantity) AS total_quantity_sold FROM order_item
GROUP BY book_id;
      
---List all customers who have placed orders for books authored by a specific author.

SELECT DISTINCT customers.customer_id, customers.name FROM customers 
INNER JOIN orders  ON customers.customer_id = orders.customer_id
INNER JOIN books  ON orders.customer_id= Books.book_id
WHERE Books.author = 'George Orwell';

---Find the total number of orders placed in each city.

SELECT address, COUNT(*) AS total_orders FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY address;

---Retrieve orders containing books with prices ending in ".99".

SELECT * FROM orders
WHERE order_id IN (SELECT book_id FROM books WHERE price LIKE '99');

---Identify customers who have placed orders for books published in a specific decade.

SELECT DISTINCT c.customer_id, c.name FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN books b ON o.order_id= b.book_id
WHERE b.title = 'To Kill a Mockingbird';

---Calculate the average number of books ordered per order.

SELECT AVG(books_ordered) AS average_books_ordered_per_order FROM (SELECT COUNT(*) AS books_ordered FROM orders 
GROUP BY order_id) AS order_books;

---Retrieve orders placed by customers who have not provided their phone numbers.


ALTER TABLE customers
ADD phone_number VARCHAR(20); 
SELECT * FROM customers;

SELECT orders.* FROM orders 
LEFT JOIN customers  ON orders.customer_id = customers.customer_id
WHERE customers.phone_number IS NULL;

















