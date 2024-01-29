#Using pyarrow used for chunking logic partitioning here
import pyarrow as pa
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

#Google service credentials

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "home/src/google-cred.json"

bucket_name  = 'green-taxi-data-2022'
project_id = 'api_to_bigquery'


root_path = f'{bucket_name}'

@data_exporter
def export_data_to_google_cloud_storage(data,*args, **kwargs) -> None:
    
    data['tpep_pickup_month'] = data['tpep_pickup_datetime'].dt.month
    
    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pa.write_to_dataset(
        table,
        root_path = root_path,
        partition_cols = ['tpep_pickup_month'],
        filesystem =gcs  
    )