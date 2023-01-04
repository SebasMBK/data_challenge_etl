import pandas as pd

def data_cleaner(origin_bucket_name, origin_filename):
    """
    This function will read the .csv files directly from the AWS S3 Bucket and clean it.

    Args:
    - origin_bucket_name: Name of the bucket where the data is stored
    - origin_filename: Name of the .csv file where the raw data is.
    """

    df = pd.read_csv(f's3://{origin_bucket_name}/{origin_filename}',names=['id','name','datetime_','department_id','job_id'])
    
    df["datetime_"] = df["datetime_"].fillna('1900-01-01T00:00:00Z')
    df["department_id"] = df["department_id"].fillna(0)
    df["job_id"] = df["job_id"].fillna(0)

    return df.to_dict("records")