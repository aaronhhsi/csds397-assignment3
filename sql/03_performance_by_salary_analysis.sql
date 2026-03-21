-- ============================================================
-- Table: gold.performance_by_salary_analysis
-- Purpose: Average salary for each performance rating (1-5)
-- ============================================================

DROP TABLE IF EXISTS gold.performance_by_salary_analysis;
CREATE TABLE gold.performance_by_salary_analysis AS
SELECT
    performance_rating,
    COUNT(*)                                    AS employee_count,
    ROUND(AVG(salary)::numeric, 2)              AS avg_salary,
    ROUND(MIN(salary)::numeric, 2)              AS min_salary,
    ROUND(MAX(salary)::numeric, 2)              AS max_salary,
    ROUND(STDDEV(salary)::numeric, 2)           AS salary_stddev
FROM raw_employees
GROUP BY performance_rating
ORDER BY performance_rating;
