from db import db
import os

# Container's environment variables
table_schema = os.getenv("TABLE_SCHEMA",'employees')
jobs_table_name = os.getenv("JOBS_TABLE_NAME",'jobs')


# This creates our jobs table model to be used with SQLAlchemy
class jobs_model(db.Model):
    __table_args__ = {"schema":f"{table_schema}"}
    __tablename__ = f"{jobs_table_name}"

    id = db.Column(db.Integer, primary_key=True, unique=True)
    job = db.Column(db.String(255), nullable=False, unique=True)
    