create database subquery;
use subquery;
/*create table department

(
	dept_id		int ,
	dept_name	varchar(50) PRIMARY KEY,
	location	varchar(100)
);
insert into department values (1, 'Admin', 'Bangalore');
insert into department values (2, 'HR', 'Bangalore');
insert into department values (3, 'IT', 'Bangalore');
insert into department values (4, 'Finance', 'Mumbai');
insert into department values (5, 'Marketing', 'Bangalore');
insert into department values (6, 'Sales', 'Mumbai');

CREATE TABLE EMPLOYEE
(
    EMP_ID      INT PRIMARY KEY,
    EMP_NAME    VARCHAR(50) NOT NULL,
    DEPT_NAME   VARCHAR(50) NOT NULL,
    SALARY      INT,
    constraint fk_emp foreign key(dept_name) references department(dept_name)
);
insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);


CREATE TABLE employee_history
(
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(50) NOT NULL,
    dept_name   VARCHAR(50),
    salary      INT,
    location    VARCHAR(100),
    constraint fk_emp_hist_01 foreign key(dept_name) references department(dept_name),
    constraint fk_emp_hist_02 foreign key(emp_id) references employee(emp_id)
);

create table sales
(
	store_id  		int,
	store_name  	varchar(50),
	product_name	varchar(50),
	quantity		int,
	price	     	int
);
insert into sales values
(1, 'Apple Store 1','iPhone 13 Pro', 1, 1000),
(1, 'Apple Store 1','MacBook pro 14', 3, 6000),
(1, 'Apple Store 1','AirPods Pro', 2, 500),
(2, 'Apple Store 2','iPhone 13 Pro', 2, 2000),
(3, 'Apple Store 3','iPhone 12 Pro', 1, 750),
(3, 'Apple Store 3','MacBook pro 14', 1, 2000),
(3, 'Apple Store 3','MacBook Air', 4, 4400),
(3, 'Apple Store 3','iPhone 13', 2, 1800),
(3, 'Apple Store 3','AirPods Pro', 3, 750),
(4, 'Apple Store 4','iPhone 12 Pro', 2, 1500),
(4, 'Apple Store 4','MacBook pro 16', 1, 3500);

*/


select * from employee;
select * from department;
select * from employee_history;
select * from sales;

-- Find the employees who's salary is more than the average salary earned by all employees. 
-- 1) find the avg salary
-- 2) filter employees based on the above avg salary
select * from employee e
where e.salary > (select avg(salary) as AVG_Salary 
from employee e)
order by e.salary 

/* < SCALAR SUBQUERY > */
/* Find the employees who earn more than the average salary earned by all employees. */
-- it return exactly 1 row and 1 column
select e.*,avg_salary from employee e
join (
select avg(e.salary) as AVG_Salary
from employee e 
) as xyz
where e.salary > xyz.AVG_Salary

/* < MULTIPLE ROW SUBQUERY > */
-- Multiple column, multiple row subquery
/* QUESTION: Find the employees who earn the highest salary in each department. */
select * from (
	select e.*,max(salary) over(partition by dept_name ) as max_salary
	from employee e
) as xyz
where xyz.salary = xyz.max_salary

select e.* from employee e
where (dept_name,salary) in 
 (
	select dept_name,max(salary) as max_salary
	from employee e
	group by e.dept_name ) 


-- Single column, multiple row subquery
/* QUESTION: Find department who do not have any employees */
select * from employee;
select * from department;

select * from department 
where dept_name not in (
	select distinct dept_name from employee 
);

/* < CORRELATED SUBQUERY >
-- A subquery which is related to the Outer query
/* QUESTION: Find the employees in each department who earn more than the average salary in that department. */
select xyz.* from  (
	select e.*,avg(e.salary) over(partition by e.dept_name) as Avg_salary
	from employee e 
) as xyz
where xyz.salary> xyz.avg_salary 
select * from employee e2
where salary > (select avg(salary) as Avg_salary from employee e where e.dept_name =e2.dept_name
    )
/* QUESTION: Find department who do not have any employees */
-- Using correlated subquery

select * from department d
where  not exists (select * from employee e where e.dept_name = d.dept_name)


/* < SUBQUERY inside SUBQUERY (NESTED Query/Subquery)> */
/* QUESTION: Find stores who's sales where better than the average sales accross all stores */

-- Using multiple subquery
select * from sales;
select store_name,sum(price) as total,total_sl.avg_total_sales from sales s
join 
 (
	select round(avg(average_sales.total_sales),2) as AVG_total_sales from (
		select store_name , sum(price) as total_sales
		from sales 
		group by store_name
	)as average_sales
) as total_sl
-- where s.total > total_sl.avg_total_sales
group by store_name



-- with clause 
with t1(store_name,total_sales)as (
select store_name,sum(price)
from sales
group by store_name
),
	 t2(average) as (
	select avg(total_sales)  from t1
	)
select * from t1
join t2 on t1.total_sales > t2.average

/* < Using Subquery in WHERE clause > */
/* QUESTION:  Find the employees who earn more than the average salary earned by all employees. */
select * from employee

select e.* from employee e 
where e.salary >   (	select avg(salary) as avg_salary 
	from employee )
order by e.salary;

/* QUESTION: Find stores who's sales where better than the average sales accross all stores */
select * from sales;

with	t2 (store_name,total_sales) as (
		select store_name,sum(price) from sales
		group by store_name
    ),
    t3 (average_sales) as (
		select avg(total_sales) from t2
    )
select * from t2
join t3
where t2.total_sales > t3.average_sales


/* QUESTION: Fetch all employee details and add remarks to those employees who earn more than the average pay. */
select * from employee ;
with t1 (avg_pay) as (
	select round(avg(salary),2) from employee
)
select *,
		case when 
        employee.salary > t1.avg_pay then 'higher than average pay'
        end as remark
        from employee 
	join t1;
    
)

/* QUESTION: Find the stores who have sold more units than the average units sold by all stores. */
select * from sales;

with t1 (AVG_QTY) as (
		select avg(quantity) from sales
        ),
		t2(store_name,Average_QTY) as (select  store_name , sum(quantity) 
			from sales 
			group by store_name)
select * from t2 
join t1 
on t2.Average_QTY > t1.AVG_QTY

select store_name, sum(quantity) Items_sold
from sales
group by store_name
having sum(quantity) > (select avg(quantity) from sales);

/* < Using Subquery with INSERT statement > */
/* QUESTION: Insert data to employee history table. Make sure not insert duplicate records. */
select * from employee_history;

insert into employee_history
select e.emp_id,e.emp_name,d.dept_name,e.salary,d.location
from employee e 
join department d 
on e.dept_name = d.dept_name 
where not exists( select 1 from employee_history eh
					 where eh.emp_id = e.emp_id);
                     
 select * from employee_history;
