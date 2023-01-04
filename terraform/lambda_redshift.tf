# This will compress all the files inside the directory "upload_redshift_function/[table_name]"
data "archive_file" "zip_hired_employees_redshift_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/upload_redshift_function/hired_employees/"
  output_path = "../lambda_functions/upload_redshift_function/hired_employees/hired_employees_redshift.zip"
}

# This creates the lambda function for hired employees
resource "aws_lambda_function" "hired_employees_lambda_redshift" {
  filename      = data.archive_file.zip_hired_employees_redshift_files.output_path
  function_name = var.lambda_redshift_hired_employees_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_redshift.arn]
  handler       = "lambda_redshift_hired.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      access_bucket_name    = aws_s3_bucket.access_hired_employees_bucket.bucket
      access_data_filename = var.access_hired_employees_filename
      database             = aws_redshift_cluster.project_cluster.database_name
      username             = aws_redshift_cluster.project_cluster.master_username
      password             = aws_redshift_cluster.project_cluster.master_password
      endpoint             = aws_redshift_cluster.project_cluster.endpoint
      iam_role_arn         = aws_iam_role.project_redshift_role.arn
      main_table           = var.hired_employees_table
      staging_table        = var.staging_table_hired_employees
      departments_table    = var.departments_table
      jobs_table           = var.jobs_table
      schema_name          = var.schema_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.hired_employees_lambda_redshift_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "hired_employees_lambda_url_redshift" {
  function_name      = aws_lambda_function.hired_employees_lambda_redshift.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "hired_employees_lambda_redshift_logs" {
  name              = "/aws/lambda/${var.lambda_redshift_hired_employees_name}"
  retention_in_days = 30
}





# This will compress all the files inside the directory "upload_redshift_function/[table_name]"
data "archive_file" "zip_departments_redshift_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/upload_redshift_function/departments/"
  output_path = "../lambda_functions/upload_redshift_function/departments/departments_redshift.zip"
}

# This creates the lambda function for departments
resource "aws_lambda_function" "departments_lambda_redshift" {
  filename      = data.archive_file.zip_departments_redshift_files.output_path
  function_name = var.lambda_redshift_departments_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_redshift.arn]
  handler       = "lambda_redshift_departments.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      access_bucket_name    = aws_s3_bucket.access_departments_bucket.bucket
      access_data_filename = var.access_departments_filename
      database             = aws_redshift_cluster.project_cluster.database_name
      username             = aws_redshift_cluster.project_cluster.master_username
      password             = aws_redshift_cluster.project_cluster.master_password
      endpoint             = aws_redshift_cluster.project_cluster.endpoint
      iam_role_arn         = aws_iam_role.project_redshift_role.arn
      main_table           = var.departments_table
      staging_table        = var.staging_table_departments
      schema_name          = var.schema_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.departments_lambda_redshift_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "departments_lambda_url_redshift" {
  function_name      = aws_lambda_function.departments_lambda_redshift.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "departments_lambda_redshift_logs" {
  name              = "/aws/lambda/${var.lambda_redshift_departments_name}"
  retention_in_days = 30
}





# This will compress all the files inside the directory "upload_redshift_function/[table_name]"
data "archive_file" "zip_jobs_redshift_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/upload_redshift_function/jobs/"
  output_path = "../lambda_functions/upload_redshift_function/jobs/jobs_redshift.zip"
}

# This creates the lambda function for jobs
resource "aws_lambda_function" "jobs_lambda_redshift" {
  filename      = data.archive_file.zip_jobs_redshift_files.output_path
  function_name = var.lambda_redshift_jobs_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_redshift.arn]
  handler       = "lambda_redshift_jobs.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      access_bucket_name    = aws_s3_bucket.access_jobs_bucket.bucket
      access_data_filename = var.access_jobs_filename
      database             = aws_redshift_cluster.project_cluster.database_name
      username             = aws_redshift_cluster.project_cluster.master_username
      password             = aws_redshift_cluster.project_cluster.master_password
      endpoint             = aws_redshift_cluster.project_cluster.endpoint
      iam_role_arn         = aws_iam_role.project_redshift_role.arn
      main_table           = var.jobs_table
      staging_table        = var.staging_table_jobs
      schema_name          = var.schema_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.jobs_lambda_redshift_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "jobs_lambda_url_redshift" {
  function_name      = aws_lambda_function.jobs_lambda_redshift.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "jobs_lambda_redshift_logs" {
  name              = "/aws/lambda/${var.lambda_redshift_jobs_name}"
  retention_in_days = 30
}