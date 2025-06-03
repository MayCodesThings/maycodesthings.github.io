---
title: "Project 1: Fund Name Cleaning & Matching"
date: 2025-06-03
slug: "project-1-fund-name-cleaning"
tags: ["Data Cleaning", "Python", "Pandas", "Regex"]
Description: "A hands-on project focused on cleaning and matching inconsistent fund names using Python and domain-specific rules."
---

### 📌 Project Overview

This project focused on cleaning and matching messy fund names using Python and custom logic. The objective was to group together fund names that referred to the same entity but appeared in various formats across datasets.

This was one of my first real-world data cleaning projects, and it provided valuable insight into how messy and inconsistent raw data can be—especially when working with financial naming conventions.

---

### 🔧 Scope of Work

- Removed exact duplicates from the dataset
- Normalized legal suffixes such as **LLP**, **FCPR**, etc.
- Converted Roman numerals and number words (e.g., *III* → 3, *One* → 1)
- Mapped fund-related keywords (e.g., *Capital*, *Fund*, *Ventures*) to consistent forms
- Treated similar patterns as equivalent (e.g., `CEOF II Coinvestment` ≈ `CCOF II Co-Investment`)
- Used Python scripts with **Pandas**, **Regex**, and **Unidecode** for standardization

---

### 📊 Examples of Grouped Funds

- `3E Bioventures No.1 Fund` = `3E Bioventures Capital I`  
- `401 Ventures LLP` = `401 Private Equity LLP`  
- `CEOF II Coinvestment` = `CCOF II Co-Investment`

---

### 🛠 Tools Used

- **Python** (Jupyter Notebook)
- **Pandas** for data manipulation
- **Regular Expressions (re)** for pattern matching
- **Unidecode** for character normalization

---

### 🎯 Key Takeaways

- Learned to design domain-specific data cleaning pipelines
- Applied advanced string manipulation techniques
- Understood the importance of flexible matching logic in real-world scenarios
- Gained experience working with financial and private equity data

---

### 🔗 GitHub Repository

---

This project is part of my transition from recruitment to data analytics. I'm passionate about using Python and data tools to solve real-world problems and communicate insights clearly.
