---
title: "Page View Time Series Visualizer"
date: 2025-06-13
slug: page-view-time-series
tags: ["Python", "Pandas", "Matplotlib", "Seaborn", "Time Series", "freeCodeCamp"]
description: "A study project using Python to visualize daily page views with line, bar, and box plots."
---

📚 **Study Project – freeCodeCamp Data Analysis with Python**

In this project, I worked with daily page view data to visualize trends and distributions using different plot types. The goal was to uncover seasonal patterns and year-over-year comparisons in web traffic.

---

## 🎯 Project Goals
- Clean and filter outliers in time series data
- Create:
  - **Line plot** to show long-term trends
  - **Bar plot** for average monthly views by year
  - **Box plots** to visualize seasonal and annual variation
---

## 🔍 What I Learned
- How to work with datetime indexes in Pandas
- Rolling mean and quantile-based outlier removal
- Grouping and aggregating time series for multi-level bar plots
- Using Matplotlib and Seaborn for clear, comparative charts

---

## Tasks and Code Overview

<details><summary>📜 Click to expand full code</summary>

```python
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

# Load data
df = pd.read_csv("fcc-forum-pageviews.csv", index_col="date", parse_dates=True)

# Clean data (remove top and bottom 2.5%)
df = df[(df["value"] >= df["value"].quantile(0.025)) & 
        (df["value"] <= df["value"].quantile(0.975))]

# Line plot
def draw_line_plot():
    fig, ax = plt.subplots(figsize=(14,6))
    ax.plot(df.index, df["value"], color="red", linewidth=1)
    ax.set_title("Daily freeCodeCamp Forum Page Views 5/2016–12/2019")
    ax.set_xlabel("Date")
    ax.set_ylabel("Page Views")
    fig.savefig("line_plot.png")
    return fig

# Bar plot
def draw_bar_plot():
    df_bar = df.copy()
    df_bar["year"] = df_bar.index.year
    df_bar["month"] = df_bar.index.strftime('%B')
    df_bar["month_num"] = df_bar.index.month
    df_bar = df_bar.sort_values("month_num")

    df_grouped = df_bar.groupby(["year", "month"]).mean(numeric_only=True).reset_index()

    fig = sns.catplot(
        data=df_grouped, kind="bar",
        x="year", y="value", hue="month",
        height=6, aspect=2
    ).fig

    fig.savefig("bar_plot.png")
    return fig

# Box plots
def draw_box_plot():
    df_box = df.copy()
    df_box.reset_index(inplace=True)
    df_box["year"] = df_box["date"].dt.year
    df_box["month"] = df_box["date"].dt.strftime("%b")
    df_box["month_num"] = df_box["date"].dt.month
    df_box = df_box.sort_values("month_num")

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15,5))
    sns.boxplot(x="year", y="value", data=df_box, ax=ax1)
    ax1.set_title("Year-wise Box Plot (Trend)")
    ax1.set_xlabel("Year")
    ax1.set_ylabel("Page Views")

    sns.boxplot(x="month", y="value", data=df_box, ax=ax2)
    ax2.set_title("Month-wise Box Plot (Seasonality)")
    ax2.set_xlabel("Month")
    ax2.set_ylabel("Page Views")

    fig.savefig("box_plot.png")
    return fig
