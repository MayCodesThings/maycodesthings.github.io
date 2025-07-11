import pandas as pd

def calculate_demographic_data(print_data=True):
    # Load data
    df = pd.read_csv("adult.data.csv")

    # Count each race representation
    race_count = df['race'].value_counts()

    # Average age of men
    average_age_men = round(df[df['sex'] == 'Male']['age'].mean(), 1)

    # Percentage with a Bachelor's degree
    percentage_bachelors = round(
        (df['education'] == 'Bachelors').mean() * 100, 1)

    # Advanced education vs income
    higher_edu = df['education'].isin(['Bachelors', 'Masters', 'Doctorate'])
    lower_edu = ~higher_edu

    higher_edu_rich = round(
        (df[higher_edu]['salary'] == '>50K').mean() * 100, 1)

    lower_edu_rich = round(
        (df[lower_edu]['salary'] == '>50K').mean() * 100, 1)

    # Minimum work hours
    min_work_hours = df['hours-per-week'].min()

    # Rich percentage among those who work min hours
    rich_min_workers = df[df['hours-per-week'] == min_work_hours]
    rich_percentage = round(
        (rich_min_workers['salary'] == '>50K').mean() * 100, 1)

    # Country with highest percentage of rich people
    rich_by_country = df[df['salary'] == '>50K']['native-country'].value_counts()
    total_by_country = df['native-country'].value_counts()
    rich_percent_country = (rich_by_country / total_by_country * 100).round(1)
    highest_earning_country = rich_percent_country.idxmax()
    highest_earning_country_percentage = rich_percent_country.max()

    # Top occupation for rich in India
    india_rich = df[(df['salary'] == '>50K') & (df['native-country'] == 'India')]
    top_IN_occupation = india_rich['occupation'].value_counts().idxmax()

    # Output dictionary
    result = {
        'race_count': race_count,
        'average_age_men': average_age_men,
        'percentage_bachelors': percentage_bachelors,
        'higher_education_rich': higher_edu_rich,
        'lower_education_rich': lower_edu_rich,
        'min_work_hours': min_work_hours,
        'rich_percentage': rich_percentage,
        'highest_earning_country': highest_earning_country,
        'highest_earning_country_percentage': highest_earning_country_percentage,
        'top_IN_occupation': top_IN_occupation
    }

    if print_data:
        for k, v in result.items():
            print(f"{k}: {v}")

    return result
