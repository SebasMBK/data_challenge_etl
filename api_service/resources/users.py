from flask.views import MethodView
from flask_smorest import Blueprint, abort
from flask_jwt_extended import create_access_token, get_jwt, jwt_required

from resources.schemas import UsersSchema
from models.user import users_model
from blocklist import BLOCKLIST

from db import db
from sqlalchemy.exc import SQLAlchemyError
import os

from passlib.hash import pbkdf2_sha256

# Container's environment variables
table_schema = os.getenv("FLASK_TABLE_SCHEMA",'users')
users_table_name = os.getenv("USERS_TABLE_NAME",'users_table')

# This initiates the blueprint for the users endpoints
blp = Blueprint("Users", "users", description="Operations on Users")

# Methods for the "/login" route
# This will login our users that will make use of our Flask API
@blp.route("/login")
class UserLogin(MethodView):
    @blp.arguments(UsersSchema)
    def post(self, user_data):

        user = users_model.query.filter(
            users_model.username == user_data["username"]
        ).first()

        # This checks:
        # 1. That the user exists.
        # 2. That the hash value entered and the hash value stored in our database match.
        if user and pbkdf2_sha256.verify(user_data["password"], user.password):
            access_token = create_access_token(identity=user.id)
            return {"access_token": access_token}, 200
            
        abort(401, message="The passed credentials are invalid.")

# Methods for the "/logout" route
# This will logout our users
@blp.route("/logout")
class UserLogout(MethodView):
    @jwt_required()
    def post(self):
        
        # Paste the access token to the authorization header and send the post request to log out.
        jti = get_jwt()["jti"]
        BLOCKLIST.add(jti)

        return {"message":"Logged out succesfully."}, 200


# Methods for the "/register" route
# This will register our users
@blp.route("/register")
class UserRegistration(MethodView):
    @blp.arguments(UsersSchema)
    def post(self, user_data):

        # This checks if the username is already in use
        if users_model.query.filter(users_model.username == user_data["username"]).first():
            abort(409, message="A user with that username already exists.")
        
        username = user_data["username"]
        password = pbkdf2_sha256.hash(user_data["password"])

        # Redshift doesn't support sequences, because of this, we can't insert data using an
        # identity column like we would normally do it in PostgreSQL. Here we don't have a 
        # "[table_name]_id_seq" relationship, so we will insert the data using an SQL Raw statement.
        db.session.execute(f"""
        
            INSERT INTO {table_schema}.{users_table_name} (username, password)
            VALUES ('{username}', '{password}')
        
        """)
        
        db.session.commit()

        return {"message":"User created successfully."}, 201
