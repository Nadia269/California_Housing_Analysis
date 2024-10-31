# California_Housing_Analysis
 
# California Housing Prices Dataset Project

## Overview

This project involves analyzing and preparing the California Housing Prices dataset, a popular dataset that contains information about housing in various California districts. The data includes information such as median house values, the number of rooms, population, household information, and proximity to the ocean. The dataset provides a good foundation for understanding the relationship between various factors and housing prices, making it a valuable resource for housing market analysis and predictive modeling.

The dataset can be accessed via Python, and the project involves cleaning, transforming, and analyzing the data, followed by storing the processed data in a PostgreSQL database.

## Dataset Description

The dataset consists of the following key features:
- **longitude**: Geographical longitude of the district.
- **latitude**: Geographical latitude of the district.
- **housing_median_age**: Median age of the houses in the district.
- **total_rooms**: Total number of rooms in all houses in the district.
- **total_bedrooms**: Total number of bedrooms in all houses in the district (contains missing values).
- **population**: Total population of the district.
- **households**: Total number of households in the district.
- **median_income**: Median income of the households in the district.
- **median_house_value**: Median house value in the district.
- **ocean_proximity**: Proximity of the district to the ocean (categorical feature with values like "INLAND", "NEAR OCEAN", etc.).

## Project Steps

### 1. Data Loading and Exploration
The dataset is first loaded into a Pandas DataFrame for exploration:
```python
housing_price = pd.read_csv(r'E:\New Downloads here\archive\housing.csv')
```
The following steps are performed to get an overview of the dataset:
- **Shape of the dataset**: `housing_price.shape` to determine the number of rows and columns.
- **Data information**: `housing_price.info()` to check for null values and data types.
- **Statistical summary**: `housing_price.describe()` for basic statistics on numerical features.
- **Check for missing values**: `housing_price.isnull().sum()` to find missing data, especially in `total_bedrooms`.

### 2. Handling Missing Data
The `total_bedrooms` column has missing values, which are imputed using the median value:
```python
median_value = housing_price['total_bedrooms'].median()
housing_price['total_bedrooms'] = housing_price['total_bedrooms'].fillna(median_value)
```

### 3. Feature Engineering
Several new features are created to enhance the dataset:
- **rooms_per_household**: `housing_price['total_rooms'] / housing_price['households']`
- **bedrooms_per_room**: `housing_price['total_bedrooms'] / housing_price['total_rooms']`
- **population_per_household**: `housing_price['population'] / housing_price['households']`

### 4. Categorical Variable Handling
The categorical feature `ocean_proximity` is one-hot encoded to convert it into numerical format:
```python
dummies = pd.get_dummies(housing_price['ocean_proximity']).astype(int)
housing_price_with_dummies = pd.concat([housing_price, dummies], axis='columns')
housing_price_clean = housing_price_with_dummies.drop(['ocean_proximity'], axis='columns')
```

### 5. Data Visualization
Various visualizations are created to analyze the data:
- **Histograms**: The dataset's numerical features are visualized using histograms to observe distributions.
```python
housing_price_clean.hist(bins=50, figsize=(15, 15))
```
- **Scatter Plot**: A scatter plot is used to analyze the relationship between location and median house value:
```python
housing_price_clean.plot(kind='scatter', x='longitude', y='latitude', alpha=0.1, 
                         s=housing_price['population']/100, label='population',
                         c="median_house_value", cmap=plt.get_cmap("jet"))
```
- **Correlation Heatmap**: A heatmap is generated to examine correlations between variables:
```python
sns.heatmap(housing_price_clean.corr(), annot=True, cmap='Blues')
```
- **Boxplot**: A boxplot is used to detect outliers in `median_house_value`:
```python
sns.boxplot(x=housing_price_clean['median_house_value'])
```
- **Pairplot**: Key relationships are explored using a pairplot:
```python
sns.pairplot(housing_price_clean[['median_house_value', 'median_income', 'total_rooms', 
                                  'total_bedrooms', 'population']])
```

### 6. Data Loading into PostgreSQL
After cleaning and transforming the dataset, it is loaded into a PostgreSQL database for further processing or querying:
```python
engine = create_engine(f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}')
housing_price_clean.to_sql('housing_data', con=engine, if_exists='replace', index=False)
```

The column names are also cleaned before loading:
```python
housing_price_clean.rename(columns={
    'beedrooms_per_room': 'bedrooms_per_room',  
    '<1H OCEAN': 'less_than_1h_ocean',         
    'INLAND': 'inland',                         
    'ISLAND': 'island',                         
    'NEAR BAY': 'near_bay',
    'NEAR OCEAN': 'near_ocean'                  
}, inplace=True)
```

### 7. Querying the Data
Once the data is loaded into PostgreSQL, a simple query is used to retrieve data:
```python
query = 'SELECT * FROM housing_data LIMIT 5;'
result_df = pd.read_sql(query, con=engine)
print(result_df)
```

## Conclusion
This project provides a comprehensive approach to exploring, cleaning, transforming, and visualizing the California Housing Prices dataset. It also demonstrates how to effectively manage and load the dataset into a PostgreSQL database, making it ready for further analysis or model building.
