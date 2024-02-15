create database project1;
use project1;
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    name VARCHAR(255),
    contact_number VARCHAR(12), -- Assuming ###-###-#### format
    email VARCHAR(255)
);

insert into Passengers(passenger_id , name, contact_number,email) values(1,'john Doe','123-456-7890','john.doe@example.com'),
(2,'jane Smith','987-654-3210','jane.smith@example.com'),
(3,'Michael Brown','555-123-4567','michael.brown@example.com'),
(4,'Emily johnson','222-333-4444','emily.johnson@example.com'),
(5,'David wilson','999-888-7777','david.wilson@example.com'),
(6,'sarah lee','777-666-5555','sarah.lee@example.com'),
(7,'james miller','111-222-3333','james.miller@example.com'),
(8,'lisa taylor','444-555-6666','lia.taylor@example.com'),
(9,'Robert Anderson','777-888-9999','Robert.Anderson@example.com'),
(10,'Oliva Martinez','666-555-4444','Oliva.Matinez@example.com');


select * from Passengers;

create table BusFares( fare_id int primary key , fare_type varchar(100), price Decimal(10,2), discounts nvarchar(100)); 
insert into BusFares(fare_id,fare_type,price,discounts) values(1,'sitting','50.00','10% off for senoirs'),
(2,'sleeper','100.00','20% off for students');

select * from BusFares;

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    fare_id INT,
    seat_number INT,
    payment_status VARCHAR(20),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (fare_id) REFERENCES BusFares(fare_id),
    CONSTRAINT unique_seat_per_booking UNIQUE (booking_id, seat_number),
    CONSTRAINT valid_payment_status CHECK (payment_status IN ('Paid', 'Pending'))
);

insert into Bookings( booking_id, passenger_id, fare_id, seat_number, payment_status) values(1,1,1,10,'paid'),
(2,2,1,15,'pending'),
(3,3,2,5,'paid'),
(4,4,2,12,'paid'),
(5,5,1,8,'pending'),
(6,6,1,20,'paid'),
(7,7,2,3,'paid'),
(8,8,1,16,'pending'),
(9,9,2,7,'paid'),
(10,10,1,4,'pending');

select * from Bookings;
select * from Passengers;
select * from BusFares;

---1.  Retrieve all passengers who have pending bookings.

select Passengers.name from Passengers inner join Bookings ON Passengers.passenger_id=Bookings.passenger_id where payment_status='pending';

---2. Retrieve the total number of bookings made for each fare type.

select fare_id,COUNT(*) as total_bookings
from Bookings  group by fare_id;

----3.   Update the payment status for a booking_id=2.

update  Bookings set payment_status='paid' where booking_id=2;
select * from Bookings;

----4. Retrieve the total revenue generated from all bookings.

select SUM(fare_id) as total_revenue from Bookings where payment_status='paid';
select SUM(fare_id) as total_revenue from Bookings where payment_status='pending';

----5.    Retrieve the passengers with bookings for a fare type=sitting.

SELECT passengers.*
FROM passengers
JOIN bookings ON passengers.passenger_id = bookings.passenger_id
WHERE bookings.fare_id=1;

----6. Delete a booking for a  passenger_id=3.

delete from Bookings where passenger_id=3;
select * from Bookings;

----7.    Retrieve all bookings along with passenger details and fare information.

select Bookings.booking_id,
Passengers.passenger_id,
BusFares.fare_type,
BusFares.price,
Bookings.seat_number,
Bookings.payment_status
 from Bookings   inner join  Passengers ON Bookings.passenger_id=Passengers.passenger_id
     inner join BusFares ON Bookings.fare_id=BusFares.fare_id;

------8. Retrieve the total number of bookings made by a passenger id =2.
   
   select COUNT(*) as total_bookings
   from Bookings  where passenger_id=2;

----9. Retrieve the passengers who have booked a specific seat number =10.

SELECT passengers.* FROM passengers inner JOIN bookings ON passengers.passenger_id = bookings.passenger_id
   WHERE bookings.seat_number = 10;

----10.Retrieve the fare details for a  booking id=9.

SELECT BusFares.*
FROM BusFares
JOIN bookings ON BusFares.fare_id = bookings.fare_id
WHERE bookings.booking_id = 9;

----11. Retrieve the average fare price for each fare type.

SELECT fare_type, AVG(price) AS average_price
FROM BusFares
GROUP BY fare_type;

----12.Retrieve the passengers who have booked more than one seat.

SELECT Passengers.*
FROM passengers
 inner JOIN (
    SELECT passenger_id
    FROM bookings
    GROUP BY passenger_id
    HAVING COUNT(*) > 1
)AS bookings ON passengers.passenger_id = Bookings.passenger_id;

----13.Retrieve the fare types along with the count of bookings made for each type.

SELECT fare_id, COUNT(*) AS booking_count
FROM Bookings
GROUP BY fare_id;

----14.Retrieve the passengers who have booked a seat number within a range 1    and 10.

select * from Bookings  where seat_number  Between 1 and 10;

----15.Retrieve the passengers who have not yet paid for their bookings.

SELECT * FROM passengers
WHERE passenger_id IN (
    SELECT booking_id 
	FROM Bookings
    WHERE payment_status = 'unpaid'
);