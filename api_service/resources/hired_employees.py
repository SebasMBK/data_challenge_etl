from flask.views import MethodView
from flask_smorest import Blueprint, abort
from flask_jwt_extended import jwt_required

from resources.schemas import HiredEmployeesSchema
from models import hired_employees_model, departments_model, jobs_model

from db import db
from sqlalchemy.exc import SQLAlchemyError

import os
from datetime import datetime

# Container's environment variables
table_schema = os.getenv("TABLE_SCHEMA",'employees')
hired_employees_table_name = os.getenv("HIRED_EMPLOYEES_TABLE_NAME",'hired_employees')
iam_role = os.getenv("IAM_ROLE")
s3_bucket_backup = os.getenv("HIRED_EMPLOYEES_BACKUP_BUCKET","backup-hired-employees-table")
temp_backup_folder = os.getenv("TEMP_BACKUP_FOLDER","temp_backup_folder")
table_backup_folder = os.getenv("BACKUP_FOLDER","table_backup_folder")


# This initiates the blueprint for the departments endpoints
blp = Blueprint("hired_employees", __name__, description="Operations on hired_employees")

# Methods for the "/hiredemployees" route
# jwt_required means authentication requirement
@jwt_required()
@blp.route("/hiredemployees")
class AllHiredEmployees(MethodView):

    # This GET method returns all the data in our table
    # Used for testing purposes
    @blp.response(200, HiredEmployeesSchema(many=True))
    def get(self):
        return hired_employees_model.query.all()

    # This POST method creates one or many records for our table
    @blp.arguments(HiredEmployeesSchema(many=True))
    @blp.response(201, HiredEmployeesSchema(many=True))
    def post(self, new_hires):
        hires = [hired_employees_model(**record) for record in new_hires]

        # 1000 is the limit of transactions for this method
        if len(hires) > 1000:
            abort(400, message="The transaction limit is of 1000")

        # Redshift doesn't enforces uniqueness or primary/foreign keys,
        # therefore, it is necessary to implement these if/for-loop statements to
        # prevent duplicated values
        for row in new_hires:

            if hired_employees_model.query.get(row['id']):
                abort(400, message=f'The employee id {row["id"]} already exists.')

            if jobs_model.query.get(row['job_id']):
                pass
            else:
                abort(404, message=f"The job id {row['job_id']} doesn't exist.")
            
            if departments_model.query.get(row['department_id']):
                pass
            else:
                abort(404, message=f"The department id {row['department_id']} doesn't exist.")

        try:
            db.session.add_all(hires)
            db.session.commit()
        except SQLAlchemyError as e:
            abort(500, message=f"{e}")
        
        return hires

# Backup Method
@jwt_required()
@blp.route('/hiredemployees/backup')
class HiredEmployeesBackup(MethodView):
    def get(self):
   
        # This is for assigning a date to the backup filename
        current_time = datetime.now()
        backup_time = current_time.strftime("%Y-%m-%dT%H:%M:%S")

        # Executes an UNLOAD statement that copies the current data in our table to an S3 bucket
        db.session.execute(f"""

        UNLOAD ('SELECT * FROM {table_schema}.{hired_employees_table_name}')
        TO 's3://{s3_bucket_backup}/{temp_backup_folder}/backup_{backup_time}' 
        IAM_ROLE '{iam_role}'
        FORMAT PARQUET
        PARALLEL OFF;

        """)

        return {"message":f"Backup for hired employees completed with the name backup_{backup_time}000."}, 200

# Restore Method
@jwt_required()
@blp.route('/hiredemployees/restore/<string:backup_name>')
class HiredEmployeesRestore(MethodView):
    def get(self, backup_name):
   

        # This truncates our table and then copies the selected data(identified by date) from an S3 bucket
        db.session.execute(f"""

        TRUNCATE {table_schema}.{hired_employees_table_name};

        COPY {table_schema}.{hired_employees_table_name}
        FROM 's3://{s3_bucket_backup}/{table_backup_folder}/{backup_name}/part'
        IAM_ROLE '{iam_role}'
        FORMAT AS AVRO 'auto';

        """)

        return {"message":"Hired employees table restored."}, 200