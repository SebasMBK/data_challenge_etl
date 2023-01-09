from db import db
import os

# Container's environment variables
table_schema = os.getenv("FLASK_TABLE_SCHEMA",'users')
users_table_name = os.getenv("USERS_TABLE_NAME",'users_table')


# This creates our users table model to be used with SQLAlchemy
class users_model(db.Model):
    __table_args__ = {"schema":f"{table_schema}"}
    __tablename__ = f"{users_table_name}"

    id = db.Column(db.Integer, primary_key=True, unique=True)
    username = db.Column(db.String(80), nullable=False, unique=True)
    password = db.Column(db.String, nullable=False)