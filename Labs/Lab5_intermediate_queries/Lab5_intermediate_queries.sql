/*13.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case you know that you will be temporarily in his position.
Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).*/

delete from Dependent
where essn =223344

update Departments
set MGRSSN =102672
where MGRSSN=223344

update Employee
set Superssn =102672
where Superssn=223344

update Works_for
set ESSn =102672
where ESSn=223344

delete from Employee
where SSN=223344
--Part-1: Use ITI DB
--1.Retrieve number of students who have a value in their age. 
select * 
from Student s
 where s.St_Age is not null

 --2.Get all instructors Names without repetition
 select distinct Ins_Name
 from Instructor

/* 3.Display student with the following Format (use isNull function)
Student ID	Student Full Name	Department name*/
select 
	s.St_Id,
	isnull(s.St_Fname,'*') +' '+isnull(s.St_Lname,'*') as 'full name',
	isnull(d.Dept_Name,'Unknown')
from Student s
left join Department d 
on s.Dept_Id=d.Dept_Id

/*4.Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not*/

select 
	i.Ins_Name,
	d.Dept_Name
from Instructor i
left join Department d
on i.Dept_Id=d.Dept_Id

/*5.Display student full name and the name of the course he is taking
For only courses which have a grade  */	
select 
	concat(s.St_Fname,' ',s.St_Lname),
	u.Crs_Name
from Student s 
left join Stud_Course c
on s.St_Id=c.St_Id
left join Course u
on c.Crs_Id=u.Crs_Id
where c.Grade is not null

--6.Display number of courses for each topic name
select 
	t.Top_Name,
	count(c.Crs_Id) as 'no_of_courses'
from Topic t
left join Course c
on t.Top_Id=c.Top_Id
group by t.Top_Name

--7.Display max and min salary for instructors
select 
	max(Salary),
	min(salary)
from Instructor

--8.Display instructors who have salaries less than the average salary of all instructors.
select *
from Instructor
where Salary < (select avg(isnull(salary,0))from instructor)

--9.Display the Department name that contains the instructor who receives the minimum salary.
select 
	d.Dept_Name
from Department d
left join Instructor i
on d.Dept_Id=i.Dept_Id
where i.Salary=(select min(Salary) from Instructor)

--10.Select max two salaries in instructor table. 
select Top(2) salary
from Instructor
order by Salary desc

--11.Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
select 
	Ins_Name,
	coalesce(convert(varchar(10),Salary),'instructor bonus')
from Instructor

--12.Select Average Salary for instructors 
select avg(isnull(salary,0))
from instructor

--13.Select Student first name and the data of his supervisor 
select 
	s1.St_Fname,
	s2.*
from Student s1
left join Student s2
on s1.St_super=s2.St_Id
where s1.St_super  is not null

--14.Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
select  *
from
(select  salary ,Dept_Id
,rank() over (partition by dept_id order by salary desc) g1
from instructor)i
where Salary is not null and g1 in (1,2)

--15.Write a query to select a random  student from each department.  “using one of Ranking Functions”*/
select *
from
(select *
,row_number () over (partition by dept_id order by newid()) as s1
from Student)t
where s1=1

--Part-2: Use AdventureWorks DB

--1.Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
select 
	SalesOrderID,
	ShipDate 
from Sales.SalesOrderHeader
where ShipDate between '7/28/2002' and '7/29/2014'

--2.Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select 
	ProductID,
	Name
from Production.Product 
where StandardCost<110

--3.Display ProductID, Name if its weight is unknown
select 
	ProductID,
	Name
from Production.Product 
where Weight is null

--4.Display all Products with a Silver, Black, or Red Color
select *
from Production.Product 
where Color in ('Silver', 'Black', 'Red')

--5.Display any Product with a Name starting with the letter B
select *
from Production.Product 
where LEFT(name,1)='B'

/*6.Run the following Query
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3
Then write a query that displays any Product description with underscore value in its description.*/

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select *
from Production.ProductDescription
where Description like '%[_]%'

--7.Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'
select
	sum(TotalDue),
	OrderDate
from Sales.SalesOrderHeader
group by OrderDate
having OrderDate between '7/1/2001' and '7/31/2014'

--8.Display the Employees HireDate (note no repeated values are allowed)
select 
	distinct HireDate
from HumanResources.Employee
order by HireDate 

--9.Calculate the average of the unique ListPrices in the Product table
select avg(distinct ListPrice)
from Production.Product

--10.Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
select 'The '+ name + ' is only! ' + convert(varchar(10),ListPrice)
from Production.Product
where ListPrice between 100 and 120
order by ListPrice

/*11.	
a)Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive]
Note: Check your database to see the new table and how many rows in it?
b)Try the previous query but without transferring the data? */

select 
	rowguid,
	Name,
	SalesPersonID,
	Demographics into store_Archive
from Sales.Store

--12.Using union statement, retrieve the today’s date in different styles using convert or format funtion.
-- Style 101: mm/dd/yyyy
SELECT CONVERT(VARCHAR, GETDATE(), 101) AS FormattedDate

UNION

-- Style 103: dd/mm/yyyy
SELECT CONVERT(VARCHAR, GETDATE(), 103)

UNION

-- Style 112: yyyymmdd
SELECT CONVERT(VARCHAR, GETDATE(), 112)

UNION

-- Custom format using FORMAT
SELECT FORMAT(GETDATE(), 'dddd, MMMM dd, yyyy')



