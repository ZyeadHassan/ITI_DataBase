/*1.Display the Department id, name and id and the name of its manager.*/
select 
	d.Dnum,
	d.Dname,
	d.MGRSSN,
	e.Fname + ' '+e.Lname as 'manager name'
from departments as d
left join employee as e
on d.mgrssn = e.SSN

/*2.Display the name of the departments and the name of the projects under its control.*/
select 
	d.Dname,
	p.Pname
from departments as d
left join Project as p
on d.Dnum=p.Dnum

/*3.Display the full data about all the dependence associated with the name of the employee they depend on him/her.*/
select 
	d.*,
	e.Fname + ' '+e.Lname as 'employee name'
from Dependent as d
left join Employee as e
on d.ESSN=e.SSN

/*4.Display the Id, name and location of the projects in Cairo or Alex city.*/
select *
from project 
where city in ('Cairo' ,'Alex')

/*5.Display the Projects full data of the projects with a name starts with "a" letter.*/
select *
from Project
where Project.Pname like 'a%'	

/*6.display all the employees in department 30 whose salary from 1000 to 2000 LE monthly*/
select * 
from employee as e
where e.Dno=30 and e.Salary between 1000 and 2000				

/*7.Retrieve the names of all employees in department 10 who works more than or equal 10 hours per week on "AL Rabwah" project.*/
select 
	e.Fname + ' '+e.Lname as 'employee name'
from project as p
left join Works_for as w
on p.Pnumber=w.Pno
left join Employee as e
on e.SSN=w.ESSn
where p.Dnum = 10 and p.Pname='AL Rabwah' and w.Hours>=10

/*8.Find the names of the employees who directly supervised with Kamel Mohamed.*/
select 
	e.Fname ,
	e.Lname
from employee e 
inner join employee s
on s.SSN = e.Superssn
where s.Fname='Kamel' and s.Lname= 'Mohamed' 

/*9.Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.*/
select 
	  e.Fname+' '+e.Lname as 'employee name',
	  p.Pname
from Works_for as w
left join Project as p
on p.Pnumber=w.Pno
left join Employee as e
on e.SSN=w.ESSn
order by  p.Pname


/*10.For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.*/
select 
	p.Pname,
	d.Dname,
	e.Lname,
	e.Address,
	e.Bdate
from Employee as e
left join Departments as d
on e.SSN=d.MGRSSN
left join Project as p
on p.Dnum=d.Dnum
where p.City ='Cairo'

/*11.Display All Data of the managers*/
select * 
from Employee as e
left join Departments as d
on e.SSN=d.MGRSSN
where d.MGRSSN is not null

/*12.Display All Employees data and the data of their dependents even if they have no dependents*/
select 
	e.*,
	d.*
from Employee as e
left join Dependent as d
on e.SSN=d.ESSN
