import io
import pandas as pd
import requests
import BeautifulSoup
import defaultdict

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    ##Webscraping data from the nyc_taxi_website
    def webscrape_data(url,year):
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        link_tags = soup.find_all('a')
        links = defaultdict(list)
            
        final_year = '' if year == 'all' else year
            
        for link_tag in link_tags:
            href = link_tag.get('href')
            if f"green_tripdata_{final_year}" in href:
                month = href.split('-')[2].split('.')[0]
                year_num = href.split('_')[2].split('-')[0]
                if self.year == 'all':
                    links[year_num].append(href)
                else:
                    links[month].append(href)
            
            return links
        
    url_list=webscrape_data('https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page',2022)

    taxi_dtypes = {
        'VendorID': pd.Int64Dtype(),
        'passenger_count': pd.Int64Dtype(),
        'trip_distance': float,
        'RatecodeID': pd.Int64Dtype(),
        'store_and_fwd_flag': str,
        'PULocationID': pd.Int64Dtype(),
        'DOLocationID': pd.Int64Dtype(),
        'payment_type': pd.Int64Dtype(),
        'fare_amount': pd.Int64Dtype(),
        'extra': float,
        'tip_amount': float,
        'tolls_amount': float,
        'improvement_surcharge': float,
        'total_amount': float,
        'congestion_surcharge': float,
    }

    parse_dates=['tpep_pickup_datetime','tpep_dropoff_datetime']
    
    final_data=pd.DataFrame()

    for url in url_list:
        df=pd.read_csv(url,sep=',',compression="gzip",dtype=taxi_dtypes,parse_dates=parse_dates)
        final_data=pd.concat([final_data,df],ignore_index=True)
    return final_data

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'