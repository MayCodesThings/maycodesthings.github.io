---
title: 🧠 Advanced SQL Study Project
date: 2025-06-19  
tags: [SQL, Data Analysis, Window Functions, CTE, Maven Analytics]
---

As part of my SQL learning journey, I completed this project from the **Advanced SQL course by Maven Analytics**. The challenge included multiple datasets related to baseball salaries, schools, and players. I practiced using **CTEs, window functions, ranking, aggregates, and date logic** — all in one place.

This project had three main parts: School Analysis, Salary Analysis, and Player Comparison. Here’s a quick look at what I did and what I learned along the way 👇

---

### 📚 PART I: School Analysis

### 1. How many schools produced players by decade?

```sql
SELECT
  FLOOR(yearID / 10)*10 AS decade,
  COUNT(DISTINCT schoolID) AS num_schools
FROM schools
GROUP BY decade
ORDER BY decade;
```

### 2. Top 5 schools that produced the most players

```sql
SELECT 
  sd.name_full, 
  COUNT(DISTINCT s.playerID) AS num_player
FROM 
  schools s LEFT JOIN school_details sd 
  ON s.schoolID = sd.schoolID 
GROUP BY 
  sd.name_full
ORDER BY 
  num_player DESC
LIMIT 5;
```
### 3. Top 3 schools per decade

```sql
WITH ds AS (SELECT 
              FLOOR (s.yearID/10)*10 AS decade, 
              sd.name_full,
              COUNT(DISTINCT s.playerID) AS num_player
            FROM 
              schools s LEFT JOIN school_details sd
              ON s.schoolID = sd.schoolID 
            GROUP BY
              decade,sd.name_full
),
rn AS (SELECT 
        decade,
        name_full,
        num_player,
        ROW_NUMBER () OVER (
          PARTITION BY decade ORDER BY num_player DESC
          ) AS row_num
      FROM ds)

SELECT 
	decade,
  name_full,
  num_player
FROM rn 
WHERE 
  row_num <= 3
ORDER BY 
  decade DESC, row_num;
```
### 💰 PART II: Salary Analysis
### 4. Top 20% spenders (average annual)

```sql
WITH ts AS (SELECT 
              teamID, 
              yearID, 
              SUM(salary) AS total_spend
            FROM 
              salaries
            GROUP BY
              teamID,yearID
            ORDER BY
              teamID,yearID
),
sp AS (SELECT 
          teamID,
          AVG(total_spend) AS avg_spend,
          NTILE(5) OVER (ORDER BY AVG(total_spend) DESC) AS spend_pct
        FROM ts
        GROUP BY 
          teamID
)

SELECT 
  teamID,
  ROUND(avg_spend/1000000,1) AS avg_spend_million
FROM 
	sp
WHERE 
  spend_pct = 1; 
```
### 5. Cumulative spending over the years

```sql
WITH ts AS (SELECT 
              teamID,
              yearID, 
              SUM(salary) AS total_spend
            FROM 
              salaries
            GROUP BY
              teamID,yearID
            ORDER BY
              teamID,yearID
)
                      
SELECT 
  teamID,
  yearID,
  ROUND(SUM(total_spend) OVER (
    PARTITION BY teamID ORDER BY yearID )/1000000,1
      ) AS cumulative_sum_million
FROM 
	ts;
```

### 6. When did each team pass $1 billion in total spend?

```sql
WITH ts AS (SELECT 
              teamID, 
              yearID, 
              SUM(salary) AS total_spend
            FROM 
              salaries
            GROUP BY
              teamID,yearID
            ORDER BY
              teamID,yearID
),
                
cs AS (SELECT 
        teamID,
        yearID,
        SUM(total_spend) OVER (
          PARTITION BY teamID ORDER BY yearID 
            ) AS cumulative_sum
        FROM ts
),

rn AS (SELECT 
          teamID, 
          yearID, 
          cumulative_sum,
          ROW_NUMBER() OVER (
            PARTITION BY teamID ORDER BY cumulative_sum
              ) AS rn
        FROM cs
			  WHERE 
        cumulative_sum > 1000000000)

SELECT 
	teamID,
  yearID,
  ROUND(cumulative_sum/1000000000,2 ) AS cumulative_sum_billion
FROM rn
WHERE 
	rn = 1;
```

### 👥 PART III: Player Comparison
### 7. Which players have the same birthday?

```sql
WITH bn AS (SELECT 
              CAST(CONCAT(birthYear,"-", birthMonth,"-", birthDay) AS DATE) AS birthDate,
              nameGiven
            FROM players
)
        
SELECT 
  birthDate,
  GROUP_CONCAT(nameGiven SEPARATOR ", ") AS players
FROM 
  bn
WHERE 
  YEAR(birthDate) BETWEEN 1980 AND 1990
GROUP BY birthDate
ORDER BY birthDate;
```

### 8. What percent of players bat left, right, or both?

```sql
SELECT
  s.teamID, 
  ROUND(SUM(CASE WHEN p.bats = 'R' THEN 1 ELSE 0 END )/COUNT(s.playerID)*100,1) AS bats_right,
  ROUND(SUM(CASE WHEN p.bats = 'L' THEN 1 ELSE 0 END)/COUNT(s.playerID)*100,1) AS bats_left,
  ROUND(SUM(CASE WHEN p.bats = 'B' THEN 1 ELSE 0 END)/COUNT(s.playerID)*100,1)AS bats_both
FROM 
  salaries s LEFT JOIN players p
  ON s.playerID = p.playerID 
GROUP BY s.teamID;
```

### 9. How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
```sql
WITH hw AS (SELECT 
              FLOOR(YEAR(STR_TO_DATE(debut, '%m/%d/%y')) / 10) * 10 AS decade,
              AVG(height) AS avg_height,
              AVG(weight) AS avg_weight
          FROM players
          WHERE 
            STR_TO_DATE(debut, '%m/%d/%y') IS NOT NULL
          GROUP BY decade
)

SELECT
  decade,
  avg_height - LAG(avg_height) OVER(ORDER BY decade) AS height_diff,
  avg_weight - LAG(avg_weight) OVER(ORDER BY decade) AS weight_diff
FROM
  hw;
```


#### What I Learned
- How to use window functions like ROW_NUMBER(), LAG(), NTILE(), and SUM() OVER
- How CTEs can help structure multi-step logic clearly
- How to write better SQL for real-world analysis: clean, readable, and efficient

--- 

Thanks for reading 💻✨
