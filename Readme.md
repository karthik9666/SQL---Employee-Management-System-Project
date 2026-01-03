# Employee Management System (EMS) – SQL Project

Domain Knowledge
The Employee Management System (EMS) is designed to streamline the management of employee data, job roles, and departmental information within an organization. This system allows for efficient tracking of employee details, job assignments, qualifications, and performance metrics. Key domain knowledge elements for this system include:

1.Employee Information Management: The system stores personal details of employees such as name, contact information, gender, and unique login credentials. It is crucial for ensuring secure access and easy retrieval of employee records.


2.Job Role Assignment: Each employee is associated with a specific job role, which is linked to the department they work in. This connection ensures that employees are correctly aligned with their job functions and responsibilities within the organization.


3.Departmental Structure: The organization is divided into various departments (e.g., HR, Finance, IT), each with distinct job roles. The system should manage these departments and the employees assigned to each role efficiently.


4.Payroll and Compensation: Employee compensation details, including salary and bonuses, are stored in the system. Payroll processing and salary allocations are automatically calculated based on the job roles and associated salary ranges.


5.Qualifications and Skills Tracking: The system tracks employee qualifications, certifications, and skills to ensure that employees meet the requirements for their roles and identify opportunities for professional development.


6.Leave and Absence Management: The system manages employee leave records, including vacation days, sick leaves, and other types of absences, with appropriate deductions applied to payroll based on the employee’s leave history.


This system ensures that all employee-related information is stored securely, easily accessible for reporting, and aligned with organizational goals for performance, compensation, and growth.

🎯 Objectives
- Design a normalized relational database for employee management
- Maintain data integrity using foreign keys and constraints
- Perform meaningful business analysis using SQL
- Answer real-world HR and payroll questions through queries

🗂️ Database Schema

This project includes 6 interrelated tables:

Table name                             Description                                
JobDepartment                    Stores job roles, departments, and related salary ranges
SalaryBonus                      Contains salary, bonus, and annual pay linked to specific job roles.
Employee                         Maintains personal, contact, and login details of all employees.
Qualification                    Records qualifications and required skills for employee job positions.
Leaves                           Tracks employee leave records with reasons and dates.
Payroll                          Combines employee, job, salary, and leave data to calculate net payments.


📌 *Refer to `ER-Diagram.png` for the ER diagram.*

## 🔗 Table Relationships
- One department → many job roles
- One job role → many employees
- One employee → many qualifications
- One employee → many leave records
- Payroll integrates employee, job, salary, and leave data





## 📊 Business Analysis Performed

### 👥 Employee Insights
- Total number of employees
- Departments with the highest employee count
- Top 5 highest-paid employees
- Total salary expenditure

### 🏢 Job & Department Analysis
- Job roles per department
- Average salary range per department
- Highest-paying job roles
- Departments with highest salary allocation

### 🎓 Qualification Analysis
- Employees with qualifications
- Positions requiring most qualifications
- Employees with the highest number of qualifications

### 🏖️ Leave Analysis
- Year with most employees taking leave
- Average leave days per department
- Employees with the most leaves
- Total leave days company-wide
- Correlation between leave days and payroll amounts

### 💰 Payroll Analysis
- Monthly payroll processed
- Average bonus per department
- Department with highest total bonuses
- Average salary after leave deductions


