-- Overall: total employees, leavers, attrition rate
SELECT COUNT(*) AS total_employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean;

-- 1. Overtime vs attrition
SELECT OverTime, COUNT(*) AS employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY OverTime;

-- 2. Tenure vs attrition
SELECT CASE WHEN YearsAtCompany <= 2  THEN '1. 0-2 years'
            WHEN YearsAtCompany <= 5  THEN '2. 3-5 years'
            WHEN YearsAtCompany <= 10 THEN '3. 6-10 years'
            ELSE '4. 11+ years' END AS tenure_bucket,
       COUNT(*) AS employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY tenure_bucket
ORDER BY tenure_bucket;

-- 3. Age group vs attrition
SELECT CASE WHEN Age <= 25 THEN '1. 18-25'
            WHEN Age <= 35 THEN '2. 26-35'
            WHEN Age <= 45 THEN '3. 36-45'
            WHEN Age <= 55 THEN '4. 46-55'
            ELSE '5. 56+' END AS age_group,
       COUNT(*) AS employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY age_group
ORDER BY age_group;

-- 4. Salary slab vs attrition
SELECT CASE WHEN MonthlyIncome <= 5000  THEN '1. Up to 5k'
            WHEN MonthlyIncome <= 10000 THEN '2. 5k-10k'
            WHEN MonthlyIncome <= 15000 THEN '3. 10k-15k'
            ELSE '4. Above 15k' END AS salary_slab,
       COUNT(*) AS employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY salary_slab
ORDER BY salary_slab;

-- 5a. Job role: income and attrition
SELECT JobRole, COUNT(*) AS employees,
       ROUND(AVG(MonthlyIncome), 0) AS avg_monthly_income,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- 5b. Department attrition
SELECT Department, COUNT(*) AS employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- 6. Stock option level vs attrition
SELECT StockOptionLevel, COUNT(*) AS employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;

-- 7. Satisfaction: leavers vs stayers
SELECT CASE WHEN Attrition = 'Yes' THEN 'Leavers' ELSE 'Stayers' END AS employee_group,
       ROUND(AVG(JobSatisfaction), 2)         AS avg_job_satisfaction,
       ROUND(AVG(EnvironmentSatisfaction), 2) AS avg_environment_satisfaction,
       ROUND(AVG(WorkLifeBalance), 2)         AS avg_work_life_balance
FROM hr_clean
GROUP BY Attrition;

-- 8a. Business travel vs attrition
SELECT BusinessTravel, COUNT(*) AS employees,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY BusinessTravel
ORDER BY attrition_rate_pct DESC;

-- 8b. Distance from home vs attrition
SELECT CASE WHEN DistanceFromHome <= 5  THEN '1. 1-5 km'
            WHEN DistanceFromHome <= 10 THEN '2. 6-10 km'
            WHEN DistanceFromHome <= 20 THEN '3. 11-20 km'
            ELSE '4. 21+ km' END AS distance_band,
       COUNT(*) AS employees,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY distance_band
ORDER BY distance_band;

-- 8c. Marital status vs attrition
SELECT MaritalStatus, COUNT(*) AS employees,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY MaritalStatus
ORDER BY attrition_rate_pct DESC;

-- 9a. Years since promotion: leavers vs stayers
SELECT Attrition, ROUND(AVG(YearsSinceLastPromotion), 2) AS avg_years_since_promotion
FROM hr_clean GROUP BY Attrition;

-- 9b. Percent salary hike: leavers vs stayers
SELECT Attrition, ROUND(AVG(PercentSalaryHike), 2) AS avg_salary_hike_pct
FROM hr_clean GROUP BY Attrition;

-- 9c. Performance rating vs attrition
SELECT PerformanceRating, COUNT(*) AS employees,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY PerformanceRating;

-- 10. High-risk current employees (all 4 conditions) and "Watch" group (3 conditions)
WITH role_avg AS (
    SELECT *, AVG(MonthlyIncome) OVER (PARTITION BY JobRole) AS role_avg_income
    FROM hr_clean
),
flags AS (
    SELECT (CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END)
         + (CASE WHEN JobSatisfaction <= 2 THEN 1 ELSE 0 END)
         + (CASE WHEN YearsSinceLastPromotion > 3 THEN 1 ELSE 0 END)
         + (CASE WHEN MonthlyIncome < role_avg_income THEN 1 ELSE 0 END) AS risk_factors
    FROM role_avg
    WHERE Attrition = 'No'
)
SELECT risk_factors, COUNT(*) AS employees
FROM flags
GROUP BY risk_factors
ORDER BY risk_factors DESC;