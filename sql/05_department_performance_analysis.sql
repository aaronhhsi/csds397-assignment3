-- ============================================================
-- Table: gold.department_performance_analysis
-- Purpose: Cross-tab of Department x Performance Rating showing
--          headcount, avg salary, and avg years of experience.
-- Hypothesis: High-performance employees are concentrated in
--   specific departments; those departments also have higher
--   salaries — identifying where talent and pay are aligned.
-- ============================================================

DROP TABLE IF EXISTS gold.department_performance_analysis;
CREATE TABLE gold.department_performance_analysis AS
SELECT
    department,
    performance_rating,
    COUNT(*)                                        AS employee_count,
    ROUND(AVG(salary)::numeric, 2)                  AS avg_salary,
    ROUND(AVG(years_of_experience)::numeric, 2)     AS avg_years_experience
FROM raw_employees
GROUP BY department, performance_rating
ORDER BY department, performance_rating;
