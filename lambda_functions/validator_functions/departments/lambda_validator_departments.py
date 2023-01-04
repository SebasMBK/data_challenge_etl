from data_reader_departments import data_reader
from uploader_s3_departments import upload_s3
from model_pydantic_departments import departments
from pydantic import ValidationError
import os
import json


def lambda_handler(event, context):

    origin_bucket_name = os.environ['origin_bucket_name']
    origin_filename = os.environ['origin_filename']
    access_bucket_name = os.environ['access_bucket_name']
    access_filename = os.environ['access_filename']
    
    read_data = data_reader(origin_bucket_name=origin_bucket_name,
                                origin_filename=origin_filename)

    try:

        validated_data = [departments.parse_obj(data_) for data_ in read_data]

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

