import redshift_connector

def upload_to_staging(
    host:str,
    database:str,
    user:str,
    password:str,
    access_bucket_name:str,
    access_data_filename:str,
    staging_table:str,
    iam_role_arn:str,
    schema_name:str
):

    with redshift_connector.connect(

        host=host,
        database=database,
        user=user,
        password=password

    ) as conn:
    
        conn.autocommit = True

        with conn.cursor() as cursor:

            cursor.execute(f"""

            COPY {schema_name}.{staging_table} FROM 's3://{access_bucket_name}/{access_data_filename}'
            CREDENTIALS 'aws_iam_role={iam_role_arn}' IGNOREHEADER 1 DELIMITER ',' CSV;

            """)

def upload_to_main(
    host:str,
    database:str,
    user:str,
    password:str,
    main_table:str,
    staging_table:str,
    schema_name:str
):

    with redshift_connector.connect(

        host=host,
        database=database,
        user=user,
        password=password

    ) as conn:
    
        conn.autocommit = True

        with conn.cursor() as cursor:

            cursor.execute(f"""

            UPDATE {schema_name}.{main_table} m_tbl
            SET department = s_tbl.department
            FROM {schema_name}.{staging_table} s_tbl
            WHERE m_tbl.id = s_tbl.id;
            
            """)

            cursor.execute(f"""

            DELETE FROM {schema_name}.{staging_table}
            USING {schema_name}.{main_table}
            WHERE {schema_name}.{staging_table}.id = {schema_name}.{main_table}.id;
            
            """)
            

            cursor.execute(f"""

            INSERT INTO {schema_name}.{main_table}
            SELECT * FROM {schema_name}.{staging_table};
            
            
            """)
            
            
            cursor.execute(f"""
            
            DROP TABLE {schema_name}.{staging_table}
            
            """)