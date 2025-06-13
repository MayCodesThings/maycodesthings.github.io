---
title: "🧹 Project: Fund Name Cleaning & Matching"
date: 2025-06-03
slug: project1-fund-cleaning
tags: ["Python", "Pandas", "Regex", "Data Cleaning", "Portfolio Project"]
description: "Real-world fund name normalization and duplicate detection using Python, Regex, and pattern grouping."
---

📚 **Portfolio Project – Fund Name Cleaning & Matching**

This project focused on cleaning and deduplicating messy fund names across datasets using **Pandas**, **Regex**, and **custom logic**. I normalized naming conventions, removed legal suffixes, converted number formats, and grouped similar names based on semantic and structural patterns.

---

## 🛠 Tools Used

- Python (Jupyter Notebook)
- Pandas for data manipulation
- Regular Expressions (`re`) for pattern matching
- Unidecode for character normalization
- JSON for suffix lookups

---
## Full Project Code 👇🏻
<details>
<summary>Click to expand full code</summary>


```python
import pandas as pd

df = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv") 
duplicates = df[df.duplicated(subset=['fund_name'], keep=False)]
duplicates.to_csv('fund_name_duplicates.csv', index=False)
print("fund_name_duplicates.csv")


# Task 2
# Remove the list of legal suffixes from original fund file 
# Print the cleansed names of the funds

import json
import pandas as pd
import re

with open("/Users/may/Downloads/Project _1/fundExc:Users:may:Downloads:Project _1:fundExclusions.jsonlusions.json", "r") as f:
    suffixes = json.load(f)

suffixes = [re.sub(r'[^a-zA-Z0-9]', '', s.lower()) for s in suffixes]

number_words = {
    "first": "1", "second": "2", "third": "3", "fourth": "4", "fifth": "5", "sixth": "6", "seventh": "7",
    "eighth": "8", "ninth": "9", "tenth": "10", "eleventh": "11", "twelfth": "12",
    "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7",
    "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12"
}
roman_numerals = {
    "i": "1", "ii": "2", "iii": "3", "iv": "4", "v": "5", "vi": "6", "vii": "7",
    "viii": "8", "ix": "9", "x": "10", "xi": "11", "xii": "12"
}

df = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv")

def remove_legal_suffix(name):
    original_name = str(name).strip()
    normalized = re.sub(r'[^a-zA-Z0-9 ]', '', original_name.lower()).strip()
    for suffix in suffixes:
        if normalized.endswith(suffix):
            pattern = rf'[\s,\.]*{re.escape(suffix)}[\s,\.]*$'
            cleaned = re.sub(pattern, '', original_name, flags=re.IGNORECASE).strip()
            return cleaned, suffix.upper()
    return original_name, "-"

def normalize_numbers(name):
    words = name.split()
    result = []
    changes = []
    for word in words:
        word_lower = word.lower()
        clean_word = re.sub(r'[^a-zA-Z]', '', word_lower)
        if clean_word in number_words:
            result.append(number_words[clean_word])
            changes.append(f"{word} → {number_words[clean_word]}")
        elif clean_word in roman_numerals:
            result.append(roman_numerals[clean_word])
            changes.append(f"{word} → {roman_numerals[clean_word]}")
        else:
            result.append(word)
    return " ".join(result), ", ".join(changes) if changes else "-"

cleaned_names = []
removed_suffixes = []
number_changes = []

for name in df["fund_name"]:
    no_suffix_name, suffix_removed = remove_legal_suffix(name)
    final_name, number_change = normalize_numbers(no_suffix_name)
    cleaned_names.append(final_name)
    removed_suffixes.append(suffix_removed)
    number_changes.append(number_change)

df["Cleaned Fund Name"] = cleaned_names
df["Removed Suffix"] = removed_suffixes
df["Number Normalization"] = number_changes

df.to_csv("cleaned_fund_names_with_details.csv", index=False)

with open("cleaned_fund_names_list.txt", "w") as f:
    for name in df["Cleaned Fund Name"]:
        f.write(name + "\n")

duplicates_df = df[df.duplicated(subset=["Cleaned Fund Name"], keep=False)].copy()
duplicates_df.to_csv("duplicate_cleaned_fund_names.csv", index=False)

duplicates_grouped = (
    df[df.duplicated(subset=["Cleaned Fund Name"], keep=False)]
    .groupby("Cleaned Fund Name")["fund_name"]
    .apply(list)
    .reset_index()
)

matched_ids = (
    df[df["Cleaned Fund Name"].isin(duplicates_grouped["Cleaned Fund Name"])]
    .groupby("Cleaned Fund Name")["fund_manager_id"]
    .apply(lambda x: sorted(set(x.dropna().astype(str))))
    .reset_index()
)

merged = pd.merge(duplicates_grouped, matched_ids, on="Cleaned Fund Name")

expanded_funds = merged["fund_name"].apply(pd.Series)
expanded_funds.columns = [f"Fund {i+1}" for i in expanded_funds.columns]

expanded_funds["Fund Manager IDs"] = merged["fund_manager_id"].apply(lambda x: ", ".join(x))
expanded_funds.to_csv("exact_fund_name_matches.csv", index=False)

print("exact_fund_name_matches.csv' with Fund 1, Fund 2, ..., Fund Manager IDs")

# Task3
# Normalise the numbers in the fund names to always be numerical rather than words or roman numerals 

import json
import pandas as pd
import re

with open("/Users/may/Downloads/Project _1/fundExc:Users:may:Downloads:Project _1:fundExclusions.jsonlusions.json", "r") as f:
    suffixes = json.load(f)

suffixes = [re.sub(r'[^a-zA-Z0-9]', '', s.lower()) for s in suffixes]

number_words = {
    "first": "1", "second": "2", "third": "3", "fourth": "4", "fifth": "5", "sixth": "6", "seventh": "7",
    "eighth": "8", "ninth": "9", "tenth": "10", "eleventh": "11", "twelfth": "12",
    "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7",
    "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12"
}

roman_numerals = {
    "i": "1", "ii": "2", "iii": "3", "iv": "4", "v": "5", "vi": "6", "vii": "7",
    "viii": "8", "ix": "9", "x": "10", "xi": "11", "xii": "12"
}

df = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv")

def remove_legal_suffix(name):
    original_name = str(name).strip()
    normalized = re.sub(r'[^a-zA-Z0-9 ]', '', original_name.lower()).strip()

    for suffix in suffixes:
        if normalized.endswith(suffix):
            pattern = rf'[\s,\.]*{re.escape(suffix)}[\s,\.]*$'
            cleaned = re.sub(pattern, '', original_name, flags=re.IGNORECASE).strip()
            return cleaned, suffix.upper()  
    return original_name, "-"  

def normalize_numbers(name):
    words = name.split()
    result = []
    changes = []

    for word in words:
        word_lower = word.lower()
        clean_word = re.sub(r'[^a-zA-Z]', '', word_lower)

        if clean_word in number_words:
            result.append(number_words[clean_word])
            changes.append(f"{word} → {number_words[clean_word]}")
        elif clean_word in roman_numerals:
            result.append(roman_numerals[clean_word])
            changes.append(f"{word} → {roman_numerals[clean_word]}")
        else:
            result.append(word)

    return " ".join(result), ", ".join(changes) if changes else "-"

cleaned_names = []
removed_suffixes = []
number_changes = []

for name in df["fund_name"]:
    no_suffix_name, suffix_removed = remove_legal_suffix(name)
    final_name, number_change = normalize_numbers(no_suffix_name)

    cleaned_names.append(final_name)
    removed_suffixes.append(suffix_removed)
    number_changes.append(number_change)

df["Cleaned Fund Name"] = cleaned_names
df["Removed Suffix"] = removed_suffixes
df["Number Normalization"] = number_changes

df.to_csv("cleaned_fund_names_with_details.csv", index=False)

with open("cleaned_fund_names_list.txt", "w") as f:
    for name in cleaned_names:
        f.write(name + "\n")

print("\n📋 Final List of Cleaned Fund Names:\n")
for name in cleaned_names:
    print(name)

print("\n✅ Files saved:")
print("  → cleaned_fund_names_with_details.csv")
print("  → cleaned_fund_names_list.txt")

# Task 4: 
# Combine all fund together ( remove legal suffixes, normalise the numbers and look for more exact matches )

import json
import pandas as pd
import re

with open("/Users/may/Downloads/Project _1/fundExc:Users:may:Downloads:Project _1:fundExclusions.jsonlusions.json", "r") as f:
    suffixes = json.load(f)

suffixes = [re.sub(r'[^a-zA-Z0-9]', '', s.lower()) for s in suffixes]

number_words = {
    "first": "1", "second": "2", "third": "3", "fourth": "4", "fifth": "5", "sixth": "6", "seventh": "7",
    "eighth": "8", "ninth": "9", "tenth": "10", "eleventh": "11", "twelfth": "12",
    "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7",
    "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12"
}

roman_numerals = {
    "i": "1", "ii": "2", "iii": "3", "iv": "4", "v": "5", "vi": "6", "vii": "7",
    "viii": "8", "ix": "9", "x": "10", "xi": "11", "xii": "12"
}

df = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv")

def remove_legal_suffix(name):
    original_name = str(name).strip()
    normalized = re.sub(r'[^a-zA-Z0-9 ]', '', original_name.lower()).strip()

    for suffix in suffixes:
        if normalized.endswith(suffix):
            pattern = rf'[\s,\.]*{re.escape(suffix)}[\s,\.]*$'
            cleaned = re.sub(pattern, '', original_name, flags=re.IGNORECASE).strip()
            return cleaned, suffix.upper()
    return original_name, "-"

def normalize_numbers(name):
    words = name.split()
    result = []
    changes = []

    for word in words:
        word_lower = word.lower()
        clean_word = re.sub(r'[^a-zA-Z]', '', word_lower)

        if clean_word in number_words:
            result.append(number_words[clean_word])
            changes.append(f"{word} → {number_words[clean_word]}")
        elif clean_word in roman_numerals:
            result.append(roman_numerals[clean_word])
            changes.append(f"{word} → {roman_numerals[clean_word]}")
        else:
            result.append(word)

    return " ".join(result), ", ".join(changes) if changes else "-"

cleaned_names = []
removed_suffixes = []
number_changes = []

for name in df["fund_name"]:
    no_suffix_name, suffix_removed = remove_legal_suffix(name)
    final_name, number_change = normalize_numbers(no_suffix_name)

    cleaned_names.append(final_name)
    removed_suffixes.append(suffix_removed)
    number_changes.append(number_change)

df["Cleaned Fund Name"] = cleaned_names
df["Removed Suffix"] = removed_suffixes
df["Number Normalization"] = number_changes

df.to_csv("cleaned_fund_names_with_details.csv", index=False)

with open("cleaned_fund_names_list.txt", "w") as f:
    for name in df["Cleaned Fund Name"]:
        f.write(name + "\n")

duplicates_df = df[df.duplicated(subset=["Cleaned Fund Name"], keep=False)].copy()
duplicates_df.to_csv("duplicate_cleaned_fund_names.csv", index=False)

print("\n📋 Final List of Cleaned Fund Names:\n")
for name in df["Cleaned Fund Name"]:
    print(name)

print("\n📝 Duplicates:")
for name in duplicates_df["Cleaned Fund Name"].unique():
    print(f"→ {name}")

duplicates_grouped = (
    df[df.duplicated(subset=["Cleaned Fund Name"], keep=False)]
    .groupby("Cleaned Fund Name")["fund_name"]
    .apply(list)
    .reset_index()
)

expanded_rows = duplicates_grouped["fund_name"].apply(pd.Series)
expanded_rows.columns = [f"Match {i+1}" for i in expanded_rows.columns]
expanded_rows.to_csv("exact_fund_name_matches.csv", index=False)

print("\n📁 Grouped matches saved to 'exact_fund_name_matches.csv'")

# Task 5
# Remove all matched funds from the original fund file and output a new CSV containing only the unmatched funds.

import pandas as pd

df_original = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv")
df_matches = pd.read_csv("exact_fund_name_matches.csv")

matched_funds = pd.unique(df_matches.values.ravel())
matched_funds = [str(name).strip() for name in matched_funds if pd.notna(name)]

filtered_df = df_original[~df_original["fund_name"].isin(matched_funds)]
filtered_df.to_csv("funds_without_matches.csv", index=False)

print("funds_without_matches.csv' (excluding matched funds)")


# Task 6
# Identifying Subtle Fund Name Matches for Manual Review

import pandas as pd
import re

df_original = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv")
df_matches = pd.read_csv("exact_fund_name_matches.csv")

matched_funds = pd.unique(df_matches.values.ravel())
matched_funds = [str(name).strip() for name in matched_funds if pd.notna(name)]

filtered_df = df_original[~df_original["fund_name"].isin(matched_funds)]

ignore_words = {"venture", "ventures", "fund"}

num_map = {
    "first": "1", "second": "2", "third": "3", "fourth": "4", "fifth": "5", "sixth": "6",
    "seventh": "7", "eighth": "8", "ninth": "9", "tenth": "10", "eleventh": "11", "twelfth": "12",
    "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7",
    "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12",
    "i": "1", "ii": "2", "iii": "3", "iv": "4", "v": "5", "vi": "6", "vii": "7",
    "viii": "8", "ix": "9", "x": "10", "xi": "11", "xii": "12"
}

def standardize(name):
    words = re.sub(r'[^a-zA-Z0-9 ]', '', str(name).lower()).split()
    clean = []
    for word in words:
        w = re.sub(r'[^a-zA-Z0-9]', '', word)
        if w in num_map:
            clean.append(num_map[w])
        elif w not in ignore_words:
            clean.append(w)
    clean = [w for w in clean if w != "1"] 
    return " ".join(sorted(clean))

filtered_df["pattern_group"] = filtered_df["fund_name"].apply(standardize)

grouped = (
    filtered_df[filtered_df.duplicated("pattern_group", keep=False)]
    .groupby("pattern_group")["fund_name"]
    .apply(list)
    .reset_index()
)

expanded = grouped["fund_name"].apply(pd.Series)
expanded.columns = [f"Match {i+1}" for i in expanded.columns]
expanded.to_csv("pattern_based_fund_name_matches.csv", index=False)

print("Saved:")
print("- 'funds_without_matches.csv'")
print("- 'pattern_based_fund_name_matches.csv'")


# Task 7 
# Match Funds Only When Fund Manager IDs Align

import json
import pandas as pd
import re

with open("/Users/may/Downloads/Project _1/fundExc:Users:may:Downloads:Project _1:fundExclusions.jsonlusions.json", "r") as f:
    suffixes = json.load(f)

suffixes = [re.sub(r'[^a-zA-Z0-9]', '', s.lower()) for s in suffixes]

number_words = {
    "first": "1", "second": "2", "third": "3", "fourth": "4", "fifth": "5", "sixth": "6", "seventh": "7",
    "eighth": "8", "ninth": "9", "tenth": "10", "eleventh": "11", "twelfth": "12",
    "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7",
    "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12"
}

roman_numerals = {
    "i": "1", "ii": "2", "iii": "3", "iv": "4", "v": "5", "vi": "6", "vii": "7",
    "viii": "8", "ix": "9", "x": "10", "xi": "11", "xii": "12"
}

df = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv")

if "fund_manager_id" not in df.columns:
    raise ValueError("❌ Column 'fund_manager_id' not found in the CSV. Please check column names.")

def remove_legal_suffix(name):
    original_name = str(name).strip()
    normalized = re.sub(r'[^a-zA-Z0-9 ]', '', original_name.lower()).strip()

    for suffix in suffixes:
        if normalized.endswith(suffix):
            pattern = rf'[\s,\.]*{re.escape(suffix)}[\s,\.]*$'
            cleaned = re.sub(pattern, '', original_name, flags=re.IGNORECASE).strip()
            return cleaned, suffix.upper()
    return original_name, "-"

def normalize_numbers(name):
    words = name.split()
    result = []
    changes = []

    for word in words:
        word_lower = word.lower()
        clean_word = re.sub(r'[^a-zA-Z]', '', word_lower)

        if clean_word in number_words:
            result.append(number_words[clean_word])
            changes.append(f"{word} → {number_words[clean_word]}")
        elif clean_word in roman_numerals:
            result.append(roman_numerals[clean_word])
            changes.append(f"{word} → {roman_numerals[clean_word]}")
        else:
            result.append(word)

    return " ".join(result), ", ".join(changes) if changes else "-"

cleaned_names = []
removed_suffixes = []
number_changes = []

for name in df["fund_name"]:
    no_suffix_name, suffix_removed = remove_legal_suffix(name)
    final_name, number_change = normalize_numbers(no_suffix_name)

    cleaned_names.append(final_name)
    removed_suffixes.append(suffix_removed)
    number_changes.append(number_change)

df["Cleaned Fund Name"] = cleaned_names
df["Removed Suffix"] = removed_suffixes
df["Number Normalization"] = number_changes

df.to_csv("cleaned_fund_names_with_details.csv", index=False)

duplicates_df = df[df.duplicated(subset=["Cleaned Fund Name"], keep=False)].copy()
duplicates_df.to_csv("duplicate_cleaned_fund_names.csv", index=False)

match_groups = (
    duplicates_df.groupby("Cleaned Fund Name")
)

match_rows = []
for _, group in match_groups:
    fund_names = group["fund_name"].tolist()
    manager_ids = sorted(set(str(mid) for mid in group["fund_manager_id"] if pd.notna(mid)))
    row = fund_names + [", ".join(manager_ids)]
    match_rows.append(row)

max_matches = max(len(row) - 1 for row in match_rows)
columns = [f"Match {i+1}" for i in range(max_matches)] + ["Fund Manager IDs"]

padded_rows = []
for row in match_rows:
    fund_names = row[:-1]
    manager_ids = row[-1]
    padded = fund_names + [""] * (max_matches - len(fund_names)) + [manager_ids]
    padded_rows.append(padded)

final_df = pd.DataFrame(padded_rows, columns=columns)
final_df.to_csv("exact_fund_name_matches.csv", index=False)

print("- exact_fund_name_matches.csv (with Fund Manager IDs)")

# Task 8 
# (Task 4 Extension) : Exclude Previously Matched Funds and Manually Discover Additional Match Patterns

import pandas as pd
import re
import json
from unidecode import unidecode

df_original = pd.read_csv("/Users/may/Downloads/Project _1/funds16052025.csv")

with open("/Users/may/Downloads/Project _1/fundExc:Users:may:Downloads:Project _1:fundExclusions.jsonlusions.json", "r") as f:
    suffixes = json.load(f)
suffixes = [re.sub(r'[^a-zA-Z0-9]', '', s.lower()) for s in suffixes]

number_words = {
    "first": "1", "second": "2", "third": "3", "fourth": "4", "fifth": "5", "sixth": "6",
    "seventh": "7", "eighth": "8", "ninth": "9", "tenth": "10", "eleventh": "11", "twelfth": "12",
    "one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6", "seven": "7",
    "eight": "8", "nine": "9", "ten": "10", "eleven": "11", "twelve": "12"
}
roman_numerals = {
    "i": "1", "ii": "2", "iii": "3", "iv": "4", "v": "5", "vi": "6", "vii": "7",
    "viii": "8", "ix": "9", "x": "10", "xi": "11", "xii": "12"
}
equivalent_keywords = {
    "coinvestment": "coinvest",
    "co-investment": "coinvest",
    "co-invest": "coinvest",
    "co- investment": "coinvest",
    "co - investment": "coinvest",
    "co – investment": "coinvest",
    "co –investment": "coinvest",
    "participations": "coinvest",
    "program": "",
    "fund": "",
    "capital": "",
    "ventures": "",
    "venture": "",
    "partner": "",
    "equity": "",
    "enterprise": "",
    "opportunity": "",
    "income": "",
    "cooperatief": "",
    "cooperatief ua": "",
    "lp": "",
    "ua": ""
}
ignore_words = {"india", "sarl", "sicar"}

def clean_name(name):
    name = str(name).lower().strip()
    name = unidecode(name)

    cleaned = name
    while True:
        norm = re.sub(r'[^a-zA-Z0-9 ]', '', cleaned).strip()
        matched = False
        for suffix in suffixes:
            if norm.endswith(suffix):
                pattern = rf'[\s,\.]*{re.escape(suffix)}[\s,\.]*$'
                cleaned = re.sub(pattern, '', cleaned, flags=re.IGNORECASE).strip()
                matched = True
                break
        if not matched:
            break
    name = cleaned

    for phrase in ["co- investment", "co - investment", "co – investment", "co –investment"]:
        name = name.replace(phrase, "coinvestment")

    words = re.sub(r'[^a-zA-Z0-9 ]', '', name).split()
    normalized = []

    for word in words:
        w = word.lower()
        if w in number_words:
            normalized.append(number_words[w])
        elif w in roman_numerals:
            normalized.append(roman_numerals[w])
        elif w in ignore_words:
            continue
        elif w in equivalent_keywords:
            if equivalent_keywords[w]:
                normalized.append(equivalent_keywords[w])
        else:
            if w.isdigit():
                normalized.append(str(int(w)))  
            else:
                normalized.append(w)

    normalized = [w for w in normalized if w != "1"]

    return " ".join(sorted(normalized))

df_original["cleaned_name"] = df_original["fund_name"].apply(clean_name)

group_counts = df_original["cleaned_name"].value_counts()
duplicate_groups = set(group_counts[group_counts > 1].index)
df_unmatched = df_original[~df_original["cleaned_name"].isin(duplicate_groups)].copy()
df_unmatched.drop(columns=["cleaned_name"], inplace=True)

df_unmatched.to_csv("funds_after_custom_group_removal.csv", index=False)
print("funds_after_custom_group_removal.csv")
```
