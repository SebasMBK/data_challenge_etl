from data_cleaner_hired import data_cleaner
from uploader_s3_hired import upload_s3
from model_pydantic_hired import hired_employees
from pydantic import ValidationError
import os
import json


def lambda_handler(event, context):

    origin_bucket_name = os.environ['origin_bucket_name']
    origin_filename = os.environ['origin_filename']
    access_bucket_name = os.environ['access_bucket_name']
    access_filename = os.environ['access_filename']
    
    clean_data = data_cleaner(origin_bucket_name=origin_bucket_name,
                                origin_filename=origin_filename)

    try:

        validated_data = [hired_employees.parse_obj(data_) for data_ in clean_data]

        upload_s3(access_bucket_name=access_bucket_name,
                access_filename=access_filename,
                data_dict=validated_data)
        
        return {
            "statusCode":200,
            "body":json.dumps("Data cleaned, validated and uploaded")
        }
    
    except ValidationError as e:

        return {
            "statusCode":400,
            "body":json.dumps(f"Error validating data: {e}")
        }

