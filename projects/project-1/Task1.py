import pandas as pd

df = pd.read_csv('/Users/may/Downloads/funds16052025.csv')

duplicates = df[df.duplicated(subset=['fund_name'], keep=False)]

duplicates.to_csv('fund_name_duplicates.csv', index=False)

print("Duplicate fund names exported to 'fund_name_duplicates.csv'")




