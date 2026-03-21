-- ============================================================
-- Table: gold.salary_to_tenure_analysis
-- Purpose: Average salary grouped by years-of-experience buckets
-- Buckets: 0-2 (Entry), 3-5 (Mid), 6-8 (Senior),
--          9-11 (Expert), 12+ (Veteran)
-- ============================================================

DROP TABLE IF EXISTS gold.salary_to_tenure_analysis;
CREATE TABLE gold.salary_to_tenure_analysis AS
SELECT
    tenure_bucket,
    tenure_range,
    COUNT(*)                                    AS employee_count,
    ROUND(AVG(salary)::numeric, 2)              AS avg_salary,
    ROUND(MIN(salary)::numeric, 2)              AS min_salary,
    ROUND(MAX(salary)::numeric, 2)              AS max_salary,
    ROUND(STDDEV(salary)::numeric, 2)           AS salary_stddev
FROM (
    SELECT
        salary,
        years_of_experience,
        CASE
            WHEN years_of_experience BETWEEN 0  AND 2  THEN 1
            WHEN years_of_experience BETWEEN 3  AND 5  THEN 2
            WHEN years_of_experience BETWEEN 6  AND 8  THEN 3
            WHEN years_of_experience BETWEEN 9  AND 11 THEN 4
            ELSE 5
        END AS tenure_bucket,
        CASE
            WHEN years_of_experience BETWEEN 0  AND 2  THEN '0-2 yrs (Entry)'
            WHEN years_of_experience BETWEEN 3  AND 5  THEN '3-5 yrs (Mid)'
            WHEN years_of_experience BETWEEN 6  AND 8  THEN '6-8 yrs (Senior)'
            WHEN years_of_experience BETWEEN 9  AND 11 THEN '9-11 yrs (Expert)'
            ELSE '12+ yrs (Veteran)'
        END AS tenure_range
    FROM raw_employees
) t
GROUP BY tenure_bucket, tenure_range
ORDER BY tenure_bucket;
