import os
import json
import boto3

# Lambda environment variables
glue_job_name = os.getenv("GLUE_JOB_DEPARTMENTS","convert_files_departments")

# This lambda function will trigger our glue job whenever it recieves a notification from
# S3 indicating that a new object was created in the bucket
def lambda_handler(event, context):
    glue = boto3.client('glue', region_name='us-east-1')
    gluejobname = f"{glue_job_name}"

    try:
        runId = glue.start_job_run(JobName=gluejobname)
        status = glue.get_job_run(JobName=gluejobname, RunId=runId['JobRunId'])

        return {
            "statusCode":200,
            "body":json.dumps("Departments' Glue Job Triggered")
        }

    except Exception as e:
        return {
            "statusCode":400,
            "body":json.dumps(f"An error ocurred: {e}")
        }