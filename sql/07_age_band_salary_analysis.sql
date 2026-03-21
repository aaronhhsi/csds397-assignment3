-- ============================================================
-- Table: gold.age_band_salary_analysis
-- Purpose: Group employees into age bands and compare avg
--          salary, avg tenure, and avg performance rating.
-- Hypothesis: Older employees earn more due to accumulated
--   experience; salary gains may plateau in mid-career,
--   while younger high-earners signal fast-track roles.
-- ============================================================

DROP TABLE IF EXISTS gold.age_band_salary_analysis;
CREATE TABLE gold.age_band_salary_analysis AS
SELECT
    age_band,
    age_range,
    COUNT(*)                                        AS employee_count,
    ROUND(AVG(salary)::numeric, 2)                  AS avg_salary,
    ROUND(AVG(years_of_experience)::numeric, 2)     AS avg_years_experience,
    ROUND(AVG(performance_rating)::numeric, 2)      AS avg_performance_rating
FROM (
    SELECT
        salary,
        years_of_experience,
        performance_rating,
        CASE
            WHEN age < 30              THEN 1
            WHEN age BETWEEN 30 AND 39 THEN 2
            WHEN age BETWEEN 40 AND 49 THEN 3
            ELSE 4
        END AS age_band,
        CASE
            WHEN age < 30              THEN 'Under 30'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50+'
        END AS age_range
    FROM raw_employees
) t
GROUP BY age_band, age_range
ORDER BY age_band;
