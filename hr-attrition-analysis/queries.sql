-- HR Attrition Analysis (IBM HR dataset, 1,470 employees)

-- 1. Attrition rate by department
SELECT 
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_attrition
GROUP BY Department;

-- 2. Attrition rate by overtime
SELECT 
    OverTime,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_attrition
GROUP BY OverTime;

-- 3. Attrition rate by income group
WITH income_bucket AS (
    SELECT 
        Attrition,
        CASE
            WHEN MonthlyIncome < 3000 THEN 'Low'
            WHEN MonthlyIncome < 8000 THEN 'Medium'
            ELSE 'High'
        END AS income_group
    FROM hr_attrition
)
SELECT 
    income_group,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM income_bucket
GROUP BY income_group
ORDER BY attrition_rate DESC;

-- 4. Attrition rate by career experience
WITH emp_tenure AS (
    SELECT 
        Attrition,
        CASE 
            WHEN TotalWorkingYears <= 1 THEN '0-1 Years'
            WHEN TotalWorkingYears <= 5 THEN '2-5 Years'
            WHEN TotalWorkingYears <= 10 THEN '6-10 Years' 
            ELSE '10+ Years'
        END AS tenure
    FROM hr_attrition
)
SELECT 
    tenure,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM emp_tenure
GROUP BY tenure
ORDER BY attrition_rate DESC;
