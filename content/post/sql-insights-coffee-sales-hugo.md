### ☕ Project Summary: Coffee Sales Data EDA with SQL
*June 1, 2025*

This project explores transactional data from a coffee shop using only SQL, focusing on customer behavior, product popularity, and revenue trends.  
The dataset includes fields such as:  
date, datetime, coffeename, money and card (customer ID)

---

## 🔍 Objectives:
- Understand customer visit frequency and spending habits  
- Identify best-selling products overall and by month  
- Analyze revenue performance by day and hour  
- Track rolling trends using window functions (e.g. 30-day spend, visits)  

---

## 🧠 Key SQL Techniques Used:
- **Aggregations:** `SUM()`, `COUNT(DISTINCT)`  
- **Date/time functions:** `WEEK()`, `MONTH()`, `HOUR()`, `STR_TO_DATE()`  
- **Window functions:** `ROW_NUMBER()`, `RANK()`, `SUM() OVER`, `AVG() OVER`  
- **CTEs (Common Table Expressions):** For step-by-step logic building  

---

## 📈 Example Insights:
- Fridays and mornings were the most profitable periods  
- Top 3 coffee products generated up to **X%** of monthly revenue  
- Certain loyal customers returned daily and ranked highest in 30-day spend  
- A rolling view of product-level revenue showed seasonal shifts in popularity  

---

## 💡 What I Learned:
- How to use window functions for rolling metrics and ranking  
- Translating business questions into SQL queries  
- Structuring SQL analysis using clean, readable logic with CTEs  
- Gaining insights from raw transactional data using only SQL — no need for Python or BI tools!

📎 **Full SQL Code:**  
You can view all the SQL queries used in this project on GitHub:  
[🗂 View coffee_sales_eda.sql] (https://github.com/MayCodesThings/maycodesthings.github.io/blob/main/projects/coffee_sales_eda.sql)

