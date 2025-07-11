---
title: "Mean-Variance-Standard Deviation Calculator"
date: 2025-06-13
slug: mean-variance-calculator
tags: ["Python", "NumPy", "Study Project"]
description: "A study project using NumPy to calculate basic statistics across a 3x3 matrix."
---

📚 Study Project – freeCodeCamp Data Analysis with Python 

This was the first project in the freeCodeCamp data analysis certification. The goal was to write a Python function that calculates key statistics — **mean, variance, standard deviation, min, max, and sum** — across **rows, columns, and the flattened version** of a 3×3 matrix.

---

🧠 **What I Learned**
- How to manipulate matrices with NumPy  
- How to use functions like `.mean()`, `.var()`, `.std()`  
- How to reshape and flatten arrays  
- How to structure results clearly using Python dictionaries

---

🛠 **Scope of Work**
- Accept a list of 9 values as input  
- Reshape the list into a 3x3 NumPy matrix  
- Compute each statistic across:
  - Columns (axis 0)
  - Rows (axis 1)
  - The full flattened matrix  
- Return all results in a dictionary format

---

📌 **Example Input**
```python
calculate([0, 1, 2, 3, 4, 5, 6, 7, 8])
```

📎 **Full Python Code**

```python
import numpy as np

def calculate(input_list):
    if len(input_list) != 9:
        raise ValueError("List must contain nine numbers.")

    matrix = np.array(input_list).reshape(3, 3)

    calculations = {
        'mean': [
            matrix.mean(axis=0).tolist(),
            matrix.mean(axis=1).tolist(),
            matrix.mean()
        ],
        'variance': [
            matrix.var(axis=0).tolist(),
            matrix.var(axis=1).tolist(),
            matrix.var()
        ],
        'standard deviation': [
            matrix.std(axis=0).tolist(),
            matrix.std(axis=1).tolist(),
            matrix.std()
        ],
        'max': [
            matrix.max(axis=0).tolist(),
            matrix.max(axis=1).tolist(),
            matrix.max()
        ],
        'min': [
            matrix.min(axis=0).tolist(),
            matrix.min(axis=1).tolist(),
            matrix.min()
        ],
        'sum': [
            matrix.sum(axis=0).tolist(),
            matrix.sum(axis=1).tolist(),
            matrix.sum()
        ]
    }

    return calculations


