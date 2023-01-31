create database company_db;
use company_db;


create table Employee(
empID int,
name varchar(50),
jobtype varchar(50),
specialization varchar(50),
hire_Date date,
startConractDate date,
expireContractDate date,
salary int,
gender enum('Male','Female'),
birthdate date,
totalAge int,
address varchar(50), 
deptNo int,
primary key(empID));


create table Department(
deptNumber int,
deptName varchar(50) not null,
deptLocation varchar(50), 
deptMgrId int,
primary key(deptNumber),
foreign key (deptMgrID) references Employee(empID));

-- add foreign key to Employee table
alter table Employee
add foreign key(deptNo) references Department(deptNumber);


create table DeptLocation (
location varchar(50), 
deptNo int,
primary key(location,deptNo),
foreign key(deptNo) references Department(deptNumber)
);


create table Project (
projectNo int, 
projectName varchar(50) not null, 
projectType varchar(50), 
totalDuration varchar(50), 
totalBudget int,
primary key(projectNo)
);


create table Dept_Project (
deptNo int, 
projNo int,
foreign key(deptNo) references Department(deptNumber),
foreign key(projNo) references Project(projectNo),
primary key(deptNo,projNo)
);


create table Emp_Project (
empId int, 
projectNo int,
foreign key(empId) references Employee(empID),
foreign key(projectNo) references Project(projectNo),
primary key(empId,projectNo)
);





insert into Employee(empID,name,jobtype,specialization,
hire_Date,startConractDate,expireContractDate,salary,
gender,birthdate,totalAge,address, deptNo)
values(001,'Shehryar Khattak','System Engineer','Server management','2016-05-12','2016-06-11'
,'2023-06-11',8000,'Male','2001-01-19',22,'Abbottabad,6A-Jinnahabad-PMA Linkroad',null),
(002,'Hasan Khan','Businessman','Sales Management','2015-05-12','2015-06-11'
,'2024-06-11',8000,'Male','2003-01-19',20,'Islamabad,G-11',null),
(003,'Talha Bilal','Software Engineer','App Development','2017-05-12','2017-06-11'
,'2025-06-11',8000,'Male','2000-01-19',23,'Peshawer,G-ll, Regi Plaza',null);

insert into Department(deptNumber,deptName,deptLocation, deptMgrId)
values(001,'Systems Management','Abbottabad',001),(002,'Finance Department','Islamabad',002),
(003,'App Development','Peshawer',003);

update Employee 
set deptNo=001
where empID=001;

update Employee 
set deptNo=002
where empID=002;

update Employee 
set deptNo=003
where empID=003;


insert into DeptLocation(location, deptNo)
values('Karachi',001),('Haripur',001),('Peshawer',001),('Islamabad',001),('Abbottabad',001),
('Murree',002),('Hyderabad',002),('Kashmir',002),('Islamabad',002),('Abbottabad',002),
('Karachi',003),('Hyderabad',003),('Rawalpindi',003),('Peshawer',003),('Abbottabad',003);


insert into Project (projectNo, projectName, projectType, totalDuration, totalBudget)
values(001,'Cloud Services Setup','System Engineering','6 Months',50000),
(002,'Internet Advertisement','Financing','9 Months',45000),
(003,'Company Mobile App','App Development','5 Months',35000),
(004,'Remote Server Access App','App Development','10 Months',60000),
(005,'Server Security Update','System Engineering','11 Months',100000);


insert into Dept_Project (deptNo, projNo)
values(001,001),
(001,005),(002,002),(003,003),(003,004);

insert into Emp_Project (empId, projectNo)
values(001,001),(001,005),(002,002),(003,003),(003,004);





update Employee
set expireContractDate= '2024-05-11'
where hire_Date > '2010-01-01' and hire_Date < '2011-01-01';

update DeptLocation
set location ='Dubai'
where deptNo=(select deptNumber from Department where deptName ='admin');

delete from Employee
where expireContractDate >= '2016-01-01' and expireContractDate<'2017-01-01';


-- creating views
create view ProjectEmployeeView AS 
select Employee.name, Employee.jobtype, Employee.hire_date, Employee.totalage, Employee.address, Project.projectName,Project.TotalDuration
from Emp_Project
inner join Employee on Employee.empID=Emp_Project.empID
inner join Project on Emp_Project.projectNo=Project.projectNo;


     
create view DeptProjectMgrView AS 
select  Employee.name ,Department.deptMgrId,Department.deptName,
DeptLocation.location,Project.projectName,Project.projectType,Project.totalBudget
from Dept_Project
inner join Department on Department.deptNumber=Dept_Project.deptNo
inner join Project on Project.projectNo=Dept_Project.projNo
inner join DeptLocation on DeptLocation.deptNo=Department.deptNumber
inner join Employee on Deptlocation.deptNo=Employee.deptNo;



create view EmpDept AS 
select Employee.name ,Employee.specialization,Employee.startConractDate,
Employee.expireContractDate,Department.deptName,Department.deptLocation
from Employee
inner join Department on Department.deptNumber=Employee.deptNo;

      
-- creating Triggers

create table user_audit(
username varchar(50),
empID int,
jobType varchar(50),
salary int,
birth date);


create trigger emp_deleter
after delete
on 
Employee
for each row
insert into user_audit(username,empID,jobType,salary,birth)
values(user(),Employee.empID,Employee.jobType,Employee.salary,Employee.birthdate);















