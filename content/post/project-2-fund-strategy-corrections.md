---
title: " 🔎 Project 2: Funds Series Strategy Corrections"
date: 2025-06-04
tags: ["Data Cleaning", "Python", "Finance", "Strategy Alignment"]
---


## 🎯 Project Overview

In this project, I worked on correcting fund strategy classifications by identifying fund series — different iterations of the same fund — and ensuring consistent strategy assignment across all entries.

This is a real-world data cleaning task involving string normalization, grouping logic, and careful strategy assignment using Python and Pandas.

## 🧠 Key Objectives

- Identify funds belonging to the same series
- Group them based on naming patterns (e.g., "Accel London I", "Accel London II", etc.)
- Apply consistent strategy values across each series group
- Preserve original strategy where no correction is needed

## 🛠 Tools & Libraries

- Python
- Pandas
- Regex
- CSV handling

## ✅ Summary
- Grouped similar funds by series name
- Applied consistent strategies using mode logic
- Exported clean files for analysis or reporting

📎 Full Python Code 
```py
# Load fund data
import pandas as pd
import re
from collections import Counter

# Load dataset
df = pd.read_csv("funds_with_strategies.csv")
df.columns = df.columns.str.strip().str.lower()
df.head()
     
# Extract Series Names
Use regex to remove legal suffixes, numbers, and common fund terms to isolate the base series name.

def extract_series_name(name):
    name = re.sub(r'\b(I{1,3}|IV|V|VI|VII|VIII|IX|X|XI|LP|Fund|Series|Capital|Fund I LLC)\b', '', name, flags=re.IGNORECASE)
    name = re.sub(r'\b\d+\b', '', name)
    name = re.sub(r'\s+', ' ', name)
    return name.strip().lower()

df["series_name"] = df["fund_name"].apply(extract_series_name)
df[["fund_name", "series_name"]].head()
     
# Apply Corrected Strategy
For each series group, assign the most common original_strategy as the corrected_strategy.

def apply_correction(group):
    most_common = Counter(group["original_strategy"]).most_common(1)[0][0]
    group["corrected_strategy"] = most_common
    return group

df = df.groupby("series_name", group_keys=False).apply(apply_correction)
df[["fund_name", "original_strategy", "corrected_strategy"]].head()
     
group_df = df.groupby("series_name")["fund_name"].apply(lambda x: "; ".join(sorted(x))).reset_index()
group_df.to_csv("step1_fund_series_groups.csv", index=False)
group_df.head()
     
df.to_csv("funds_with_corrected_strategy.csv", index=False)
df.head()
     

