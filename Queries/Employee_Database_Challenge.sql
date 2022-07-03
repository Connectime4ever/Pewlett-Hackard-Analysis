-- Creating retirement_titles.csv
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    ti.title,
    ti.from_date,
     ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE (to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;

-- Creating Retiring Titles table
SELECT COUNT(title) AS "count", title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "count" DESC;

-- Creating a Mentorship1 to create Eligibility table
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date, 
    ti.title
INTO mentorship1
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no);

-- Using Dictinct ON 
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
birth_date,
from_date,
to_date,
title
INTO mentorship_eligibility
FROM mentorship1
WHERE (to_date = '9999-01-01')
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

-- Summary questions
-- Total roles to be replaced
SELECT COUNT (emp_no)
FROM unique_titles;

-- Total employees eligible for Mentorship Program.
SELECT COUNT (emp_no)
FROM mentorship_eligibility;

--High Qualified Retiring employees by Departments
SELECT u.emp_no,
	u.first_name,
	u.last_name,
	u.title,
	de.dept_no
INTO retirings_depts1
FROM unique_titles as u
LEFT JOIN dept_emp as de
ON u.emp_no = de.emp_no;

SELECT rd.emp_no,
	rd.title,
	d.dept_name
INTO retirings_depts2
FROM retirings_depts1 as rd
LEFT JOIN departments as d
ON rd.dept_no = d.dept_no; 

SELECT DISTINCT ON (emp_no)emp_no,
	dept_name,
	title
INTO retirings_depts3
FROM retirings_depts2;

SELECT dept_name, COUNT(title) as "Total Retiring-Ready Employees"
FROM retirings_depts3
GROUP BY dept_name
ORDER BY "Total Retiring-Ready Employees" DESC;


SELECT dept_name, COUNT(title) as "Total High Qualified Retiring-Ready Employees"
INTO highTech_demand
FROM retirings_depts3
WHERE (title = 'Senior Engineer') OR  (title = 'Senior Staff') OR (title = 'Engineer') OR (title = 'Technique Leader')
GROUP BY dept_name
ORDER BY "Total High Qualified Retiring-Ready Employees" DESC;

-- Eligible Employees for Mentorship Program by Department
SELECT m.emp_no,
	m.title,
	de.dept_no
INTO eligible1
FROM mentorship_eligibility as m
LEFT JOIN dept_emp as de
ON m.emp_no = de.emp_no;

SELECT e.emp_no,
	e.title,
	d.dept_name
INTO eligible2
FROM eligible1 as e
LEFT JOIN departments as d
ON e.dept_no = d.dept_no;

SELECT DISTINCT ON (emp_no)emp_no,
	dept_name,
	title
INTO eligible3
FROM eligible2;

SELECT dept_name, COUNT(title) as "Total Eligible Employees for Mentorship"
INTO eligible_bydept
FROM eligible3
GROUP BY dept_name
ORDER BY "Total Eligible Employees for Mentorship" DESC;
