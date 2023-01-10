from flask import current_app, request
from flask.views import MethodView
from flask_smorest import Blueprint, abort
from flask_jwt_extended import jwt_required

from resources.schemas import DepartmentsSchema
from models import departments_model

from db import db
from sqlalchemy.exc import SQLAlchemyError

import os
from datetime import datetime

# Container's environment variables
table_schema = os.getenv("TABLE_SCHEMA",'employees')
departments_table_name = os.getenv("DEPARTMENTS_TABLE_NAME",'departments')
iam_role = os.getenv("IAM_ROLE")
s3_bucket_backup = os.getenv("DEPARTMENTS_BACKUP_BUCKET","backup-departments-table")
temp_backup_folder = os.getenv("TEMP_BACKUP_FOLDER","temp_backup_folder")
table_backup_folder = os.getenv("BACKUP_FOLDER","backup_folder")


# This initiates the blueprint for the departments endpoints
blp = Blueprint("departments", __name__, description="Operations on departments")

# This will print into the log console all the requests made to our app for this blueprint
@blp.before_request
def log_request_info():
        try:
            current_app.logger.info('Body: %s', request.json)
        except:
            pass

# Methods for the "/departments" route
# jwt_required means authentication requirement
@blp.route("/departments")
class AllDepartments(MethodView):

    # This GET method returns all the data in our table
    # Used for testing purposes
    @jwt_required()
    @blp.response(200, DepartmentsSchema(many=True))
    def get(self):
        return departments_model.query.all()

    # This POST method creates one or many records for our table
    @jwt_required()
    @blp.arguments(DepartmentsSchema(many=True))
    @blp.response(201, DepartmentsSchema(many=True))
    def post(self, new_departments):
        departments = [departments_model(**record) for record in new_departments]

        # 1000 is the limit of transactions for this method
        if len(departments) > 1000:
            abort(400, message="The transaction limit is of 1000")
        
        # Redshift doesn't enforces uniqueness or primary/foreign keys,
        # therefore, it is necessary to implement these if/for-loop statements to
        # prevent duplicated values
        for row in new_departments:
            if departments_model.query.get(row['id']):
                abort(400, message=f'The department {row["id"]} already exists')
            
            if len(list(departments_model.query.filter_by(department=row['department']))) > 0:
                abort(400, message=f"There's already a department with the name {row['department']}.")

        try:
            db.session.add_all(departments)
            db.session.commit()
        except SQLAlchemyError as e:
            abort(500, message=f"{e}")
        
        return departments

# Backup Method
@blp.route('/departments/backup')
class DepartmentsBackup(MethodView):
    @jwt_required()
    def get(self):
   
        # This is for assigning a date to the backup filename
        current_time = datetime.now()
        backup_time = current_time.strftime("%Y-%m-%dT%H:%M:%S")

        # Executes an UNLOAD statement that copies the current data in our table to an S3 bucket
        db.session.execute(f"""
        UNLOAD ('SELECT * FROM {table_schema}.{departments_table_name}')
        TO 's3://{s3_bucket_backup}/{temp_backup_folder}/backup_{backup_time}' 
        IAM_ROLE '{iam_role}'
        FORMAT PARQUET
        PARALLEL OFF;
        """)

        return {"message":f"Backup for departments completed with the name backup_{backup_time}000."}, 200

# Restore Method
@blp.route('/departments/restore/<string:backup_name>')
class DepartmentsRestore(MethodView):
    @jwt_required()
    def get(self, backup_name):
   
        # This truncates our table and then copies the selected data(identified by date) from an S3 bucket
        db.session.execute(f"""
        TRUNCATE {table_schema}.{departments_table_name};
        COPY {table_schema}.{departments_table_name}
        FROM 's3://{s3_bucket_backup}/{table_backup_folder}/{backup_name}/part'
        IAM_ROLE '{iam_role}'
        FORMAT AS AVRO 'auto';
        """)

        return {"message":"Departments table restored."}, 200