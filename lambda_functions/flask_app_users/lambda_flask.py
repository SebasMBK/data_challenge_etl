from create_table_users import create_table_main, create_schema
import os
import json

def lambda_handler(event, context):

    # Lambda environment variables
    host = os.environ['endpoint'].split(":")[0]
    database = os.environ['database']
    user = os.environ['username']
    password = os.environ['password']
    main_table = os.environ['main_table']
    schema_name = os.environ['schema_name']
    
    try:
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
            schema_name=schema_name
        )

        return {
            "statusCode":200,
            "body":json.dumps("User's table created successfully")
        }

    except Exception as e:
        return {
            "statusCode":400,
            "body":json.dumps(f"An error ocurred: {e}")
        }
