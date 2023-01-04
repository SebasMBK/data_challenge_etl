import redshift_connector

def create_schema(
    host:str,
    database:str,
    user:str,
    password:str,
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

            CREATE SCHEMA IF NOT EXISTS {schema_name};

            """)

def create_table_main(
    host:str,
    database:str,
    user:str,
    password:str,
    main_table:str,
    departments_table:str,
    jobs_table:str,
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

            CREATE TABLE IF NOT EXISTS {schema_name}.{main_table} (
            id INT NOT NULL PRIMARY KEY,
            name VARCHAR(255),
            datetime_ timestamp,
            department_id INT REFERENCES {schema_name}.{departments_table} (id),
            job_id INT REFERENCES {schema_name}.{jobs_table} (id)
            );

            """)
            

def create_table_staging(
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
            CREATE TABLE IF NOT EXISTS {schema_name}.{staging_table} (LIKE {schema_name}.{main_table});
            """)