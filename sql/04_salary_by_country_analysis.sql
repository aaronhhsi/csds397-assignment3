-- ============================================================
-- Table: gold.salary_by_country_analysis
-- Purpose: Geographic compensation analysis — avg salary,
--          headcount, and avg performance rating per country.
-- Hypothesis: Employees in certain countries command higher
--   salaries due to local cost-of-living, demand, or strategic
--   business presence.
-- ============================================================

DROP TABLE IF EXISTS gold.salary_by_country_analysis;
CREATE TABLE gold.salary_by_country_analysis AS
SELECT
    country,
    COUNT(*)                                        AS employee_count,
    ROUND(AVG(salary)::numeric, 2)                  AS avg_salary,
    ROUND(MIN(salary)::numeric, 2)                  AS min_salary,
    ROUND(MAX(salary)::numeric, 2)                  AS max_salary,
    ROUND(AVG(performance_rating)::numeric, 2)      AS avg_performance_rating
FROM raw_employees
GROUP BY country
ORDER BY avg_salary DESC;
