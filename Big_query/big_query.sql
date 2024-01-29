-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `nyc_taxi.green-taxi-data-2022-parquet`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://green-taxi-data-2022-parquet/green_tripdata_2022-*.parquet']
);

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE `nyc_taxi.green-taxi-data-2022-parquet-non-partitoned` AS
SELECT * FROM `nyc_taxi.green-taxi-data-2022-parquet`;

-- External table
SELECT Count(DISTINCT PULocationID) from `nyc_taxi.green-taxi-data-2022-parquet`;

-- Materialised table
SELECT COunt(DISTINCT PULocationID) from `nyc_taxi.green-taxi-data-2022-parquet-non-partitoned`;

select count(fare_amount) from `nyc_taxi.green-taxi-data-2022-parquet-non-partitoned` where fare_amount = 0;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE nyc_taxi.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM `nyc_taxi.green-taxi-data-2022-parquet`;

-- 12.82mb
SELECT DISTINCT(PULocationID)
FROM `nyc_taxi.green-taxi-data-2022-parquet-non-partitoned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';
-- 1.12mb
SELECT DISTINCT(PULocationID)
FROM `nyc_taxi.green_tripdata_partitoned_clustered`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';


-- Create a partitioned table from external table
CREATE OR REPLACE TABLE `nyc_taxi.green_tripdata_partitoned`
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM `nyc_taxi.green-taxi-data-2022-parquet` ;

-- Impact of partition

SELECT DISTINCT(PULocationID)
FROM `nyc_taxi.green-taxi-data-2022-parquet`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2020-06-01' AND '2020-06-30';

SELECT DISTINCT(PULocationID)
FROM nyc_taxi.yellow_tripdata_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2020-06-01' AND '2020-06-30';

-- Let's look into the partitons
SELECT table_name, partition_id, total_rows
FROM `nytaxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY total_rows DESC;


-- What is count of records for the 2022 Green Taxi Data??
 Select count(Vendor_ID) from `nyc_taxi.green-taxi-data-2022-parquet-non-partitioned`;
-- 840,402


-- How many records have a fare_amount of 0?
select count(fare_amount) from `nyc_taxi.green-taxi-data-2022-parquet-non-partitoned` where fare_amount = 0;
-- 1,622


