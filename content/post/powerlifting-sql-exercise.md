---
title: " 🏋️‍♀️ Analyzing Powerlifting Performance with SQL"
date: 2025-06-05
tags: ["SQL", "Powerlifting", "Data Analysis", "Portfolio Project"]
description: "A study session where I used SQL to explore performance trends in a powerlifting dataset, practicing aggregation, ranking, and window functions."
---

In this study exercise, I used SQL to analyze a powerlifting dataset with the goal of uncovering patterns in lifter performance. It was a great opportunity to apply analytical thinking and practice using common SQL functions like `GROUP BY`, `JOIN`, `WINDOW FUNCTIONS`, and `CTEs`.

---

## 🏋️ What I Explored

Here’s a summary of the insights I generated through SQL:

###  1.Average Performance by Lift Type  
I calculated the average weight lifted for each lift type to see which ones tend to be heavier overall.

### 2.Personal Bests  
For each lifter, I pulled out their heaviest single lift to understand their personal top performance.

### 3.Most Consistent High Performer  
I identified the lifter with the highest **total weight lifted** across all entries — a good proxy for consistent strength over time.

### 4.Lifts by Weight Class  
To explore participation, I counted how many lifts were performed in each weight class.

### 5.Versatile Lifters  
I highlighted lifters who competed in **more than one type of lift** — showing versatility.

### 6.Performance Over Time  
I tracked performance improvement over age for each lifter and lift type to spot those who got stronger with time.

### 7.Top Lifters by Lift Type  
Using rankings, I found the **top lifter (name + weight class)** for each lift type — based on the heaviest lift.

### 8.Average Lift by Age Group  
I grouped lifters into age bands (e.g., 20–29, 30–39) and calculated their average lifts — to look at age vs. strength.

### 9.Weight Class Normalization  
I cleaned the Weight Class values for analysis and began exploring the correlation between weight class and lift capacity.

### 10. Global Lift Rankings  
Finally, I ranked every lift from heaviest to lightest — creating a full leaderboard across all lifters and lift types.

---

## What I Learned

This was a fun and insightful SQL exercise! I got to:

- Use **window functions** like `RANK()` and `LAG()` to analyze performance patterns
- Work with **aggregate functions** to summarize data
- Practice building **logic-based queries** to simulate real-life business questions
- Normalize messy string data for analysis

---

All queries and insights are documented in a shareable notebook. Feel free to view or copy it from the link below: 📚👇

👉 [View on GitHub](https://github.com/MayCodesThings/maycodesthings.github.io/blob/main/powerlifting_sql_analysis_updated.ipynb)
🚀 [Open in Google Colab](https://colab.research.google.com/github/MayCodesThings/maycodesthings.github.io/blob/main/powerlifting_sql_analysis_updated.ipynb)
