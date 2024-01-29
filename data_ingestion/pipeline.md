# Webscrapping-Mage-Bigquery


# Project Readme

## Overview

This project involves the development and deployment of a Mage block for loading data from a New York City taxi API, extracting relevant information, and uploading it to Google Cloud Storage (GCS). The data is sourced from the NYC Taxi & Limousine Commission website.

## Project Structure

The project consists of the following components:

1. **Data Loading Block (`data_loader.py`):**
   - Utilizes the Mage framework to create a data loading block.
   - Scrapes data from the NYC Taxi & Limousine Commission website.
   - Loads the data into a Pandas DataFrame with specified data types and parsing dates.
   - Output is then tested using a predefined test function.

2. **Data Export Block (`data_exporter.py`):**
   - Utilizes the Mage framework to create a data export block.
   - Adds a new column to the data representing the month of the pickup.
   - Converts the Pandas DataFrame to a PyArrow table.
   - Exports the data to Google Cloud Storage using the PyArrow GCS FileSystem.
   
3. **Dockerfile (`Dockerfile`):**
   - Uses the MageAI base image (`mageai/mageai:latest`).
   - Sets the environment variables and installs project dependencies from `requirements.txt`.

4. **Docker Compose (`docker-compose.yml`):**
   - Defines a Docker service named "magic" based on the Dockerfile.
   - Mounts the project source code, secrets, and environment variables.
   - Exposes port 6789 for potential Mage interaction.

## Running the Project

1. **Build the Docker Image:**
   ```bash
   docker-compose build
   ```

2. **Run the Docker Container:**
   ```bash
   docker-compose up
   ```

   The Mage framework is started using the specified project name.

3. **Usage:**
   - The data loading block is triggered using Mage commands (e.g., `mage run webscrape_&_api_load_data`).
   - The data export block is triggered using Mage commands (e.g., `mage run export_data_to_gcs`).

4. **Google Cloud Storage Setup:**
   - Ensure that the Google Cloud Storage credentials (`personal-gcp.json`) are provided in the project directory.

## Additional Information

- **MageAI Base Image:**
  The project is based on the MageAI base image (`mageai/mageai:latest`) containing the Mage framework and dependencies.

- **Google Cloud Storage:**
  The data is exported to the specified GCS bucket (`green-taxi-data-2022`) with partitioning based on the pickup month.

- **Testing:**
  The project includes a basic test (`test_output` function) to ensure the correctness of the data loading block output.

- **Restart Policy:**
  The Docker service is configured to restart on failure up to 5 times.

- **Environment Variables:**
  The environment variables are specified in a `.env` file and used in the Docker Compose file.

### 1. **Data Loading Block (`webscrape_&_api_load_data.py`):**

```python
# Import necessary libraries
import io
import pandas as pd
import requests
from bs4 import BeautifulSoup
from collections import defaultdict

# Mage block decorators
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

# Define the data loading function
@data_loader
def load_data_from_api(*args, **kwargs):
    def webscrape_data(url, year):
        # Web scraping logic to extract links based on the specified year
        # ...

    # Call the webscraping function
    url_list = webscrape_data('https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page', 2022)

    # Define data types for columns
    taxi_dtypes = {
        'VendorID': pd.Int64Dtype(),
        'passenger_count': pd.Int64Dtype(),
        # ... (other columns)
    }

    # Columns to parse as dates
    parse_dates = ['tpep_pickup_datetime', 'tpep_dropoff_datetime']

    final_data = pd.DataFrame()

    # Loop through URLs and concatenate data
    for url in url_list:
        df = pd.read_csv(url, sep=',', compression="gzip", dtype=taxi_dtypes, parse_dates=parse_dates)
        final_data = pd.concat([final_data, df], ignore_index=True)

    return final_data

# Test function
@test
def test_output(output, *args) -> None:
    assert output is not None, 'The output is undefined'
```

- **Objective:**
  - Loads data from the NYC Taxi & Limousine Commission website using web scraping.
  - Utilizes the Mage framework to create a data loading block (`webscrape_&_api_load_data`).

- **Key Functions:**
  - **`webscrape_data(url, year)`**: Scrapes data from the provided URL and extracts relevant links based on the specified year.
  - **`load_data_from_api(*args, **kwargs)`**: Main function that loads data from the extracted links, concatenates it into a Pandas DataFrame, and returns the final data.

- **Data Types and Parsing:**
  - Specifies data types using `pd.Int64Dtype()` and `float` for specific columns.
  - Defines columns to parse as dates using the `parse_dates` parameter in `pd.read_csv`.

- **Testing:**
  - Includes a testing function (`test_output`) to ensure the correctness of the block's output.

### 2. **Data Export Block (`export_data_to_gcs.py`):**

```python
# Import necessary libraries
import pyarrow as pa
import os

# Mage block decorator
if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

# Set Google Cloud Storage credentials
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "home/src/google-cred.json"

# GCS bucket and project details
bucket_name = 'green-taxi-data-2022'
project_id = 'api_to_bigquery'
root_path = f'{bucket_name}'

# Define the data export function
@data_exporter
def export_data_to_google_cloud_storage(data, *args, **kwargs) -> None:
    # Add a new column for the month of pickup
    data['tpep_pickup_month'] = data['tpep_pickup_datetime'].dt.month

    # Convert the data to a PyArrow table
    table = pa.Table.from_pandas(data)

    # Use PyArrow's GCS FileSystem to write the table to GCS
    gcs = pa.fs.GcsFileSystem()
    pa.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=['tpep_pickup_month'],
        filesystem=gcs
    )
```

- **Objective:**
  - Exports the loaded data to Google Cloud Storage.
  - Utilizes the Mage framework to create a data export block (`export_data_to_gcs`).

- **Key Functions:**
  - **`export_data_to_google_cloud_storage(data, *args, **kwargs)`**: Main function that adds a new column representing the month of pickup, converts the data to a PyArrow table, and exports it to Google Cloud Storage.

- **Google Cloud Storage Setup:**
  - Specifies the GCS bucket name (`green-taxi-data-2022`) and project ID (`api_to_bigquery`).
  - Defines a root path within the GCS bucket.

- **PyArrow Usage:**
  - Converts the Pandas DataFrame to a PyArrow table for efficient handling and partitioning.
  - Utilizes PyArrow's GCS FileSystem to write the table to GCS.

- **Environment Variables:**
  - Sets the Google Cloud Storage credentials (`GOOGLE_APPLICATION_CREDENTIALS`) as an environment variable.

### Additional Notes:

- **Dockerfile:**
  - Utilizes the MageAI base image.
  - Installs project dependencies from `requirements.txt`.

- **Docker Compose:**
  - Defines a Docker service named "magic" based on the Dockerfile.
  - Mounts project source code, secrets, and environment variables.

These blocks are designed to be modular and can be executed independently using Mage commands. Adjustments and extensions can be made as needed for specific use cases and requirements.
