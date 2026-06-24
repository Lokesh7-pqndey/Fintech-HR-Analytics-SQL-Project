/* =====================================================
   FINTECH EMPLOYEE ANALYTICS PROJECT
   Author : Your Name
   Database : Fintech_db
   Objective :
   Analyze workforce distribution, salary spending,
   employee retention risk, and department performance.
===================================================== */

/* =====================================================
   COMPANY OVERVIEW
===================================================== */

-- Total Employees

SELECT COUNT(*) AS Total_Employees
FROM employee_records;

-- Total Departments

SELECT COUNT(DISTINCT Department) AS Total_Departments
FROM employee_records;

-- Total Countries

SELECT COUNT(DISTINCT Country) AS Total_Countries
FROM employee_records;

-- Total Payroll Cost

SELECT ROUND(SUM(Salary),2) AS Total_Payroll
FROM employee_records;

-- Average Salary

SELECT ROUND(AVG(Salary),2) AS Avg_Salary
FROM employee_records;



/*
Insight:
The organization operates across multiple countries
and departments with a total payroll investment
of X amount.
*/

/* =====================================================
   WORKFORCE DISTRIBUTION
===================================================== */

-- Employees by Department

SELECT
Department,
COUNT(*) AS Employee_Count
FROM employee_records
GROUP BY Department
ORDER BY Employee_Count DESC;

-- Employees by Country

SELECT
Country,
COUNT(*) AS Employee_Count
FROM employee_records
GROUP BY Country
ORDER BY Employee_Count DESC;

/*
Insight:
Support department employs the highest workforce,
indicating high operational dependency.
*/

/* =====================================================
   PAYROLL ANALYSIS
===================================================== */

SELECT
Department,
COUNT(*) AS Employees,
ROUND(AVG(Salary),2) AS Avg_Salary,
ROUND(SUM(Salary),2) AS Payroll_Cost
FROM employee_records
GROUP BY Department
ORDER BY Payroll_Cost DESC;

/*
Insight:
Engineering contributes the highest payroll cost,
suggesting concentration of high-value talent.
*/

/* =====================================================
   TOP PERFORMERS
===================================================== */

WITH SalaryRank AS
(
SELECT
Employee_ID,
Employee_Name,
Department,
Salary,
ROW_NUMBER() OVER
(
PARTITION BY Department
ORDER BY Salary DESC
) rn
FROM employee_records
)

SELECT *
FROM SalaryRank
WHERE rn <= 3;

/*
Insight:
Top 3 earners represent key talent within
each department and may require retention planning.
*/

/* =====================================================
   SALARY INEQUALITY ANALYSIS
===================================================== */

WITH DeptAvg AS
(
SELECT
Department,
AVG(Salary) AS AvgSalary
FROM employee_records
GROUP BY Department
)

SELECT
e.Employee_Name,
e.Department,
e.Salary,
ROUND(d.AvgSalary,2) AS Dept_Avg,
ROUND(
((e.Salary-d.AvgSalary)
/ d.AvgSalary)*100,2
) AS Variance_Percent
FROM employee_records e
JOIN DeptAvg d
ON e.Department=d.Department
ORDER BY Variance_Percent;

/*
Insight:
Large negative variance employees may feel
underpaid compared to peers, increasing
attrition risk.
*/

/* =====================================================
   RETENTION RISK
===================================================== */

SELECT
Employee_ID,
Employee_Name,
Department,
Salary,
TIMESTAMPDIFF
(
YEAR,
Joining_Date,
CURDATE()
) AS Tenure_Years
FROM employee_records
ORDER BY Tenure_Years DESC;


/* =====================================================
   HIRING TREND ANALYSIS
===================================================== */

SELECT
YEAR(Joining_Date) AS Joining_Year,
COUNT(*) AS Employees_Hired
FROM employee_records
GROUP BY YEAR(Joining_Date)
ORDER BY Joining_Year;

/*
Insight:
Hiring peaked in XXXX indicating
aggressive expansion phase.
*/

WITH SalaryRank AS
(
SELECT
*,
ROW_NUMBER() OVER
(
PARTITION BY Department
ORDER BY Salary DESC
) rn
FROM employee_records
)

SELECT *
FROM SalaryRank
WHERE rn=1;

SELECT
Department,
MAX(Salary)-MIN(Salary) AS Salary_Gap
FROM employee_records
GROUP BY Department
ORDER BY Salary_Gap DESC;

SELECT
Department,
ROUND(
SUM(Salary)*100/
SUM(SUM(Salary)) OVER (),
2
) AS Payroll_Percentage
FROM employee_records
GROUP BY Department
ORDER BY Payroll_Percentage DESC;
