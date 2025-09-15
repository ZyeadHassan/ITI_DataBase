create database Lab8
create table Daily_Transactions
(
UsreID int,
Transaction_amount int
)


create table Last_Transactions
(
UsreID int,
Transaction_amount int
)

Merge into [dbo].[Last_Transactions] as l
using [dbo].[Daily_Transactions] as d
On d.[UsreID]=l.[UsreID]

When matched then
update set l.Transaction_amount=l.Transaction_amount+d.Transaction_amount

When not matched by target Then 
insert(UsreID,Transaction_amount)
values(d.UsreID,d.Transaction_amount);
--...................................................................
SELECT
	St_Fname+' '+St_Lname FullName,
	crs_name,
	Grade,
	LAG(St_Fname) OVER(PARTITION BY crs_name ORDER BY GRADE) prev ,
	LEAD(st_Fname) OVER(PARTITION BY crs_name ORDER BY GRADE) upcoming
FROM Student s
join Stud_Course sc
on s.St_Id=sc.St_Id
join Course c
on c.Crs_Id=sc.Crs_Id
--..............................................................
--1.Create a scalar function that takes date and returns Month name of that date.
GO
CREATE FUNCTION get_month(@n Date) 
RETURNS VARCHAR(20)
AS
	BEGIN
	DECLARE @s VARCHAR(20)
	SET @s = (SELECT FORMAT(@n ,'MMMM') AS MonthName)
	
	RETURN @s
	END

select 
	d.Dept_Name,
	d.Dept_Manager,
	d.Manager_hiredate,
	dbo.get_month(Manager_hiredate) as 'hiring month'
from Department d

select dbo.get_month('2025-10-10')
--.....................................................
--2.Create a multi-statements table-valued function that takes 2 integers and returns the Even values between them.
alter FUNCTION getEven(@x int,@y int)
RETURNS @t TABLE (
	Even_value int
	)
AS 

BEGIN
	declare @i int
	--makesure x<y
	if @x>@y
	begin
	declare @z int

	set @x=@z
	set @x=@y
	set @y=@z
	end

	set @i=@x
	while @i<=@y
	begin
	IF @i%2 = 0
		INSERT INTO @t 
		values(@i)
		set @i=@i+1
	end
	RETURN;
END

select *
from dbo.getEven(2,11)

--3.Create inline function that takes Student No and returns Department Name with Student full name.
CREATE FUNCTION get_dep_stu(@sno int)
RETURNS TABLE
AS RETURN 
(
	SELECT 
		St_Fname+' '+St_Lname 'Full Name',
		Dept_Name 'Department Name'	
	FROM student s, Department d
	WHERE s.Dept_Id = d.Dept_Id AND St_Id = @sno
)

SELECT *
FROM dbo.get_dep_stu(1)

/*4.Create a scalar function that takes Student ID and returns a message to user 
a.If first name and Last name are null then display 'First name & last name are null'
b.If First name is null then display 'first name is null'
c.If Last name is null then display 'last name is null'
d.Else display 'First name & last name are not null'*/

CREATE FUNCTION get_message(@sid INT) 
RETURNS VARCHAR(100)
AS
	BEGIN
	DECLARE @message VARCHAR(100)
	DECLARE @f VARCHAR(20)
	DECLARE @l VARCHAR(20)
	SET @f = (SELECT St_Fname FROM Student WHERE St_id = @sid)
	SET @l = (SELECT St_Lname FROM Student WHERE St_id = @sid)

	IF @f  IS NULL and @l is null
		SET @message = 'First name & last name are null'
	ELSE IF @f  IS NULL and @l is not null
		SET @message = 'first name is null'
	ELSE IF @f  IS not NULL and @l is null
		SET @message = 'last name is null'
	ELSE
		SET @message = 'First name & last name are not null'

	RETURN @message
	END

select dbo.get_message(1)
select dbo.get_message(13)
select dbo.get_message(14)

--5.Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
alter FUNCTION getManager(@Mid int)
RETURNS TABLE
AS RETURN 
(
	SELECT 
		d.Dept_Name 'department name',
		i.Ins_Name 'Manager Name',
		d.Manager_hiredate 'hiring date'
	FROM Instructor i, Department d
	WHERE i.Ins_Id= d.Dept_Manager AND d.Dept_Manager = @Mid

)

SELECT *
FROM dbo.getManager(3)

/*6.Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use “ISNULL” function*/

alter FUNCTION getName(@name VARCHAR(20))
RETURNS @t TABLE (
	st_name varchar(20)

	)
AS 
BEGIN
	IF @name = 'first name'
		INSERT INTO @t
		SELECT St_Fname
		FROM Student
	ELSE IF @name = 'last name'
		INSERT INTO @t
		SELECT  St_Lname
		FROM Student
	ELSE IF @name = 'full name'
		INSERT INTO @t
		SELECT  St_Fname+' '+St_Lname
		FROM Student
	ELSE
		INSERT INTO @t values (null)
	RETURN;
END



SELECT *
FROM dbo.getName('first name')

SELECT *
FROM dbo.getName('full name')

SELECT *
FROM dbo.getName('name')





