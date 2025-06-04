---
title: "Project 2: Funds Series Strategy Corrections"
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

📁 View the Code on Github
(https://github.com/MayCodesThings/maycodesthings.github.io/blob/main/projects/project-2/project-2-fund-strategy-corrections-clean.ipynb)
- `grouped_fund_series.csv` – groups of related funds
- `corrected_strategy.csv` – fund list with consistent strategy column (`corrected_strategy`)


