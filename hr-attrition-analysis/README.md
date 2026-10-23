# HR Attrition Analysis

## Business Question
Which employees are most likely to leave the company, and what factors are associated with leaving?

## Dataset
IBM HR Analytics Employee Attrition dataset (Kaggle). One table, 1,470 employees, 237 of whom left (overall attrition rate: 16.1%).

## Tools and SQL Concepts
MySQL, GROUP BY, CASE WHEN (conditional aggregation), CTEs, bucketing numeric columns into groups.

## How Attrition Rate Is Calculated
Attrition rate (%) = employees who left / total employees x 100

## Findings

| Factor | Group | Attrition Rate |
|---|---|---|
| Department | Sales | 20.63% |
| Department | Human Resources | 19.05% |
| Department | Research & Development | 13.84% |
| Overtime | Works overtime | ~30% |
| Overtime | No overtime | ~10% |
| Income | Under 3,000/month | 28.61% |
| Income | 3,000-7,999 | 12.10% |
| Income | 8,000 and above | 10.50% |
| Career experience | 0-1 years | 48.91% |
| Career experience | 2-5 years | 20.54% |
| Career experience | 6-10 years | 14.99% |
| Career experience | 10+ years | 10.05% |

## Conclusion
Of 1,470 employees, 237 left (16.1%). Sales has the highest attrition by department (20.63%). Three factors are strongly associated with leaving: overtime (about 30% vs 10%), low income (28.6% for those earning under 3,000 vs 10-12% for higher earners), and early career stage (48.9% for 0-1 years of experience vs about 10% for 10+ years).

## Recommendations
- Review overtime policy, especially in Sales.
- Run a pay review for the lowest income band.
- Improve onboarding and support for early-career hires.

## Limitations
These results show association, not proven causation. Groups overlap (for example, low-income employees may also be the early-career ones), so a next step would be checking combinations of factors. HR is a small department (63 employees), so its rate is less reliable.

## Files
- `queries.sql`: all queries used
