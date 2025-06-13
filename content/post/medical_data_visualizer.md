---
title: "Medical Data Visualizer with Python"
date: 2025-06-13
slug: medical-data-eda
tags: ["Python", "Pandas", "Seaborn", "Data Visualization", "freeCodeCamp"]
description: "An exploratory data analysis and visualization project based on medical examination records."
---

📚 **Study Project – freeCodeCamp Data Analysis with Python**

In this project, I analyzed a medical dataset with health-related metrics (e.g., blood pressure, cholesterol, BMI) and visualized key patterns using Pandas, Seaborn, and Matplotlib.

---

## 🔍 Project Objectives

The project aimed to:
- Clean and preprocess health data
- Add derived features such as **overweight indicator**
- Normalize variables like **cholesterol** and **glucose**
- Generate visual summaries using **categorical plots** and **heatmaps**

---

## 💡 What I Learned
- Data normalization for medical variables
- Adding logical features (e.g., BMI-based overweight)
- Visual encoding with `sns.catplot()` and `sns.heatmap()`
- Filtering outliers using quantiles and logical conditions
- Building EDA pipelines using Pandas

---

## 🛠 Tasks and Code Overview

<details><summary>📜 Click to show full code</summary>

```python
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Load dataset
df = pd.read_csv('medical_examination.csv')

# Add overweight column based on BMI > 25
df['overweight'] = (df['weight'] / (df['height'] / 100) ** 2 > 25).astype(int)

# Normalize cholesterol and glucose: 0 is good, 1 is bad
df['cholesterol'] = (df['cholesterol'] > 1).astype(int)
df['gluc'] = (df['gluc'] > 1).astype(int)

# Draw Categorical Plot
def draw_cat_plot():
    df_cat = pd.melt(
        df,
        id_vars=['cardio'],
        value_vars=['active', 'alco', 'cholesterol', 'gluc', 'overweight', 'smoke']
    )
    df_cat = df_cat.groupby(['cardio', 'variable', 'value']).size().reset_index(name='total')
    g = sns.catplot(
        x='variable', y='total', hue='value',
        col='cardio', kind='bar', data=df_cat
    )
    g.fig.savefig('catplot.png')
    return g.fig

# Draw Heat Map
def draw_heat_map():
    df_heat = df[
        (df['ap_lo'] <= df['ap_hi']) &
        (df['height'] >= df['height'].quantile(0.025)) &
        (df['height'] <= df['height'].quantile(0.975)) &
        (df['weight'] >= df['weight'].quantile(0.025)) &
        (df['weight'] <= df['weight'].quantile(0.975))
    ]
    corr = df_heat.corr()
    mask = np.triu(np.ones_like(corr, dtype=bool))
    fig, ax = plt.subplots(figsize=(12, 10))
    sns.heatmap(
        corr, mask=mask, annot=True, fmt=".1f",
        center=0, square=True, linewidths=.5,
        cbar_kws={"shrink": .5}
    )
    fig.savefig('heatmap.png')
    return fig
