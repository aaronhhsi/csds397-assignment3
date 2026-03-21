-- ============================================================
-- Table: gold.salary_to_department_analysis
-- Purpose: Average (and distribution of) salary per department
-- ============================================================

CREATE SCHEMA IF NOT EXISTS gold;

DROP TABLE IF EXISTS gold.salary_to_department_analysis;
CREATE TABLE gold.salary_to_department_analysis AS
SELECT
    department,
    COUNT(*)                                    AS employee_count,
    ROUND(AVG(salary)::numeric, 2)              AS avg_salary,
    ROUND(MIN(salary)::numeric, 2)              AS min_salary,
    ROUND(MAX(salary)::numeric, 2)              AS max_salary,
    ROUND(STDDEV(salary)::numeric, 2)           AS salary_stddev
FROM raw_employees
GROUP BY department
ORDER BY avg_salary DESC;
