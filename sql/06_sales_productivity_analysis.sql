-- ============================================================
-- Table: gold.sales_productivity_analysis
-- Purpose: Bucket employees by Total Sales volume and compare
--          avg salary, avg performance rating, and avg sales.
-- Hypothesis: Employees with higher Total Sales earn higher
--   salaries, confirming an incentive/commission pay structure.
--   Low sellers may be misaligned with their role.
-- ============================================================

DROP TABLE IF EXISTS gold.sales_productivity_analysis;
CREATE TABLE gold.sales_productivity_analysis AS
SELECT
    sales_tier,
    sales_range,
    COUNT(*)                                        AS employee_count,
    ROUND(AVG(salary)::numeric, 2)                  AS avg_salary,
    ROUND(AVG(performance_rating)::numeric, 2)      AS avg_performance_rating,
    ROUND(AVG(total_sales)::numeric, 2)             AS avg_total_sales
FROM (
    SELECT
        salary,
        performance_rating,
        total_sales,
        CASE
            WHEN total_sales = 0                    THEN 1
            WHEN total_sales BETWEEN 1 AND 50000    THEN 2
            WHEN total_sales BETWEEN 50001 AND 100000 THEN 3
            ELSE 4
        END AS sales_tier,
        CASE
            WHEN total_sales = 0                    THEN 'Non-Sales Role'
            WHEN total_sales BETWEEN 1 AND 50000    THEN '$1-$50k'
            WHEN total_sales BETWEEN 50001 AND 100000 THEN '$50k-$100k'
            ELSE '$100k+'
        END AS sales_range
    FROM raw_employees
) t
GROUP BY sales_tier, sales_range
ORDER BY sales_tier;
