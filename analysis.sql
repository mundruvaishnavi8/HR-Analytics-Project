
-- 3. Analysis questions (SQL)
-- Attrition overview
-- What is the overall attrition count and rate?

with attritioncount as (select count(case when Attrition ="yes" then 1 end) as attrition_count,count(Attrition) as total_employees
from hr_clean)
select total_employees, attrition_count, (attrition_count/total_employees)*100 as attrition_rate from attritioncount;

-- answer:- 
-- attrition_count : 229
-- attrition_rate : 16.20

-- Attrition rate by department, job role, gender, and marital status?

-- attrition rate by Department
select 
Department,
count(case when Attrition = "Yes" then 1 end) * 100 / count(Attrition) as attrition_rate
from hr_clean group by Department;

-- answer:-
-- sales has the highest attrition rate of 20.78% followed by human Resources with 19.35% and last Research & development with 13.83%

-- attrition rate by Jobrole
 select 
    JobRole ,
round(count(case when Attrition = "Yes" then 1 end) * 100 / count(Attrition)) as attrition_rate
from hr_clean group by Jobrole order by attrition_rate desc;

-- Answer:-

-- Sales Representative highest (~40%), then Laboratory Technician (~24%) and 
-- Human Resources (~23%). Research Director and Manufacturing Director are lowest (~2-7%).
-- attrition rate by Gender
select 
    Gender,
count(case when Attrition = "Yes"  then 1 end) * 100 / count(Attrition) as attrition_rate
from hr_clean group by Gender;

-- Answer:-
-- Male ~17.11%, Female ~14.84% (small gap)

-- attrition rate by martialstatus

select 
    MaritalStatus,
count(case when Attrition = "Yes"  then 1 end) * 100 / count(Attrition) as attrition_rate
from hr_clean group by MaritalStatus;

-- Answer:-
-- Single ~26.2%, Married ~12.5%, Divorced ~10.1%

-- Which age group and salary slab have the highest attrition?
-- Attrition rate by Agegroup
select AgeGroup,count(case when Attrition = "Yes" then 1 end) * 100/count(Attrition) as attrition_rate 
from  hr_clean
group by AgeGroup order by attrition_rate desc;

-- answer:-
-- Age group: 18-25 has the highest attrition, then 26-35. It falls after 55+, and 36-45 is lowest.

-- Attrition rate by SalarySlab
select SalarySlab,count(case when Attrition = "Yes" then 1 end) * 100/count(Attrition) as attrition_rate 
from  hr_clean
group by SalarySlab order by attrition_rate desc;

-- answer:-
--  Under ~$3,000 monthly income has the highest attrition. It drops sharply as income rises.

-- Does overtime change attrition? By how many percentage points?
select OverTime,count(case when Attrition = "Yes" then 1 end) * 100/count(Attrition) as attrition_rate 
from  hr_clean
group by OverTime order by attrition_rate desc;

-- answer:-

-- Yes, strongly. In the IBM HR dataset, attrition is about 30.86% with overtime vs 10.31% 
-- without, a gap of roughly 20 percentage points (about 3x the rate).


-- Does business travel frequency affect attrition?

select BusinessTravel,count(case when Attrition = "Yes" then 1 end) * 100/count(Attrition) as attrition_rate 
from  hr_clean
group by BusinessTravel order by attrition_rate desc;

-- answer:-

-- Yes, attrition rises with travel frequency. Approximate IBM HR dataset results :

-- Travel_Frequently: ~25%
-- Travel_Rarely: ~15.0%
-- Non-Travel: ~8.16%


-- Is attrition higher among employees with less than 2 years of tenure?
SELECT
  CASE
    WHEN YearsAtCompany < 2 THEN '0-1'
    WHEN YearsAtCompany < 5 THEN '2-4'
    WHEN YearsAtCompany < 10 THEN '5-9'
    ELSE '10+'
  END AS tenure_band,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_rate
FROM hr_clean
GROUP BY tenure_band
ORDER BY attrition_rate desc;

-- answer:-

-- Yes. In the IBM HR dataset, attrition is highest in the first years at the company. Approximate results (verify on your copy):
-- Under 2 years (YearsAtCompany < 2): ~35.8%
-- 2+ years: ~18%

-- How does attrition vary by distance from home (bucketed)?
SELECT
  CASE
    WHEN DistanceFromHome <= 5  THEN '1-5'
    WHEN DistanceFromHome <= 10 THEN '6-10'
    WHEN DistanceFromHome <= 20 THEN '11-20'
    ELSE '21-29'
  END AS distance_band,
  COUNT(*) AS total,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
  ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_pct
FROM hr_clean
GROUP BY distance_band
ORDER BY MIN(DistanceFromHome);

-- answer:-

-- Attrition rises with commute distance, but the pattern is moderate and gets
--  noisy in the far buckets. Approximate IBM HR dataset results:

-- 1-5 km: ~14%
-- 6-10 km: ~14%
-- 11-20 km: ~20%
-- 21-29 km: ~22%

-- Roughly a 9-point gap between the nearest and farthest groups. 
-- DistanceFromHome ranges 1-29 in this dataset, and the far buckets are smaller, so state sample size next to each rate.

-- Do employees with no stock options leave more often?

SELECT StockOptionLevel,
       COUNT(*) AS total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
       ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS attrition_pct
FROM hr_clean
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;

-- answer:-

-- Yes. In the IBM HR dataset, StockOptionLevel 0 has the
--  highest attrition. Approximate results:

-- Level 0 (no options): ~25%
-- Level 1: ~9.4%
-- Level 2: ~7.1%
-- Level 3: ~17.1%

-- That is a gap of about 16 percentage points between no options and 
-- Level 1. Level 3 is a small group (~85 employees), so its rate is noisy; state sample size next to each rate.


-- Compensation & promotion
-- 9. Average monthly income by job role and job level.
select JobRole,JobLevel,avg(MonthlyIncome)  as average_monthly_income
from hr_clean 
group by JobRole,JobLevel order by average_monthly_income desc;

-- answer:-

-- Managers and Research Directors earn the most.
-- Sales Representatives earn the least. This is the same role that has the highest attrition (39.76%).
-- Income rises with job level within each role.
-- Blank cells are role and level combinations that don’t exist in the data,
--  which is why the first query only returns the combinations that exist.

-- 10. Is there a gender pay gap within the same job level and role?

-- 10. Is there a gender pay gap within the same job level and role?

SELECT
    JobRole,
    JobLevel,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
    SUM(CASE WHEN Gender = 'Male'   THEN 1 ELSE 0 END) AS male_count,
    ROUND(AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END), 0) AS avg_income_female,
    ROUND(AVG(CASE WHEN Gender = 'Male'   THEN MonthlyIncome END), 0) AS avg_income_male,
    ROUND(100.0 * (AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END)
                 - AVG(CASE WHEN Gender = 'Male'   THEN MonthlyIncome END))
          / AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END), 1) AS gap_pct_female_vs_male
FROM hr_clean
GROUP BY JobRole, JobLevel
ORDER BY JobRole, JobLevel;

-- Answer:- no consistent gender pay gap.

-- the overall averages are Female 6,687 and Male 6,381, so women’s average is slightly higher.
--  That figure alone doesn’t answer the question, because it doesn’t control for role and level.

-- 11. Which roles have the lowest average income and the highest attrition?
select JobRole,avg(MonthlyIncome) as average_monthly_income,count(case when Attrition = "Yes" then 1 end) * 100 / count(*) as Rate
from hr_clean
group by JobRole 
order by average_monthly_income asc;

-- Answer: Sales Representative has both the lowest average income (2,626) and the highest attrition (40.24%). 
-- Laboratory Technician (24.19%) and Human Resources (23.52%) come next.
--  Both have low income and attrition above the company average of 16.12%.

-- 12. Average YearsSinceLastPromotion for leavers vs. stayers.

-- 12. Average YearsSinceLastPromotion for leavers vs. stayers

SELECT
    (CASE WHEN Attrition = 'Yes' THEN 'Leavers' ELSE 'Stayers' END) AS employee_group,
    COUNT(*) AS employees,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS avg_years_since_promotion
FROM hr_clean
GROUP BY Attrition
ORDER BY Attrition DESC;

-- Answer:- Leavers were promoted slightly more recently (1.94 years) than stayers (2.27 years). The median is 1 year for both groups.

-- 13. Does percent salary hike differ between leavers and stayers?
-- 13. Does percent salary hike differ between leavers and stayers?

SELECT
    CASE WHEN Attrition = 'Yes' THEN 'Leavers' ELSE 'Stayers' END AS employee_group,
    COUNT(*)  AS employees,
    ROUND(AVG(PercentSalaryHike), 2) AS avg_percent_salary_hike,
    MIN(PercentSalaryHike) AS min_hike,
    MAX(PercentSalaryHike) AS max_hike
FROM hr_clean
GROUP BY Attrition
ORDER BY Attrition DESC;

-- Answer: No. Leavers averaged a 15.06% hike and stayers 15.22%, 
-- a difference of 0.13 percentage points. The median is 14% for both groups, and both span the same 11–25% range.

-- 14. Top 5 highest-paid employees per department (DENSE_RANK).
-- 14. Top 5 highest-paid employees per department (DENSE_RANK)

SELECT Department, income_rank, emp_Id, JobRole, MonthlyIncome, Attrition
FROM (
    SELECT
        Department,
        emp_Id,
        JobRole,
        MonthlyIncome,
        Attrition,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS income_rank
    FROM hr_clean
) ranked
WHERE income_rank <= 5
ORDER BY Department, income_rank;

-- answer:- almost all top earners are Managers. R&D rank 2 (RM747) is the only Research Director.
--  Two of the 15 left the company: RM569 in R&D and RM750 in Sales.

-- Satisfaction & performance

-- 15. Average job Satisfaction, environment, and work-life balance scores for leavers vs. stayers.

SELECT
    CASE WHEN Attrition = 'Yes' THEN 'Leavers' ELSE 'Stayers' END AS employee_group,
    COUNT(*) AS employees,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS avg_environment_satisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS avg_work_life_balance
FROM hr_clean
GROUP BY Attrition
ORDER BY Attrition DESC;


-- Answer: Leavers score lower on all three measures.

-- Job satisfaction is 0.30 lower (2.48 vs 2.78).
-- Environment satisfaction is 0.29 lower (2.48 vs 2.77).
-- Work-life balance is 0.12 lower (2.66 vs 2.78).

-- 16. Which departments have the lowest job satisfaction?

-- 16. Which departments have the lowest job satisfaction?

SELECT
    Department,
    COUNT(*) AS employees,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction,
    ROUND(100.0 * SUM(CASE WHEN JobSatisfaction <= 2 THEN 1 ELSE 0 END)
          / COUNT(*), 2) AS pct_low_satisfaction
FROM hr_clean
GROUP BY Department
ORDER BY avg_job_satisfaction ASC;

-- Answer: Human Resources has the lowest job satisfaction (2.58), and nearly half its employees (49.21%) rate it 1 or 2.
--  R&D (2.73) and Sales (2.74) are almost identical to each other and to the company average.

-- 17. Do high performers (rating 4) leave more or less than rating 3?

-- 17. Do high performers (rating 4) leave more or less than rating 3?

SELECT
    PerformanceRating,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)  AS attrition_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
          / COUNT(*), 2) AS attrition_rate_pct
FROM hr_clean
GROUP BY PerformanceRating
ORDER BY PerformanceRating;

-- Answer: About the same. High performers (rating 4) leave at 16.26% and rating 3 employees at 15.89%,
--  a difference of 0.37 percentage points. That is too small to matter

-- 18. Does training frequency relate to performance or attrition?

-- 18. Does training frequency relate to performance or attrition?

SELECT
    TrainingTimesLastYear,
    COUNT(*) AS employees,
    ROUND(AVG(PerformanceRating), 2) AS avg_performance_rating,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)  AS attrition_count,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
          / COUNT(*), 2)  AS attrition_rate_pct
FROM hr_clean
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear;

-- answer:-

-- Performance: no relationship. Average performance rating stays between 3.14 and 3.19 at every training level.

-- Attrition: a weak relationship.

-- Employees with no training have the highest attrition (26.92%, though only 52 people).
-- Attrition tends to be lower at 5–6 trainings (11.76% and 9.23%).
-- The pattern isn’t smooth. Employees with 4 trainings leave at 22.22%, higher than those with 3 trainings (14.32%).



-- Advanced SQL (shows skill)
-- 19. Attrition rate per department compared with the company average (window function).

-- 19. Attrition rate per department compared with the company average (window function)

WITH dept AS (
    SELECT
        Department,
        COUNT(*)                                            AS employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)  AS attrition_count
    FROM hr_clean
    GROUP BY Department
),
rates AS (
    SELECT
        Department,
        employees,
        attrition_count,
        ROUND(100.0 * attrition_count / employees, 2)                       AS dept_rate_pct,
        ROUND(100.0 * SUM(attrition_count) OVER () / SUM(employees) OVER (), 2) AS company_rate_pct
    FROM dept
)
SELECT
    Department,
    employees,
    attrition_count,
    dept_rate_pct,
    company_rate_pct,
    ROUND(dept_rate_pct - company_rate_pct, 2) AS diff_vs_company_pp
FROM rates
ORDER BY dept_rate_pct DESC;

select 13.83 -16.21;

-- Answer: Sales is 4.58  points above the company average, and HR is 3.14 points above. R&D is 2.38 points below.
--  R&D is the largest department (918 people), 
-- and it has the lowest attrition.

-- 20. Flag “high-risk” current employees: overtime = Yes, job satisfaction ≤ 2, more than 3 years since last promotion, income below their role’s average (CTE + CASE).

-- 20. Flag "high-risk" current employees:
--     overtime = Yes, job satisfaction <= 2, more than 3 years since last promotion,
--     income below their role's average

WITH role_avg AS (
    SELECT
        *,
        AVG(MonthlyIncome) OVER (PARTITION BY JobRole) AS role_avg_income
    FROM hr_clean
),
flags AS (
    SELECT
        emp_id, Department, JobRole, MonthlyIncome, role_avg_income,
        JobSatisfaction, YearsSinceLastPromotion, OverTime,
        CASE WHEN OverTime = 'Yes'                    THEN 1 ELSE 0 END AS f_overtime,
        CASE WHEN JobSatisfaction <= 2                THEN 1 ELSE 0 END AS f_low_satisfaction,
        CASE WHEN YearsSinceLastPromotion > 3         THEN 1 ELSE 0 END AS f_no_promotion,
        CASE WHEN MonthlyIncome < role_avg_income     THEN 1 ELSE 0 END AS f_below_role_avg
    FROM role_avg
    WHERE Attrition = 'No'                -- current employees only
)
SELECT
    emp_id, Department, JobRole,
    MonthlyIncome, ROUND(role_avg_income, 0) AS role_avg_income,
    JobSatisfaction, YearsSinceLastPromotion, OverTime,
    f_overtime + f_low_satisfaction + f_no_promotion + f_below_role_avg AS risk_factors,
    CASE
        WHEN f_overtime + f_low_satisfaction + f_no_promotion + f_below_role_avg = 4 THEN 'High Risk'
        WHEN f_overtime + f_low_satisfaction + f_no_promotion + f_below_role_avg = 3 THEN 'Watch'
        ELSE 'Normal'
    END AS risk_flag
FROM flags
ORDER BY risk_factors DESC, MonthlyIncome ASC;

-- Answer: 12 current employees meet all four conditions. They are in R&D (9) and Sales (4).
--  By role, Research Scientist, Manager, and Sales Executive have 3
--  each, Manufacturing Director has 2, and Laboratory Technician and Healthcare Representative have 1 each.

-- 21. Rank job roles by attrition rate within each department.

-- 21. Rank job roles by attrition rate within each department

SELECT
    Department,
    JobRole,
    employees,
    attrition_count,
    attrition_rate_pct,
    RANK() OVER (PARTITION BY Department ORDER BY attrition_rate_pct DESC) AS rank_in_dept
FROM (
    SELECT
        Department,
        JobRole,
        COUNT(*)                                            AS employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)  AS attrition_count,
        ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
              / COUNT(*), 2)                                AS attrition_rate_pct
    FROM hr_clean
    GROUP BY Department, JobRole
) t
ORDER BY Department, rank_in_dept;


-- Answer: The top-ranked (highest attrition) role in each department is Sales Representative in Sales (40.24%),
--  Laboratory Technician in R&D (24.19%), and 
-- the HR role in Human Resources (23.53%). In every department, Managers rank at or near the bottom.
