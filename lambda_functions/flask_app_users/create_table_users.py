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
            id BIGINT IDENTITY(1,1),
            username VARCHAR(80) NOT NULL,
            password VARCHAR(300),
            PRIMARY KEY(id)
            );

            """)