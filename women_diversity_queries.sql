/* The database contains data of employees from 1985 till date. For the sake of this analysis,
we are taking current year to be 2010.alter

Since the focus of this enquiry is on the current workforce, we will generate a dataset from the database,
that gives us the details about the current workforce, and from which further questions about the current
workforce could be answered*/

# DATASET OF CURRENT WORKFORCE

CREATE VIEW current_workforce AS
SELECT
	s.emp_no,
    CONCAT(e.first_name, " ", e.last_name) AS staff_name,
    e.hire_date,
    t.title,
    t.from_date AS current_post_since,
    e.gender,
    2010 - YEAR(e.birth_date) AS age,
    s.salary,
    dmp.dept_no,
    d.dept_name
FROM
	employees.salaries AS s
    LEFT JOIN
    employees.employees AS e
    ON
    s.emp_no = e.emp_no
    LEFT JOIN
    employees.titles AS t
    ON
    s.emp_no = t.emp_no
    LEFT JOIN
	employees.dept_emp AS dmp
    ON
    s.emp_no = dmp.emp_no
    LEFT JOIN
    employees.departments AS d
    ON
    dmp.dept_no = d.dept_no
WHERE
	YEAR(s.to_date) = 9999
    AND
    YEAR(t.to_date) = 9999
    AND
    YEAR(dmp.to_date) = 9999
GROUP BY
	s.emp_no
;

# Q1: What is the ratio of women to total workforce?

SELECT
	gender,
    COUNT(gender) num_of_staff,
    CONCAT(ROUND(COUNT(gender)*100/g.total,1),'%') AS '% of workforce'
FROM
	current_workforce
CROSS JOIN
(
SELECT
		COUNT(gender) AS total FROM	current_workforce
)g
GROUP BY
	gender;

# Q2: Distribution of women across departments

SELECT
	dept_name,
    men_count,
    women_count,
	CONCAT(ROUND(men_count/(men_count+women_count) * 100,1),'%') AS '% of men',
    CONCAT(ROUND(women_count/(men_count+women_count) * 100,1),'%') AS '% of women'
FROM
(
SELECT
	dept_name,
    COUNT(CASE WHEN gender = "M" THEN 1 END) AS men_count,
    COUNT(CASE WHEN gender = "F" THEN 1 END) AS women_count
FROM
	current_workforce
GROUP BY
	dept_name
) a
;

# Q3: What’s the salary range of women compared to men?

SELECT
	dept_name,
    gender,
    MIN(salary),
    MAX(salary)
FROM
	current_workforce
GROUP BY
	dept_name,
    gender
;

# Q4: How many women are in managerial roles OR How many women are heads of departments?

SELECT
	gender,
    COUNT(gender)
FROM
	current_workforce
WHERE
	title = 'Manager'
GROUP BY
	gender
;