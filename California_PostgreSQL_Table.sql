-- Active: 1721872569477@@127.0.0.1@5432

CREATE TABLE housing_data (
    id SERIAL PRIMARY KEY,
    longitude FLOAT,
    latitude FLOAT,
    housing_median_age FLOAT,
    total_rooms FLOAT,
    total_bedrooms FLOAT,
    population FLOAT,
    households FLOAT,
    median_income FLOAT,
    median_house_value FLOAT,
    rooms_per_household FLOAT,
    bedrooms_per_room FLOAT,
    population_per_household FLOAT,
    less_than_1h_ocean INT,
    inland INT,
    island INT,
    near_bay INT,
    near_ocean INT
);

SELECT column_name, data_type
FROM information_schema.columns
WHERE
    table_name = 'housing_data';

SELECT * FROM housing_data;