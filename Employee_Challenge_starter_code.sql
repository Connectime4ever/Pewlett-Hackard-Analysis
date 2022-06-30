-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) first_name,
last_name,
title,
FROM retirement_titles

INTO retirement_titles1
FROM retirement_titles
WHERE emp_no
ORDER BY emp_no, from_date DESC;
