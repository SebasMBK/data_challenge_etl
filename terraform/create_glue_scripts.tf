# This file will be used to create the glue scripts that will convert data from parquet to AVRO

# Glue script for hired employees
resource "local_file" "glue_script_hired_employees" {
  content  = <<EOF
import sys
import boto3
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)


s3 = boto3.resource('s3')
my_bucket = s3.Bucket('${var.hired_employees_backup_bucket_name}')

for object in my_bucket.objects.filter(Prefix='${var.temp_folder_backup_name}'):
    
    object_in_bucket = object.key.split('/')[1]
    name_of_backup_file = object_in_bucket.split('.')[0]
    
    backups_parquet = glueContext.create_dynamic_frame.from_options(
        format_options={},
        connection_type="s3",
        format="parquet",
        connection_options={
            "paths": [
                f"s3://${var.hired_employees_backup_bucket_name}/${var.temp_folder_backup_name}/{object_in_bucket}"
            ],
            "recurse": False,
        },
        transformation_ctx="backups_parquet",
    )
    
    Mapping = ApplyMapping.apply(
        frame=backups_parquet,
        mappings=[
            ("id", "int", "id", "int"),
            ("name", "string", "name", "string"),
            ("datetime_", "timestamp", "datetime_", "string"),
            ("department_id", "int", "department_id", "int"),
            ("job_id", "int", "job_id", "int"),
        ],
        transformation_ctx="Mapping",
    )
    
    convert_to_avro = Mapping.toDF().repartition(1).write.mode("overwrite").format("avro").save(f"s3://${var.hired_employees_backup_bucket_name}/${var.backup_folder_name}/{name_of_backup_file}")
    
    delete_temp_files = glueContext.purge_s3_path("s3://${var.hired_employees_backup_bucket_name}/${var.temp_folder_backup_name}", options={"retentionPeriod": 0})
    
job.commit()

EOF
  filename = "../glue_scripts/${var.glue_py_hired_employees_name}"
}

resource "aws_s3_object" "glue_job_hired_employees" {
  bucket = aws_s3_bucket.glue_scripts_bucket.bucket
  key    = var.glue_py_hired_employees_name
  source = local_file.glue_script_hired_employees.filename
}




# Glue script for departments
resource "local_file" "glue_script_departments" {
  content  = <<EOF
import sys
import boto3
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)


s3 = boto3.resource('s3')
my_bucket = s3.Bucket('${var.departments_backup_bucket_name}')

for object in my_bucket.objects.filter(Prefix='${var.temp_folder_backup_name}'):
    
    object_in_bucket = object.key.split('/')[1]
    name_of_backup_file = object_in_bucket.split('.')[0]
    
    backups_parquet = glueContext.create_dynamic_frame.from_options(
        format_options={},
        connection_type="s3",
        format="parquet",
        connection_options={
            "paths": [
                f"s3://${var.departments_backup_bucket_name}/${var.temp_folder_backup_name}/{object_in_bucket}"
            ],
            "recurse": False,
        },
        transformation_ctx="backups_parquet",
    )
    
    Mapping = ApplyMapping.apply(
        frame=backups_parquet,
        mappings=[
            ("id", "int", "id", "int"),
            ("department", "string", "department", "string"),
        ],
        transformation_ctx="Mapping",
    )
    
    convert_to_avro = Mapping.toDF().repartition(1).write.mode("overwrite").format("avro").save(f"s3://${var.departments_backup_bucket_name}/${var.backup_folder_name}/{name_of_backup_file}")
    
    delete_temp_files = glueContext.purge_s3_path("s3://${var.departments_backup_bucket_name}/${var.temp_folder_backup_name}", options={"retentionPeriod": 0})
    
job.commit()

EOF
  filename = "../glue_scripts/${var.glue_py_departments_name}"
}

resource "aws_s3_object" "glue_job_departments" {
  bucket = aws_s3_bucket.glue_scripts_bucket.bucket
  key    = var.glue_py_departments_name
  source = local_file.glue_script_departments.filename
}





# Glue script for jobs
resource "local_file" "glue_script_jobs" {
  content  = <<EOF
import sys
import boto3
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)


s3 = boto3.resource('s3')
my_bucket = s3.Bucket('${var.jobs_backup_bucket_name}')

for object in my_bucket.objects.filter(Prefix='${var.temp_folder_backup_name}'):
    
    object_in_bucket = object.key.split('/')[1]
    name_of_backup_file = object_in_bucket.split('.')[0]
    
    backups_parquet = glueContext.create_dynamic_frame.from_options(
        format_options={},
        connection_type="s3",
        format="parquet",
        connection_options={
            "paths": [
                f"s3://${var.jobs_backup_bucket_name}/${var.temp_folder_backup_name}/{object_in_bucket}"
            ],
            "recurse": False,
        },
        transformation_ctx="backups_parquet",
    )
    
    Mapping = ApplyMapping.apply(
        frame=backups_parquet,
        mappings=[
            ("id", "int", "id", "int"),
            ("job", "string", "job", "string"),
        ],
        transformation_ctx="Mapping",
    )
    
    convert_to_avro = Mapping.toDF().repartition(1).write.mode("overwrite").format("avro").save(f"s3://${var.jobs_backup_bucket_name}/${var.backup_folder_name}/{name_of_backup_file}")
    
    delete_temp_files = glueContext.purge_s3_path("s3://${var.jobs_backup_bucket_name}/${var.temp_folder_backup_name}", options={"retentionPeriod": 0})
    
job.commit()

EOF
  filename = "../glue_scripts/${var.glue_py_jobs_name}"
}

resource "aws_s3_object" "glue_job_jobs" {
  bucket = aws_s3_bucket.glue_scripts_bucket.bucket
  key    = var.glue_py_jobs_name
  source = local_file.glue_script_jobs.filename
}