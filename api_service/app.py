from db import db
from blocklist import BLOCKLIST

from flask import Flask, jsonify
from flask_smorest import Api
from flask_jwt_extended import JWTManager

from resources.hired_employees import blp as hired_employees_blueprint
from resources.departments import blp as departments_blueprint
from resources.jobs import blp as jobs_blueprint
from resources.requests import blp as metrics_blueprint
from resources.users import blp as users_blueprint

# This is our main file

# Here we define our function that will be executed by gunicorn inside the AWS lightsail container
def create_app():

    # Initiating the app
    app = Flask(__name__)
    app.config.from_pyfile("config.py")

    # Initiating the database
    db.init_app(app)

    # This initiates an instance of JWT
    jwt = JWTManager(app)

    # This is used for our logout endpoint. Everytime one of our users logs out, their access token
    # will be taken into a python set called BLOCKLIST. Then our app will validate against that python
    # set and will deny access to our app to the user that is using the no-longer valid token
    @jwt.token_in_blocklist_loader
    def token_in_blocklist(jwt_header, jwt_payload):
        return jwt_payload["jti"] in BLOCKLIST
    
    # The next jwt functions are here for error handling
    @jwt.revoked_token_loader
    def revoked_token(jwt_header, jwt_payload):
        return {
            jsonify(
                {"message":"This token has been revoked.", "error":"token_revoked"}
            ),
            401
        }

    @jwt.expired_token_loader
    def expired_token(jwt_header, jwt_payload):
        return {
            jsonify(
                {"message":"Your token has expired", "error":"token_expired"}
            ),
            401
        }
    @jwt.invalid_token_loader
    def invalid_token(error):
        return {
            jsonify(
                {"message":"The token is invalid.", "error":"invalid_token"}
            ),
            401
        }

    @jwt.unauthorized_loader
    def missing_token(error):
        return {
            jsonify(
                {"message":"No access token was found.", "error":"authorization_required"}
            ),
            401
        }

    # This connects flask_smorest with the app
    api = Api(app)

    # This registers the blueprints to the app
    api.register_blueprint(hired_employees_blueprint)
    api.register_blueprint(departments_blueprint)
    api.register_blueprint(jobs_blueprint)
    api.register_blueprint(metrics_blueprint)
    api.register_blueprint(users_blueprint)

    
    return app

