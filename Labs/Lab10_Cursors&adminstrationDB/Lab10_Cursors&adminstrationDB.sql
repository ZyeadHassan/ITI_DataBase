/*1.	Create a cursor for Employee table that increases Employee salary by 10% 
if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB*/
declare sal_cur cursor
	for select SSN,Fname,Salary from Employee
	for update

declare @id int
declare @name nvarchar(50)
declare @s int
open sal_cur
fetch sal_cur into @id,@name,@s

	While @@fetch_status=0
	begin
		if @s<3000		
				update Employee
				set Salary= @s*1.10 
				where current of sal_cur		
		Else
				update Employee	
				set Salary= @s*1.20 
				where current of sal_cur 
		fetch sal_cur into @id,@name,@s			
	end

close sal_cur
deallocate sal_cur
--.......................................................................
--2.Display Department name with its manager name using cursor. Use ITI DB
declare DepManager_Cur cursor
for select  t.Dept_Name as Dept_Name,i.Ins_Name as Manager_Name
	from Department t ,Instructor i
	where t.Dept_Manager=i.Ins_Id
for read only

declare @dep varchar(20)
declare @Man varchar(20)

open DepManager_Cur
fetch DepManager_Cur into @dep,@Man

while @@FETCH_STATUS=0
begin
select @dep,@Man
fetch DepManager_Cur into @dep,@Man
end

close DepManager_Cur
deallocate DepManager_Cur
--.................................................................
--3.Try to display all students first name in one cell separated by comma. Using Cursor 
declare @names varchar(max)=''
declare @fname varchar(20)

declare Names_Cur cursor
for select  St_Fname 
	from Student
	for read only

open Names_Cur
FETCH NEXT FROM Names_Cur INTO @fname

while @@FETCH_STATUS=0
begin
SET @names = @names + CASE WHEN LEN(@names) > 0 THEN ',' ELSE '' END 
			+ ISNULL(@fname, '')
FETCH NEXT FROM Names_Cur INTO @fname
end

close Names_Cur
deallocate Names_Cur

SELECT @names AS AllNames
--................................................................
/*5.Create Login Named Ahmed and give permission to select and update 
from tables department , course on ITI*/

grant select on Department  to Ahmed
grant select on  Course to Ahmed
grant update on Department  to Ahmed
grant update on  Course to Ahmed

--.....................................................................
/*6.Create Table Work With EmpID , Project ID , Hours
In any Database without PK then insert some values with repeating empid , 
project id then write query to calculate sum of hours depend on empid 
only with subtotal and query to calculate sum of hours depend on
empid , project id with subtotal of two columns. */ 

create database Lab10

create table Work(
Emp_ID int,
Project_ID int, 
Hours_In int
)

select 
isnull(convert(varchar(20),Emp_id),'Total') 'Employee ID',
isnull(convert(varchar(20),Project_ID),'Total') 'Project ID',
sum(Hours_in) 'Total Hours'
from Work
group by rollup (Emp_id,Project_ID)

select 
isnull(convert(varchar(20),Emp_id),'Total') 'Employee ID',
isnull(convert(varchar(20),Project_ID),'Total') 'Project ID',
sum(Hours_in) 'Total Hours'
from Work
group by cube (Emp_id,Project_ID)