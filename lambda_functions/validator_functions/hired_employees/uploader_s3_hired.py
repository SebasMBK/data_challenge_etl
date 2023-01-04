import pandas as pd

def upload_s3(access_bucket_name, access_filename, data_dict):
    """
    This function takes a dictonary of validated data, converts it into a DF that is uploaded to
    our s3 bucket.

    Args:
    - access_bucket_name: Name of the bucket where our validated data will be stored
    - access_filename: Name of the .csv file that will be written containing the validated data
    - data_dict: Dictionary of data that contains the validated data that will be transformed
      to a .csv files and uploaded to s3
    """

    df = pd.DataFrame([s.__dict__ for s in data_dict])
    df.to_csv(f"s3://{access_bucket_name}/{access_filename}", index=False, encoding='utf-8-sig')
