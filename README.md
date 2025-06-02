# LPS-SQL-General-Demographics

A comprehensive SQL report for Lawrence Public Schools that provides demographic breakdowns and percentage calculations for students, including SPED, 504 Plan, English Learner (EL), Gender, and Race/Ethnicity.

## Table of Contents
- [Features](#features)
- [How Percentages Are Calculated](#how-percentages-are-calculated)
    - [Sample SQL Snippet](#sample-sql-snippet)
- [Key Field Access](#key-field-access)
- [Usage](#usage)

## Features
- SPED (Special Education) breakdown
- 504 Plan status breakdown
- English Learner (EL) status breakdown
- Gender breakdown
- Race/Ethnicity breakdown (with human-readable labels)
- Percentage calculations for each category

## How Percentages Are Calculated
Percentages are calculated by dividing the count for each category by the total number of students, then multiplying by 100. For example:

| Category | Count | Total | Percent |
|----------|-------|-------|---------|
| Yes      | 25    | 100   | 25.00   |
| No       | 75    | 100   | 75.00   |

In SQL, this is done using window functions:
```sql
ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percent
```
This ensures each row shows its share of the total as a percentage, rounded to two decimal places.

### Sample SQL Snippet
```sql
-- Step 1: Group students by SPED status (Yes/No/Unknown)
SELECT
    CASE WHEN LOWER(ext.SPED) = 'yes' THEN 'Yes'
         WHEN LOWER(ext.SPED) = 'no' THEN 'No'
         ELSE 'Unknown' END AS sped_code, -- Group label
    -- Step 2: Count students in each group
    COUNT(*) AS sped_count,
    -- Step 3: Calculate percent of total students in each group
    --   ROUND(..., 2): Rounds the result to 2 decimal places for readability
    --   100.0 * ...: Multiplies by 100 to convert the ratio to a percent
    --   COUNT(*): The number of students in this group (e.g., SPED = 'Yes')
    --   SUM(COUNT(*)) OVER (): Calculates the total number of students across all groups
    --   OVER (): The window function, with empty parentheses, means the sum is over the entire result set
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS sped_percent
FROM students stu
LEFT JOIN U_DEF_EXT_STUDENTS ext ON stu.dcid = ext.STUDENTSDCID -- Join to get SPED info
GROUP BY CASE WHEN LOWER(ext.SPED) = 'yes' THEN 'Yes'
              WHEN LOWER(ext.SPED) = 'no' THEN 'No'
              ELSE 'Unknown' END
-- Step 4: Each row shows the group label, count, and percent of total
```

## Key Field Access
- **SPED**: Accessed via `ext.SPED` from the `U_DEF_EXT_STUDENTS` table (joined on `stu.dcid = ext.STUDENTSDCID`).
- **504 Plan**: Accessed via `sped.SEC504PLANSTATUS` from the `PS.S_MA_STU_SPED_X` table (joined on `stu.dcid = sped.STUDENTSDCID`).
- **English Learner (EL)**: Accessed via `ext.EL` from the `U_DEF_EXT_STUDENTS` table.
- **Gender**: Accessed via `stu.gender` from the `students` table.
- **Ethnicity**: Accessed via `stu.ethnicity` (code) and mapped to a label using a CASE statement in SQL.


## Usage
1. Run the SQL script (`general_demographics.sql`) in your database environment.
2. The report will output tables with counts and percentages for each demographic category.
3. Use the results to analyze student demographics for reporting or decision-making.

---
For more details, see the full SQL in `general_demographics.sql`.
