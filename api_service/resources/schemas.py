from marshmallow import Schema, fields

"""
Hired employees
"""

class HiredEmployeesSchema(Schema):
    id = fields.Int(required=True)
    name = fields.Str(required=True)
    datetime_ = fields.DateTime(required=True, format='%Y-%m-%dT%H:%M:%S%z')
    department_id = fields.Int(required=True)
    job_id = fields.Int(required=True)


"""
Departments
"""

class DepartmentsSchema(Schema):
    id = fields.Int(required=True)
    department = fields.Str(required=True)

"""
Jobs
"""

class JobsSchema(Schema):
    id = fields.Int(required=True)
    job = fields.Str(required=True)

"""
Users
"""

class UsersSchema(Schema):
    id = fields.Int(dump_only=True)
    username = fields.Str(required=True)
    password = fields.Str(required=True, load_only=True)

"""
Requirement 1: number of employees hired for each job and department in 2021 divided by quarter.
"""

class QuarterlyHiredEmployees(Schema):
    department = fields.Str(dump_only=True)
    job = fields.Str(dump_only=True)
    q1 = fields.Int(dump_only=True)
    q2 = fields.Int(dump_only=True)
    q3 = fields.Int(dump_only=True)
    q4 = fields.Int(dump_only=True)

"""
Requirement 2: id's, names and number of employees hired for each department that hired more employees
than the mean of employees hired in 2021.
"""

class EmployeesHiredDepartment(Schema):
    id = fields.Int(dump_only=True)
    department = fields.Str(dump_only=True)
    hired = fields.Int(dump_only=True)
