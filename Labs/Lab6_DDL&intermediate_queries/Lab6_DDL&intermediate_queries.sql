create database lab6

Create table Department (
DeptNO int ,
DeptName varchar(30),
location varchar(30)
)
Alter table Department
Alter column DeptNO varchar(10) not null


Alter table Department
add constraint s_pk primary key (DeptNO)

CREATE RULE location_rule 
AS @Location in ('NY','DS','KW');

sp_bindrule 'location_rule' , 'dbo.Department.location'


Create table Employee (
EmpNO int ,
EmpFname varchar(30),
EmpLname varchar(30),
DeptNo varchar(10),
Salary int
)
Alter table Employee
Alter column EmpNO int not null

Alter table Employee
add constraint E_pk primary key (EmpNO)

Alter table Employee
Add foreign key (DeptNo) references Department(DeptNO)

Alter table Employee
add constraint S_un unique (Salary)

Alter table Employee
Alter column EmpFname varchar(30) not null

Alter table Employee
Alter column EmpLname varchar(30) not null

Create rule salary_range 
as @salary <6000

sp_bindrule 'salary_range','dbo.Employee.salary'

Alter table Works_on
Add foreign key (EmpNo) references Employee(EmpNO)

Alter table Works_on
Add foreign key (ProjectNo) references Project(ProjectNo)

insert into Works_on (EmpNo)
values (11111)                -- cannot insert because of pk

update Works_on 
set EmpNo=11111 
where EmpNo=10102              -- cannot insert because of fk (11111 doesnot exist)

update Employee
set EmpNo=22222
where EmpNo=10102			  -- cannot insert because of fk (10102	 exists in other dependent tables)

delete from Employee 
where EmpNO=10102				-- cannot insert because of fk (10102	 exists in other dependent tables)

Alter table Employee
add Phone varchar(20) 

Alter table Employee
drop column Phone

--2..........................................................
create schema company

alter schema company 
transfer dbo.Department

alter schema company 
transfer dbo.project
--3........................................................
EXEC sp_help 'Human_Resource.Employee'

--4............................................................
create schema Human_Resource 

alter schema Human_Resource 
transfer dbo.Employee

create synonym Emp
for Human_Resource.Employee

Select * from Employee --error
Select * from [Human Resource].Employee --error
Select * from Emp
Select * from [Human Resource].Emp --error
--5...........................................................
update company.Project 
set budget = budget *1.10
from company.Project p
inner join Works_on w
on p.ProjectNo=w.ProjectNo
where EmpNo=10102
--6............................................................
update company.Department
set DeptName='Sales'
from company.Department d
join Human_Resource.Employee E
on d.DeptNO=E.DeptNo
where E.EmpFname='Ann'
--7.................................................................
update Works_on
set Enter_Date='2007-12-12'
from Works_on w
left join company.Project p
on w.ProjectNo=p.ProjectNo
left join Human_Resource.Employee e
on e.EmpNO=w.EmpNo
left join company.Department d
on d.DeptNO=e.DeptNo
where p.ProjectNo='p1' and d.DeptName='Sales'
--8....................................................................
delete from company.Department
where Location='KW'

