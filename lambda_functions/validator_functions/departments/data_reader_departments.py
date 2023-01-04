import pandas as pd

def data_reader(origin_bucket_name, origin_filename):
    """
    This function will read the .csv files directly from the AWS S3 Bucket and convert it into a 
    dictionary.

    Args:
    - origin_bucket_name: Name of the bucket where the data is stored
    - origin_filename: Name of the .csv file where the raw data is.
    """

    df = pd.read_csv(f's3://{origin_bucket_name}/{origin_filename}',names=['id','department'])

    return df.to_dict("records")