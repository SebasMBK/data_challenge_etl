from db import db
import datetime
import os

# Container's environment variables
table_schema = os.getenv("TABLE_SCHEMA",'employees')
hired_employees_table_name = os.getenv("HIRED_EMPLOYEES_TABLE_NAME",'hired_employees')
departments_table_name = os.getenv("DEPARTMENTS_TABLE_NAME",'departments')
jobs_table_name = os.getenv("JOBS_TABLE_NAME",'jobs')


# This creates our hired employees table model to be used with SQLAlchemy
class hired_employees_model(db.Model):
    __table_args__ = {"schema":f"{table_schema}"}
    __tablename__ = f"{hired_employees_table_name}"

    id = db.Column(db.Integer, primary_key=True, unique=True)
    name = db.Column(db.String(255), nullable=False)
    datetime_ = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    department_id = db.Column(db.Integer, db.ForeignKey(f"{table_schema}.{departments_table_name}.id"), unique=False, nullable=True)
    job_id = db.Column(db.Integer, db.ForeignKey(f"{table_schema}.{jobs_table_name}.id"), unique=False, nullable=True)