# BigQuery SQL File and Analysis

## Overview

This SQL script (`bigquery.sql`) is designed to interact with Google BigQuery and perform various operations on the Green Taxi Data for the year 2022. The script includes the creation of external tables, non-partitioned tables, partitioned tables, and clustered tables. Additionally, it addresses specific queries and optimization strategies for efficient data retrieval.

## SQL Script Explanation

### 1. **Creating External Table**

```sql
-- Creating external table referring to GCS path
CREATE OR REPLACE EXTERNAL TABLE `nyc_taxi.green-taxi-data-2022-parquet`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://green-taxi-data-2022-parquet/green_tripdata_2022-*.parquet']
);
```

This section creates an external table pointing to a GCS path with Parquet format data.

### 2. **Creating Non-Partitioned Table**

```sql
-- Create a non-partitioned table from the external table
CREATE OR REPLACE TABLE `nyc_taxi.green-taxi-data-2022-parquet-non-partitioned` AS
SELECT * FROM `nyc_taxi.green-taxi-data-2022-parquet`;
```

Creates a non-partitioned table by copying data from the external table.

### 3. **Queries on External and Non-Partitioned Tables**

```sql
-- External table
SELECT Count(DISTINCT PULocationID) FROM `nyc_taxi.green-taxi-data-2022-parquet`;

-- Materialized table
SELECT Count(DISTINCT PULocationID) FROM `nyc_taxi.green-taxi-data-2022-parquet-non-partitioned`;
```

Executes queries on the external and non-partitioned tables to count distinct `PULocationID` values.

### 4. **Queries on Non-Partitioned Table**

```sql
-- Queries on non-partitioned table
SELECT Count(fare_amount) FROM `nyc_taxi.green-taxi-data-2022-parquet-non-partitioned` WHERE fare_amount = 0;
```

Counts records with a fare amount of 0 in the non-partitioned table.

### 5. **Creating Partitioned and Clustered Table**

```sql
-- Creating a partitioned and clustered table
CREATE OR REPLACE TABLE nyc_taxi.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM `nyc_taxi.green-taxi-data-2022-parquet`;
```

Creates a partitioned and clustered table by partitioning on `lpep_pickup_datetime` and clustering on `PULocationID`.

### 6. **Queries on Partitioned and Non-Partitioned Tables**

```sql
-- Distinct PULocationID query for non-partitioned table
SELECT DISTINCT(PULocationID)
FROM `nyc_taxi.green-taxi-data-2022-parquet-non-partitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- Distinct PULocationID query for partitioned table
SELECT DISTINCT(PULocationID)
FROM `nyc_taxi.green_tripdata_partitoned_clustered`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';
```

Executes queries to retrieve distinct `PULocationID` values from both non-partitioned and partitioned tables.

## Analysis and Questions

### Question 1

What is the count of records for the 2022 Green Taxi Data?
```sql
SELECT COUNT(Vendor_ID) FROM `nyc_taxi.green-taxi-data-2022-parquet-non-partitioned`;
- 840,402
```

### Question 2

Count the distinct number of PULocationIDs for the entire dataset on both tables.

What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

- 0 MB for the External Table and 6.41MB for the Materialized Table

### Question 3

How many records have a fare_amount of 0?
```sql
SELECT COUNT(fare_amount) FROM `nyc_taxi.green-taxi-data-2022-parquet-non-partitioned` WHERE fare_amount = 0;
```
- 1,622

### Question 4

What is the best strategy to make an optimized table in BigQuery if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime?

Partition by `lpep_pickup_datetime` and Cluster on `PUlocationID`

### Question 5

Retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive).

- Estimated bytes: 12.82 MB for the non-partitioned table and 1.12 MB for the partitioned table.

### Question 6

Where is the data stored in the External Table you created?

- Big Query

### Question 7

It is best practice in Big Query to always cluster your data:

- False
