select * from hr_raw;

-- creating a new table of unique values & removing duplicate rows

create table hr_clean as (select distinct * from hr_raw);

select emp_Id,count(*)  
from hr_clean  
group by emp_id
 having count(*) > 1;

SELECT *
FROM hr_clean
WHERE emp_id IN ('RM1465', 'RM1466', 'RM1467')
ORDER BY emp_Id;

SELECT *
FROM hr_clean
WHERE emp_id IN ('RM1465', 'RM1466', 'RM1467')
ORDER BY emp_Id, YearsWithCurrManager DESC;

delete from hr_clean
where emp_id in ('RM1465', 'RM1466', 'RM1467')  AND YearsWithCurrManager < (
      SELECT max_year
      FROM (
          SELECT emp_Id, MAX(YearsWithCurrManager) AS max_year
          FROM hr_clean
          WHERE emp_Id IN ('RM1465', 'RM1466', 'RM1467')
          GROUP BY emp_Id
      ) AS temp
      WHERE temp.emp_Id = hr_clean.emp_Id
  );
  
--   finding null values 

SELECT
    SUM(emp_id IS NULL) AS EmpID,
    SUM(Age IS NULL) AS Age,
    SUM(AgeGroup IS NULL) AS AgeGroup,
    SUM(Attrition IS NULL) AS Attrition,
    SUM(BusinessTravel IS NULL) AS BusinessTravel,
    SUM(DailyRate IS NULL) AS DailyRate,
    SUM(Department IS NULL) AS Department,
    SUM(DistanceFromHome IS NULL) AS DistanceFromHome,
    SUM(Education IS NULL) AS Education,
    SUM(EducationField IS NULL) AS EducationField,
    SUM(EmployeeCount IS NULL) AS EmployeeCount,
    SUM(EmployeeNumber IS NULL) AS EmployeeNumber,
    SUM(EnvironmentSatisfaction IS NULL) AS EnvironmentSatisfaction,
    SUM(Gender IS NULL) AS Gender,
    SUM(HourlyRate IS NULL) AS HourlyRate,
    SUM(JobInvolvement IS NULL) AS JobInvolvement,
    SUM(JobLevel IS NULL) AS JobLevel,
    SUM(JobRole IS NULL) AS JobRole,
    SUM(JobSatisfaction IS NULL) AS JobSatisfaction,
    SUM(MaritalStatus IS NULL) AS MaritalStatus,
    SUM(MonthlyIncome IS NULL) AS MonthlyIncome,
    SUM(SalarySlab IS NULL) AS SalarySlab,
    SUM(MonthlyRate IS NULL) AS MonthlyRate,
    SUM(NumCompaniesWorked IS NULL) AS NumCompaniesWorked,
    SUM(Over18 IS NULL) AS Over18,
    SUM(OverTime IS NULL) AS OverTime,
    SUM(PercentSalaryHike IS NULL) AS PercentSalaryHike,
    SUM(PerformanceRating IS NULL) AS PerformanceRating,
    SUM(RelationshipSatisfaction IS NULL) AS RelationshipSatisfaction,
    SUM(StandardHours IS NULL) AS StandardHours,
    SUM(StockOptionLevel IS NULL) AS StockOptionLevel,
    SUM(TotalWorkingYears IS NULL) AS TotalWorkingYears,
    SUM(TrainingTimesLastYear IS NULL) AS TrainingTimesLastYear,
    SUM(WorkLifeBalance IS NULL) AS WorkLifeBalance,
    SUM(YearsAtCompany IS NULL) AS YearsAtCompany,
    SUM(YearsInCurrentRole IS NULL) AS YearsInCurrentRole,
    SUM(YearsSinceLastPromotion IS NULL) AS YearsSinceLastPromotion,
    SUM(YearsWithCurrManager IS NULL) AS YearsWithCurrManager
FROM hr_clean;
  
--   checking the text columns that contains blank values

SELECT *
FROM hr_clean
WHERE emp_id = ''
   OR AgeGroup = ''
   OR Attrition = ''
   OR BusinessTravel = ''
   OR Department = ''
   OR EducationField = ''
   OR Gender = ''
   OR JobRole = ''
   OR MaritalStatus = ''
   OR Over18 = ''
   OR OverTime = ''
   OR SalarySlab = '';
   
   
--    checking inconsistent data

SELECT DISTINCT Department
FROM hr_clean;

SELECT DISTINCT Gender
FROM hr_clean;

SELECT DISTINCT Attrition
FROM hr_clean;

SELECT DISTINCT BusinessTravel
FROM hr_clean;

UPDATE hr_clean
SET BusinessTravel = 'Travel_Rarely'
WHERE BusinessTravel = 'TravelRarely';

SELECT DISTINCT JobRole
FROM hr_clean;

SELECT DISTINCT MaritalStatus
FROM hr_clean;

SELECT DISTINCT OverTime
FROM hr_clean;

-- numeric columns validation

SELECT *
FROM hr_clean
WHERE Age <= 0 OR Age > 100;
  
  SELECT MIN(MonthlyIncome) AS min_income,
       MAX(MonthlyIncome) AS max_income
FROM hr_clean;


SELECT *
FROM hr_clean
WHERE YearsAtCompany > TotalWorkingYears
   OR YearsInCurrentRole > YearsAtCompany
   OR YearsWithCurrManager > YearsAtCompany;

select * from hr_clean where  YearsWithCurrManager is null ;








