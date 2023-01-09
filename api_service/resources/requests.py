# In this file we will create the blueprints for the endpoints related to the client's specific 
# metrics request.

from flask.views import MethodView
from flask_smorest import Blueprint, abort
from flask_jwt_extended import jwt_required

from resources.schemas import EmployeesHiredDepartment, QuarterlyHiredEmployees

from db import db
from sqlalchemy.exc import SQLAlchemyError


# This initiates the blueprint for the requests endpoints
blp = Blueprint("Client's metrics request", __name__, description="Operations for the client's request")


# Number of employees hired for each job and department in 2021 divided by quarter.
@blp.route("/qtrlyhired")
class QtrlyHired(MethodView):

    @jwt_required()
    @blp.response(200, QuarterlyHiredEmployees(many=True),
                    description="Number of employees hired for each job and department in 2021 divided by quarter.")
    def get(self):
        try:
            result = db.session.execute("""
            
            -- CTE statements

            WITH joined_table AS (
                SELECT
                    department,
                    job,
                    datetime_
                FROM
                    employees.hired_employees AS he
                INNER JOIN
                    employees.departments AS d
                ON
                    he.department_id  = d.id
                INNER JOIN
                    employees.jobs AS j
                ON
                    he.job_id = j.id
                WHERE
                    DATE_PART('year', datetime_) = 2021
            ),
            table_with_qtr AS (
                SELECT 
                    department,
                    job,
                    datetime_,
                    CASE
                        WHEN DATE_PART('quarter', datetime_) = 1 THEN 'q1'
                        WHEN DATE_PART('quarter', datetime_) = 2 THEN 'q2'
                        WHEN DATE_PART('quarter', datetime_) = 3 THEN 'q3'
                        WHEN DATE_PART('quarter', datetime_) = 4 THEN 'q4'
                    END quarter 
                FROM
                    joined_table
            )

            -- End of CTE statements

            SELECT
                department,
                job,
                q1,
                q2,
                q3,
                q4
            FROM (
                SELECT
                    department,
                    job,
                    CAST(quarter as VARCHAR(10))
                FROM
                    table_with_qtr
            )
            PIVOT (
                COUNT(*)
                FOR quarter
                IN
                    ('q1', 'q2', 'q3', 'q4')
            )
            ORDER BY
                department,
                job;
                
            """)

            return result

        except SQLAlchemyError as e:
            abort(500, message=f"An error ocurred when executing the query: {e}")



# id's, names and number of employees hired for each department for 2021 greater than the mean
@blp.route("/hired2021")
class HiredDepartment(MethodView):

    @jwt_required()
    @blp.response(200, EmployeesHiredDepartment(many=True),
                    description="""
                    List of ids, name and number of employees hired of each department that hired more
                    employees than the mean of employees hired in 2021 for all the departments.
                    """)
    def get(self):
        try:
            result = db.session.execute("""

            -- CTE statements

            WITH hired_employees_department AS (
                SELECT
                    DISTINCT
                        d.id,
                        department,
                        COUNT(*) OVER(PARTITION BY department) AS hired
                FROM
                    employees.hired_employees AS he
                INNER JOIN
                    employees.departments AS d
                ON
                    he.department_id = d.id
                WHERE
                    DATE_PART('year', datetime_) = 2021
            ),
            mean_hired_employees AS (
                SELECT
                    AVG(hired) as mean
                FROM
                    hired_employees_department
            )

            -- End of CTE statements

            SELECT
                id,
                department,
                hired
            FROM
                hired_employees_department
            WHERE
                hired > (SELECT
                            mean
                        FROM
                        mean_hired_employees
                        )
            ORDER BY
                hired DESC
            
            """)

            return result
            
        except SQLAlchemyError as e:
            abort(500, message=f"An error ocurred when executing the query: {e}")