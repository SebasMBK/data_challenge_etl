from db import db
import os

# Container's environment variables
table_schema = os.getenv("TABLE_SCHEMA",'employees')
departments_table_name = os.getenv("DEPARTMENTS_TABLE_NAME",'departments')


# This creates our departments table model to be used with SQLAlchemy
class departments_model(db.Model):
    __table_args__ = {"schema":f"{table_schema}"}
    __tablename__ = f"{departments_table_name}"

    id = db.Column(db.Integer, primary_key=True, unique=True)
    department = db.Column(db.String(255), nullable=False, unique=True)