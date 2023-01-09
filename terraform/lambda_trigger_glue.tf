# This will compress all the files inside the directory "trigger_glue_function/[table_name]"

# This will create our lambda trigger function for hired employees
data "archive_file" "zip_hired_employees_trigger_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/trigger_glue_function/hired_employees/"
  output_path = "../lambda_functions/trigger_glue_function/hired_employees/hired_employees_trigger.zip"
}

# This creates the lambda function
resource "aws_lambda_function" "hired_employees_lambda_trigger" {
  filename      = data.archive_file.zip_hired_employees_trigger_files.output_path
  function_name = var.lambda_trigger_hired_employees_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_validator.arn]
  handler       = "lambda_trigger_hired.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      GLUE_JOB_HIRED_EMPLOYEES      = var.glue_job_hired_employees_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_trigger_hired_employees_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "lambda_url_trigger_hired_employees" {
  function_name      = aws_lambda_function.hired_employees_lambda_trigger.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "lambda_trigger_hired_employees_logs" {
  name              = "/aws/lambda/${var.lambda_trigger_hired_employees_name}"
  retention_in_days = 30
}

# Allow trigger lambda function from S3
resource "aws_lambda_permission" "allow_bucket_trigger_hired_employees" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hired_employees_lambda_trigger.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.hired_employees_backup_bucket.arn
}





# This will create our lambda trigger function for departments
data "archive_file" "zip_departments_trigger_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/trigger_glue_function/departments/"
  output_path = "../lambda_functions/trigger_glue_function/departments/departments_trigger.zip"
}

# This creates the lambda function
resource "aws_lambda_function" "departments_lambda_trigger" {
  filename      = data.archive_file.zip_departments_trigger_files.output_path
  function_name = var.lambda_trigger_departments_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_validator.arn]
  handler       = "lambda_trigger_departments.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      GLUE_JOB_DEPARTMENTS      = var.glue_job_departments_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_trigger_departments_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "lambda_url_trigger_departments" {
  function_name      = aws_lambda_function.departments_lambda_trigger.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "lambda_trigger_departments_logs" {
  name              = "/aws/lambda/${var.lambda_trigger_departments_name}"
  retention_in_days = 30
}

# Allow trigger lambda function from S3
resource "aws_lambda_permission" "allow_bucket_trigger_departments" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.departments_lambda_trigger.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.departments_backup_bucket.arn
}




# This will create our lambda trigger function for jobs
data "archive_file" "zip_jobs_trigger_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/trigger_glue_function/jobs/"
  output_path = "../lambda_functions/trigger_glue_function/jobs/jobs_trigger.zip"
}

# This creates the lambda function
resource "aws_lambda_function" "jobs_lambda_trigger" {
  filename      = data.archive_file.zip_jobs_trigger_files.output_path
  function_name = var.lambda_trigger_jobs_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_validator.arn]
  handler       = "lambda_trigger_jobs.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      GLUE_JOB_JOBS     = var.glue_job_jobs_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_trigger_jobs_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "lambda_url_trigger_jobs" {
  function_name      = aws_lambda_function.jobs_lambda_trigger.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "lambda_trigger_jobs_logs" {
  name              = "/aws/lambda/${var.lambda_trigger_jobs_name}"
  retention_in_days = 30
}

# Allow trigger lambda function from S3
resource "aws_lambda_permission" "allow_bucket_trigger_jobs" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.jobs_lambda_trigger.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.jobs_backup_bucket.arn
}