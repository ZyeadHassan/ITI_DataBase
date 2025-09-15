--13.Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
Insert into Employee
values ('Zyead','Hassan',102672,10-15-1999,'Zagazig,Sharkia','M',3000,112233,30)

update employee
set bdate='1999-10-15'
where fname='Zyead'


--14.Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
Insert into Employee
values ('Mostafa','Ibrahim',102660,'2000-6-3','Zagazig,Sharkia','M',Null,Null,30)

--15.Upgrade your salary by 20 % of its last value.
update Employee
set Salary = Salary*1.2
where SSN=102672

/*1.Display (Using Union Function)
a.The name and the gender of the dependence that's gender is Female and depending on Female Employee.
b.And the male dependence that depends on Male Employee.*/
select 
	d.Dependent_name,
	d.Sex
from Dependent as d
left join Employee as e 
on d.ESSN=e.SSN
where d.Sex = 'f' and e.Sex='f'
union
select 
	d.Dependent_name,
	d.Sex
from Dependent as d
left join Employee as e 
on d.ESSN=e.SSN
where d.Sex = 'm' and e.Sex='m'

--2.For each project, list the project name and the total hours per week (for all employees) spent on that project.
select
	p.Pname,
	sum(w.Hours)
from Project as p
left join Works_for as w
on p.Pnumber=w.Pno
group by p.Pname
order by sum(w.Hours)

--3.Display the data of the department which has the smallest employee ID over all employees' ID.
select *
from Departments as d
left join Employee as e
on d.Dnum=e.Dno
where e.SSN=(select min(ssn) from Employee)

-- 4.For each department, retrieve the department name and the maximum, minimum and average salary of its employees. (Done)
select 
	d.Dname,
	MAX(salary) as max_salary,
	MIN(salary) as min_salary,
	AVG(salary) as avg_salary
from Departments as d
left join Employee as e
on d.Dnum=e.Dno
group by d.Dname

--5.List the full name of all managers who have no dependents. (Done)
select 
	e.Fname +' ' +e.Lname as 'Full name'
from Employee as e
left join Dependent as d
on e.SSN =d.ESSN
left join Departments as p
on e.SSN=p.MGRSSN
where p.MGRSSN not in (select distinct essn from Dependent )

--6.For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select d.Dname,d.Dnum,COUNT(e.ssn) as 'no of employees'
from Departments as d
left join Employee as e
on d.Dnum=e.Dno
group by d.Dname,d.Dnum
having AVG(e.Salary)<any
(select  AVG(salary) from Employee)

--7.Retrieve a list of employees names and the projects names they are working on ordered by department number and within each department, ordered alphabetically by last name, first name.	
select 
	e.Fname+' '+e.Lname as 'Full name',
	p.Pname
from Employee as e
left join Project as p
on e.Dno=p.Dnum
order by e.Dno,e.Lname,e.Fname

--8.Try to get the max 2 salaries using subquery
select Salary
from Employee
where Salary in (select top 2 Salary from Employee order by Salary desc)
order by Salary desc

--9.Get the full name of employees that is similar to any dependent name
select 
	distinct (e.Fname+' '+e.Lname) as 'Full name'
from Employee as e
left join Dependent as d
on e.SSN=d.ESSN
where d.Dependent_name like '%'+e.Fname+'%' or
d.Dependent_name like '%'+e.Lname+'%'

--10.Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select 
	Fname+' '+Lname as 'Full name',
	SSN
from Employee as e 
where EXISTS(select essn from Dependent as d where e.SSN=d.ESSN)

--11.In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
Insert into Departments
values ('DEPT IT',100,112233,'1-11-2006')
	
/*12.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
a.First try to update her record in the department table
b.Update your record to be department 20 manager.
c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)*/
update Departments
set MGRSSN=968574
where Dnum=100

update Departments
set MGRSSN=102672
where Dnum=20

update Employee
set Superssn=102672
where SSN=102660

--14.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%*/
update Employee
set Salary=Salary*1.3
from Employee
join Project on Employee.Dno=Project.Dnum
where Project.Pname='Al Rabwah'












