## Topics Covered in Week 3

### 1. OLAP vs OLTP
- **OLAP (Online Analytical Processing):** Focuses on complex queries and analysis of historical data. Commonly used for business intelligence and reporting.
- **OLTP (Online Transactional Processing):** Geared towards transactional tasks, emphasizing real-time data processing and retrieval.

### 2. Data Warehouse
- **Definition:** A centralized repository for storing large volumes of structured and unstructured data, optimized for query and analysis.
  
### 3. BigQuery
- **Overview:** A fully-managed, serverless data warehouse by Google Cloud Platform (GCP).
- **Key Features:** Scalability, real-time analytics, and seamless integration with other GCP services.

### 4. Cost in BigQuery
- **Best Practices:** Avoid using SELECT *, price queries before running, use clustered or partitioned tables for cost reduction.

### 5. Partitions and Clustering
- **Partitioning:** Organizing tables based on specific columns (e.g., time-unit column) to enhance query performance.
- **Clustering:** Ordering and grouping related data in the table, improving filter and aggregate queries.

### 6. Best Practices
- **Resource Management:** Specify columns for data co-location, order of columns matters for sort order, and use up to four clustering columns.
- **Clustering over Partitioning:** Consider clustering when partitioning results in a large number of partitions beyond limits.

### 7. ML in BigQuery
- **Integration:** BigQuery supports machine learning capabilities, enabling the execution of ML models directly within queries.

### 8. Time-unit Column Partitioning
- **Options:** Daily (Default), Hourly, Monthly, or Yearly.
- **Limit:** The number of partitions is limited to 4000.

### 9. BigQuery Internal Architecture
- **Overview:** In-depth understanding of the internal structure and workings of BigQuery for optimizing performance and resource utilization.
- **Considerations:** Clustering columns, partitioning strategies, and best practices for query performance.

### Resources:
- [BigQuery Partitioned Tables](https://cloud.google.com/bigquery/docs/partitioned-tables)

### BigQuery Best Practices - Query Performance:
1. **Filter on Partitioned Columns:** Optimize queries by filtering on partitioned columns.
2. **Denormalizing Data:** Consider denormalizing data to reduce JOIN operations.
3. **Nested or Repeated Columns:** Utilize nested or repeated columns for efficient storage.
4. **External Data Sources:** Use external data sources appropriately for better performance.
5. **Avoid Oversharding Tables:** Balance sharding to avoid performance issues.

### BigQuery Best Practices - General:
1. **Cost Reduction:** Adopt practices to minimize costs.
2. **Use of SELECT *:** Avoid using SELECT *; select only the necessary columns.
3. **Streaming Inserts:** Use streaming inserts cautiously due to cost considerations.
4. **Materialize Query Results in Stages:** Optimize query performance by materializing results in stages.

### Query Performance - Optimization Tips:
1. **Avoid JavaScript UDFs:** JavaScript user-defined functions can impact performance negatively.
2. **Use Approximate Aggregation Functions:** HyperLogLog++ provides fast and approximate results.
3. **Order Last:** Optimize query operations by ordering the last in the join patterns.
4. **Optimize JOIN Patterns:** Place tables with the largest number of rows first for better performance.
