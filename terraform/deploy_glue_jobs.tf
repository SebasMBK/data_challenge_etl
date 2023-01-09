# This creates our glue jobs that convert the backup files from parquet to AVRO

# Glue job for hired employees
resource "aws_glue_job" "hired_employees_job" {
    name = var.glue_job_hired_employees_name
    role_arn = aws_iam_role.glue_role.arn
    glue_version = "4.0"
    worker_type = "G.1X"
    number_of_workers = 10

    command {
        script_location = "s3://${aws_s3_bucket.glue_scripts_bucket.bucket}/${var.glue_py_hired_employees_name}"
    }

    default_arguments = {
        "--job-language"                     = "python"
        "--continuous-log-logGroup"          = aws_cloudwatch_log_group.hired_employees_glue_logs.name
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-continuous-log-filter"     = "true"
        "--enable-metrics"                   = "true"
        "--job-bookmark-option"              = "job-bookmark-enable"
        "--TempDir"                          = "s3://${aws_s3_bucket.glue_temp_bucket.bucket}/temporary/"
    }
}

resource "aws_cloudwatch_log_group" "hired_employees_glue_logs" {
  name              = "hired_employees_glue_logs"
  retention_in_days = 30
}




# Glue job for departments
resource "aws_glue_job" "department_job" {
    name = var.glue_job_departments_name
    role_arn = aws_iam_role.glue_role.arn
    glue_version = "4.0"
    worker_type = "G.1X"
    number_of_workers = 10

    command {
        script_location = "s3://${aws_s3_bucket.glue_scripts_bucket.bucket}/${var.glue_py_departments_name}"
    }

    default_arguments = {
        "--job-language"                     = "python"
        "--continuous-log-logGroup"          = aws_cloudwatch_log_group.departments_glue_logs.name
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-continuous-log-filter"     = "true"
        "--enable-metrics"                   = "true"
        "--job-bookmark-option"              = "job-bookmark-enable"
        "--TempDir"                          = "s3://${aws_s3_bucket.glue_temp_bucket.bucket}/temporary_departments/"
    }
}

resource "aws_cloudwatch_log_group" "departments_glue_logs" {
  name              = "departments_glue_logs"
  retention_in_days = 30
}





# Glue job for jobs
resource "aws_glue_job" "jobs_job" {
    name = var.glue_job_jobs_name
    role_arn = aws_iam_role.glue_role.arn
    glue_version = "4.0"
    worker_type = "G.1X"
    number_of_workers = 10

    command {
        script_location = "s3://${aws_s3_bucket.glue_scripts_bucket.bucket}/${var.glue_py_jobs_name}"
    }

    default_arguments = {
        "--job-language"                     = "python"
        "--continuous-log-logGroup"          = aws_cloudwatch_log_group.jobs_glue_logs.name
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-continuous-log-filter"     = "true"
        "--enable-metrics"                   = "true"
        "--job-bookmark-option"              = "job-bookmark-enable"
        "--TempDir"                          = "s3://${aws_s3_bucket.glue_temp_bucket.bucket}/temporary_jobs/"
    }
}

resource "aws_cloudwatch_log_group" "jobs_glue_logs" {
  name              = "jobs_glue_logs"
  retention_in_days = 30
}