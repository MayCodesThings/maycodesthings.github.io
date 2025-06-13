---
title: "🏋️‍♀️ Analyzing Powerlifting Performance with SQL"
date: 2025-06-05
tags: ["SQL", "Powerlifting", "Data Analysis", "Portfolio Project"]
description: "A study session where I used SQL to explore performance trends in a powerlifting dataset, practicing aggregation, ranking, and window functions."
---

In this study exercise, I used SQL to analyze a powerlifting dataset with the goal of uncovering patterns in lifter performance. It was a great opportunity to apply analytical thinking and practice using common SQL functions like `GROUP BY`, `JOIN`, `WINDOW FUNCTIONS`, and `CTEs`.

---

## 🏋️ What I Explored

Here’s a summary of the insights I generated through SQL:

### 1. Average Performance by Lift Type
```sql
SELECT 
    `Lift Type`,
    AVG(`Amount Lifted (kg)`) AS avg_lift
FROM 
    powerlifting_dataset
GROUP BY 
    `Lift Type`;
```
### 2.2. Heaviest Lift Per Lifter
```sql
SELECT 
    `Lifter Name`, 
    MAX(`Amount Lifted (kg)`) AS max_amount_lifted
FROM 
    powerlifting_dataset
GROUP BY 
    `Lifter Name`;
```
### 3. Lifter with the Highest Total Amount Lifted
```sql
SELECT 
    `Lifter Name`, 
    SUM(`Amount Lifted (kg)`) AS total_amount_lifted
FROM 
    powerlifting_dataset
GROUP BY 
    `Lifter Name`
ORDER BY 
    total_amount_lifted DESC
LIMIT 1;
```
### 4. Total Lifts Per Weight Class
``` sql
SELECT 
    COUNT(`Amount Lifted (kg)`) AS total_lifted, 
    `Weight Class`
FROM 
    powerlifting_dataset
GROUP BY 
    `Weight Class`;
```
### 5. Lifters Who Performed More Than One Lift Type
``` sql
SELECT 
    `Lifter Name`
FROM 
    powerlifting_dataset
GROUP BY 
    `Lifter Name`
HAVING 
    COUNT(DISTINCT `Lift Type`) > 1;
```
### 6. Lifters Who Improved Over Time
``` sql
WITH pf AS (
    SELECT 
        `Lifter Name`, 
        `Age`, 
        `Lift Type`, 
        `Amount Lifted (kg)` AS amount, 
        LAG(`Amount Lifted (kg)`) OVER (
            PARTITION BY `Lifter Name`, `Lift Type`
            ORDER BY `Age`
        ) AS previous_lift
    FROM 
        powerlifting_dataset
) 
SELECT * 
FROM pf 
WHERE 
    amount > previous_lift;
```
### 7. Top Lifter by Lift Type
``` sql
WITH rank_lift AS (
    SELECT 
        `Lifter Name`, 
        `Weight Class`, 
        `Lift Type`, 
        `Amount Lifted (kg)` AS Amount, 
        ROW_NUMBER () OVER (
            PARTITION BY `Lift Type` 
            ORDER BY `Amount Lifted (kg)` DESC 
        ) AS row_nm
    FROM 
        powerlifting_dataset
) 
SELECT 
    `Lifter Name`, 
    `Weight Class`, 
    `Lift Type`,
    Amount
FROM rank_lift
WHERE row_nm = 1;
```

### 8. Average Lifted by Age Group
``` sql
SELECT 
    CONCAT(FLOOR(Age / 10) * 10, '-' ,FLOOR(Age / 10) * 10 + 9) AS age_group, 
    ROUND(AVG(`Amount Lifted (kg)`)) AS avg_lifted
FROM 
    powerlifting_dataset
GROUP BY
    age_group
ORDER BY 
    age_group;
```
### 9. Normalize Weight Class and Explore Correlation
``` sql

SELECT 
    REPLACE(`Weight Class`, 'kg', '') AS weight_class_kg, 
    `Amount Lifted (kg)`
FROM 
    powerlifting_dataset
WHERE 
    `Weight Class` IS NOT NULL
    AND `Amount Lifted (kg)` IS NOT NULL;
```
### 10. Global Lift Ranking
``` sql

SELECT 
    `Lifter Name`, 
    `Lift Type`, 
    `Amount Lifted (kg)`, 
    RANK () OVER (
        ORDER BY `Amount Lifted (kg)` DESC
    ) AS `rank` 
FROM 
    powerlifting_dataset;
```
     

























