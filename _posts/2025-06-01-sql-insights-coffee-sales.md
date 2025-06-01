---
layout: post
title: "SQL Insights from Coffee Sales Data"
date: 2025-06-01
author: May Hnin Phyu
categories: [SQL, Data Analysis, Portfolio]
---

Ever wondered what kind of insights you can pull from a coffee shop’s sales data? ☕  
In this post, I’ll walk through some SQL exercises I did using a sample dataset — exploring customer behavior, revenue trends, and product performance using pure SQL.

---
```python

```

## Unique customers per day
```sql
SELECT
    date,
    COUNT(DISTINCT card) AS unique_customers
FROM coffee.index_1
GROUP BY date
ORDER BY date;
```



## Most popular products overall
```sql
SELECT coffee_name, COUNT(*) AS popularity
FROM coffee.index_1
GROUP BY coffee_name
ORDER BY popularity DESC;
```



##Unique customers per week & month
```sql
SELECT
    WEEK(date, 1) AS week,
    MONTH(date) AS month,
    COUNT(DISTINCT card) AS unique_customers
FROM coffee.index_1
GROUP BY WEEK(date, 1), MONTH(date)
ORDER BY WEEK(date, 1), MONTH(date);
```


## Most popular products monthly
```sql
SELECT
    DATE_FORMAT(STR_TO_DATE(date, '%Y-%m-%d'), '%Y-%m') AS sale_month,
    coffee_name,
    COUNT(*) AS popularity
FROM coffee.index_1
GROUP BY coffee_name, sale_month
ORDER BY sale_month ASC, popularity DESC;
```



## Percentage of monthly revenue for top 3 products
```sql
WITH MonthlyProductCounts AS (
    SELECT
        DATE_FORMAT(STR_TO_DATE(date, '%Y-%m-%d'), '%Y-%m') AS sale_month,
        coffee_name,
        COUNT(*) AS popularity_count,
        ROUND(SUM(money)) AS revenue
    FROM
		coffee.index_1
    GROUP BY
		sale_month, coffee_name
),
RankedProducts AS (
    SELECT
        sale_month,
        coffee_name,
        popularity_count,
        ROW_NUMBER() OVER (PARTITION BY sale_month ORDER BY popularity_count DESC) AS rn,
        revenue,
        SUM(revenue) OVER (PARTITION BY sale_month) AS total_monthly_revenue
    FROM
		MonthlyProductCounts
)
SELECT
    sale_month,
    coffee_name,
    popularity_count,
    rn,
    revenue,
    total_monthly_revenue,
    ROUND(revenue / total_monthly_revenue * 100) AS percentage_monthly_revenue
FROM
	RankedProducts
WHERE
	rn IN (1, 2, 3)
ORDER BY
	sale_month;
  ```

## Historical revenue per day
``` sql
SELECT
    date,
    ROUND(SUM(money)) AS daily_revenue
FROM coffee.index_1
GROUP BY date
ORDER BY date;
```

## Historical revenue over the last 30 days per product
``` sql
WITH dr AS (
    SELECT
        STR_TO_DATE(date,'%Y-%m-%d') AS date,
        ROUND(SUM(money)) AS daily_revenue,
        coffee_name
    FROM
		coffee.index_1
    GROUP BY
		date, coffee_name
)
SELECT
    *,
    ROUND(AVG(daily_revenue) OVER (
        PARTITION BY coffee_name
        ORDER BY date ASC
        ROWS BETWEEN 30 PRECEDING AND CURRENT ROW
    )) AS last_30days_revenue
FROM dr;
```

## Most active hours in terms of revenue
``` sql
WITH sh AS (
    SELECT
        *,
        HOUR(STR_TO_DATE(datetime, '%Y-%m-%d %H:%i:%s.%f')) AS sale_hour
    FROM coffee.index_1
)
SELECT
    ROUND(SUM(money)) AS revenue,
    sale_hour
FROM sh
GROUP BY
	sale_hour
ORDER BY
	revenue DESC;
  ```

## Top spending customers over past 30 days
``` sql
WITH CustomerSpending AS (
    SELECT
        card,
        date,
        ROUND(SUM(money)) AS total_spent_per_day
    FROM
		coffee.index_1
    GROUP BY
		card, date
),
Last30DaySpend AS (
    SELECT
        card,
        date,
        SUM(total_spent_per_day) OVER (
            PARTITION BY card
            ORDER BY date ASC
            ROWS BETWEEN 30 PRECEDING AND CURRENT ROW
        ) AS customer_30_day_spend
    FROM
		CustomerSpending
)
SELECT
    card,
    date,
    customer_30_day_spend,
    ROW_NUMBER() OVER (
        PARTITION BY date
        ORDER BY customer_30_day_spend DESC
    ) AS rnk
FROM
	Last30DaySpend;
  ```

## Most frequent visitors over past 30 days
``` sql
WITH CustomerVisits AS (
    SELECT
        card,
        date,
        COUNT(*) AS daily_visits
    FROM
		coffee.index_1
    GROUP BY
		card, date
),
Last30DayVisits AS (
    SELECT
        card,
        date,
        SUM(daily_visits) OVER (
            PARTITION BY card
            ORDER BY date
            ROWS BETWEEN 30 PRECEDING AND CURRENT ROW
        ) AS customer_30_day_visits
    FROM
		CustomerVisits
),
LatestVisitPerCard AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY card
            ORDER BY date DESC
        ) AS rn
    FROM
		Last30DayVisits
)
SELECT
    card,
    date,
    customer_30_day_visits,
    RANK() OVER (ORDER BY customer_30_day_visits DESC) AS rnk
FROM
	LatestVisitPerCard
WHERE rn = 1
ORDER BY
	customer_30_day_visits DESC;
  ```


---

Thanks for reading!  
I created this as part of my SQL learning journey. If you're also learning SQL or data analytics, feel free to connect or share your thoughts! 😊
