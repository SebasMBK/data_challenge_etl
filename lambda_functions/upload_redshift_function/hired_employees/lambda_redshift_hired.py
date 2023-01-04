from create_tables_hired import create_table_main, create_table_staging, create_schema
from upload_data_hired import upload_to_main, upload_to_staging
import os
import json

def lambda_handler(event, context):

    # ENV Variables
    host = os.environ['endpoint'].split(":")[0]
    database = os.environ['database']
    user = os.environ['username']
    password = os.environ['password']
    access_bucket_name = os.environ['access_bucket_name']
    access_data_filename = os.environ['access_data_filename']
    main_table = os.environ['main_table']
    staging_table = os.environ['staging_table']
    departments_table = os.environ['departments_table']
    jobs_table = os.environ['jobs_table']
    schema_name = os.environ['schema_name']
    iam_role_arn = os.environ['iam_role_arn']

    create_schema(
        host=host,
        database=database,
        user=user,
        password=password,
        schema_name=schema_name
        )

    create_table_main(
        host=host,
        database=database,
        user=user,
        password=password,
        main_table=main_table,
        departments_table=departments_table,
        jobs_table=jobs_table,
        schema_name=schema_name
    )

    create_table_staging(
        host=host,
        database=database,
        user=user,
        password=password,
        main_table=main_table,
        staging_table=staging_table,
        schema_name=schema_name
    )

    upload_to_staging(
        host=host,
        database=database,
        user=user,
        password=password,
        access_bucket_name=access_bucket_name,
        access_data_filename=access_data_filename,
        staging_table=staging_table,
        iam_role_arn=iam_role_arn,
        schema_name=schema_name
    )

    upload_to_main(
        host=host,
        database=database,
        user=user,
        password=password,
        main_table=main_table,
        staging_table=staging_table,
        schema_name=schema_name
    )

    return {
        "statusCode":200,
        "body":json.dumps("Hired employees data uploaded to redshift successfully")
    }