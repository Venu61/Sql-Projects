use assigment;

-----Create a table named "Students" with columns for ID, Name, Age, and GPA.

drop table students;
create table students(ID int primary key,Name varchar(50),Age int,Gpa decimal(10,2));

----Insert at least five records into the "Students" table.

INSERT INTO students(ID,Name,Age,Gpa)
 VALUES(1,'venu',21,'9.0'),
       (2,'dinesh',20,'9.4'),
	   (3,'vijay',18,'9.8'),
	   (4,'mohan',22,'9.5'),
	   (5,'vamsi',19,'9.0');

select * from students;

--------Write a SQL query to retrieve all columns for students with a GPA greater than 3.5.

select * from students where Gpa > 3.5;

------Select the names and ages of students with an age less than 20.

select Name,Age from students where Age < 20;

-----Retrieve the top 3 students with the highest GPAs.

SELECT TOP 3 name,age from students order by Gpa desc;

-- List the names and ages of students in ascending order of age

SELECT name, age FROM Students ORDER BY age ASC;

---Create a second table named "Courses" with columns for CourseID, CourseName, and StudentID.


create table course(courseID int primary key,coursename varchar(100),ID int, FOREIGN KEY(ID) references students(ID));

 insert into course(courseID,coursename,ID)  
   values (001,'mathematics',1),
          (002,'science',2),
		  (003,'social',3);

 select * from course;

 -----Write a query to retrieve the names of students and the courses they are enrolled in using INNER JOIN.

 select students.Name,course.coursename from students inner join course ON course.ID=students.ID;

 ------Retrieve a list of all students and the courses they are enrolled in, even if they are not enrolled in any course (use LEFT JOIN).

 select students.Name,course.coursename,'not enrolled'as enrolled_corse from students left join course ON course.ID=students.ID;

 -----Group students by age and count the number of students in each age group.
 
 select Age,COUNT(*) as number_students from students group by Age ;

 -----Find the number of courses each student is enrolled in.

  select students.ID,COUNT(course.courseID) as enrolled_course from students left join course ON students.ID=course.ID group by  students.ID;
 

 ----Calculate the average GPA for all students.

 select AVG(Gpa) from students;

 -----Determine the maximum age among all students.

 select MAX(age) from students;


 ---Write a subquery to find students with GPAs above the average GPA.

SELECT ID FROM students WHERE Gpa > (SELECT AVG(Gpa) FROM students);

----Retrieve courses with more than 3 enrolled students using a subquery.

SELECT *
FROM course
WHERE courseID IN (SELECT ID FROM students GROUP BY ID HAVING COUNT(*) > 3);
