create database employee_managament_system;
use employee_managament_system;


-- Table 1: Job Department
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    description TEXT
);
select * from JobDepartment;

-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT NOT NULL,
    monthly_salary DECIMAL(10,2) NOT NULL,
    annual_salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job
        FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
select * from SalaryBonus;

-- Table 3: Employee
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INT CHECK (age >= 18),
    contact_add VARCHAR(150),
    emp_email VARCHAR(100) UNIQUE NOT NULL,
    emp_pass VARCHAR(100) NOT NULL,
    Job_ID INT,
    CONSTRAINT fk_employee_job
        FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
select * from Employee;

-- Table 4: Qualification
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    emp_ID INT NOT NULL,
    position VARCHAR(100),
    requirements VARCHAR(255),
    date_in VARCHAR(20),
    CONSTRAINT fk_qualification_emp
        FOREIGN KEY (emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
select * from qualification;

UPDATE Qualification
SET date_in = STR_TO_DATE(date_in, '%m/%d/%Y')
WHERE QualID IS NOT NULL;


ALTER TABLE Qualification
MODIFY date_in DATE;

select * from Qualification;

-- Table 5: Leaves
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT NOT NULL,
    leave_date VARCHAR(20),
    reason TEXT,
    CONSTRAINT fk_leave_emp
        FOREIGN KEY (emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
select * from leaves;

-- Table 6: Payroll

CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT NOT NULL,
    job_ID INT NOT NULL,
    salary_ID INT NOT NULL,
    leave_ID INT,
    payroll_date VARCHAR(20),
    report TEXT,
    total_amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_payroll_emp
        FOREIGN KEY (emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_job
        FOREIGN KEY (job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_salary
        FOREIGN KEY (salary_ID)
        REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_leave
        FOREIGN KEY (leave_ID)
        REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
select * from payroll;



-- ---------------------------   Analysis Questions ------------------------- 
-- ---------------------------1.  EMPLOYEE INSIGHTS
-- How many unique employees are currently in the system?
select count(distinct emp_id)n from employee;

-- Which departments have the highest number of employees?
select count(j.job_ID) as no_of_employees, j.department_name
from employee e
join jobdepartment j
on e.job_ID = j.job_ID 
group by j.department_name
order by no_of_employees desc;

-- 	What is the average salary  per department?
select department_name, avg(total_amount) as avg_salary
from jobdepartment j
join payroll p
on j.job_ID = p.job_ID
group by department_name;

-- Who are the top 5 highest-paid employees?
SELECT 
    e.emp_ID,
    e.firstname,
    e.lastname,
    p.total_amount AS annual_salary
FROM payroll p
JOIN employee e
    ON p.emp_ID = e.emp_ID
ORDER BY p.total_amount DESC
LIMIT 5;

-- What is the total salary expenditure across the company?
select sum(total_amount) as total_salary_expenditure
from payroll;

-- -------------------  2. JOB ROLE AND DEPARTMENT ANALYSIS
-- How many different job roles exist in each department?

SELECT department_name, COUNT(DISTINCT job_title) AS job_roles
FROM jobdepartment
GROUP BY department_name;


-- What is the average salary range per department?
select j.department_name,avg(annual_salary) as avg_salary
from jobdepartment j
join salarybonus s
on j.job_ID = s.job_ID
group by j.department_name;

-- Which job roles offer the highest salary?
SELECT 
    j.job_title,
    j.department_name,
    s.annual_salary
FROM jobdepartment j
JOIN salarybonus s
    ON j.job_ID = s.job_ID
ORDER BY s.annual_salary DESC
limit 5;


-- Which departments have the highest total salary allocation?
select j.department_name, sum(total_amount) as total_salary
from jobdepartment j
join payroll p
on j.job_ID = p.job_ID 
group by j.department_name
order by total_salary desc
limit 2;


--                             3. QUALIFICATION AND SKILLS ANALYSIS

-- How many employees have at least one qualification listed?
select count(distinct q.emp_ID) 
from employee e
join qualification q
on q.emp_ID = e.emp_ID;

-- Which positions require the most	alifications?
select position, count(*) as qualification_count
from qualification
group by position
order by qualification_count desc;

-- Which employees have the highest number of qualifications?
select q.emp_ID, count(*) no_of_qualification
from employee e
join qualification q 
on e.emp_ID = q.emp_ID
group by q.emp_ID;



--                    4. LEAVE AND ABSENCE PATTERNS
-- Which year had the most employees taking leaves?
select  year(leave_date) as leave_year, count(distinct(emp_ID)) as no_of_employees
from leaves 
group by leave_year
order by no_of_employees desc;


-- What is the average number of leave days taken by its employees per department?

SELECT 
    j.department_name,
    AVG(emp_leave_count) AS avg_leave_days
FROM (
    SELECT 
        e.emp_ID,
        e.Job_ID,
        COUNT(l.leave_ID) AS emp_leave_count
    FROM employee e
    LEFT JOIN leaves l
        ON e.emp_ID = l.emp_ID
    GROUP BY e.emp_ID, e.Job_ID
) emp_leaves
JOIN jobdepartment j
    ON emp_leaves.Job_ID = j.Job_ID
GROUP BY j.department_name;



-- Which employees have taken the most leaves?
SELECT 
    e.emp_ID,
    e.firstname,
    e.lastname,
    COUNT(l.leave_ID) AS no_of_leaves
FROM employee e
JOIN leaves l
    ON e.emp_ID = l.emp_ID
GROUP BY e.emp_ID, e.firstname, e.lastname
ORDER BY no_of_leaves DESC;

-- What is the total number of leave days taken company-wide?
select count(distinct leave_id)
from leaves ;

-- How do leave days correlate with payroll amounts?
select e.emp_ID, e.firstname, e.lastname,
count(l.leave_ID) as total_leave_days, 
sum(p.total_amount) as total_payroll_amount
from employee e
left join leaves l
on e.emp_ID = l.emp_ID
left join payroll p					
on e.emp_ID = p.emp_ID
group by e.emp_ID, e.firstname, e.lastname
order by total_payroll_amount desc;


--                   5. PAYROLL AND COMPENSATION ANALYSIS
-- What is the total monthly payroll processed?
select 
year(payroll_date) as payroll_year, 
month(payroll_date) as payroll_month,
sum(total_amount) as total_month_payroll
from payroll
group by payroll_year, payroll_month
order by payroll_year, payroll_month;

-- What is the average bonus given per department?
select j.department_name, avg(bonus) as avg_bonus
from salarybonus s
join jobdepartment j
on s.job_ID = j.job_ID
group by j.department_name;

-- Which department receives the highest total bonuses?
select j.department_name, sum(s.bonus) as total_bonus
from salarybonus s
join jobdepartment j
on s.job_ID = j.job_ID
group by j.department_name
order by total_bonus desc
limit 1;

-- What is the average value of total_amount after considering leave deductions?
select avg(total_amount) as Avg_value
from payroll;

