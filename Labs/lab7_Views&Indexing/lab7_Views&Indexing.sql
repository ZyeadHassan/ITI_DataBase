--1.Create a view that displays student full name, course name if the student has a grade more than 50. 
create view v1 (Full_name,Course_name)
as
	select St_Fname+' '+St_Lname ,Crs_Name
	from Student s
	join Stud_Course sc
	on s.St_Id=sc.St_Id
	join Course c
	on sc.Crs_Id=c.Crs_Id
	where Grade>50

select * from v1

--2.Create an Encrypted view that displays manager names and the topics they teach. 
alter VIEW V2
WITH ENCRYPTION
AS
SELECT  DISTINCT Ins_name ,Top_Name
FROM Instructor i
join Department d
on i.Dept_Id=d.Dept_Id
join Ins_Course ic
on ic.Ins_Id=i.Ins_Id
join Course c
on c.Crs_Id=ic.Crs_Id
join topic t
on t.Top_Id=c.Top_Id
where d.Dept_Manager=i.Ins_Id


select * from v2

--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
create view v3 (Instructor_Name , Department_Name)
as
select Ins_Name ,Dept_Name
from Instructor i
join Department d
on i.Dept_Id=d.Dept_Id
where Dept_Name in('SD','Java')

select * from v3

/*a.Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
Note: Prevent the users to run the following query 
Update V1 set st_address=’tanta’
Where st_address=’alex’;*/
alter view v4 as 
select * 
from student 
where St_Address in ('Alex' , 'Cairo')
WITH CHECK OPTION

select * from v4

Update v4 set st_address='tanta'
Where st_address='alex'

--4.Create a view that will display the project name and the number of employees work on it. “Use Company DB”
create view v5 (project_name,number_of_employees) as
select p.Pname,COUNT(w.essn)	
from Project p
join Works_for w
on p.Pnumber=w.Pno
group by p.Pname

select * 
from v5

---5.Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?

create clustered index i1
on Department(Manager_hiredate)

---can't be created because there is already a clustered index created by PK

--6.Create index that allow u to enter unique ages in student table. What will happen?
create unique nonclustered  index i1
on Student(St_Age)

--can't be created because there is already duplicated values in age column