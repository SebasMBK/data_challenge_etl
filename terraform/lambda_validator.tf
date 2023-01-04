# This will compress all the files inside the directory "validators_functions/[table_name]"

# This will create our lambda validator function for hired employees
data "archive_file" "zip_hired_employees_validator_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/validator_functions/hired_employees/"
  output_path = "../lambda_functions/validator_functions/hired_employees/hired_employees_validator.zip"
}

# This creates the lambda function
resource "aws_lambda_function" "hired_employees_lambda_validator" {
  filename      = data.archive_file.zip_hired_employees_validator_files.output_path
  function_name = var.lambda_validator_hired_employees_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_validator.arn]
  handler       = "lambda_validator_hired.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      origin_bucket_name      = var.origin_hired_employees_bucket_name
      origin_filename         = var.origin_hired_employees_filename
      access_bucket_name      = var.access_hired_employees_bucket_name
      access_filename         = var.access_hired_employees_filename
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_validator_hired_employees_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "lambda_url_validator_hired_employees" {
  function_name      = aws_lambda_function.hired_employees_lambda_validator.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "lambda_validator_hired_employees_logs" {
  name              = "/aws/lambda/${var.lambda_validator_hired_employees_name}"
  retention_in_days = 30
}





# This will create our lambda validator function for departments
data "archive_file" "zip_departments_validator_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/validator_functions/departments/"
  output_path = "../lambda_functions/validator_functions/departments/departments_validator.zip"
}

# This creates the lambda function
resource "aws_lambda_function" "departments_lambda_validator" {
  filename      = data.archive_file.zip_departments_validator_files.output_path
  function_name = var.lambda_validator_departments_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_validator.arn]
  handler       = "lambda_validator_departments.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      origin_bucket_name      = var.origin_departments_bucket_name
      origin_filename         = var.origin_departments_filename
      access_bucket_name      = var.access_departments_bucket_name
      access_filename         = var.access_departments_filename
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_validator_departments_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "lambda_url_validator_departments" {
  function_name      = aws_lambda_function.departments_lambda_validator.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "lambda_validator_departments_logs" {
  name              = "/aws/lambda/${var.lambda_validator_departments_name}"
  retention_in_days = 30
}





# This will create our lambda validator function for jobs
data "archive_file" "zip_jobs_validator_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/validator_functions/jobs/"
  output_path = "../lambda_functions/validator_functions/jobs/jobs_validator.zip"
}

# This creates the lambda function
resource "aws_lambda_function" "jobs_lambda_validator" {
  filename      = data.archive_file.zip_jobs_validator_files.output_path
  function_name = var.lambda_validator_jobs_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_validator.arn]
  handler       = "lambda_validator_jobs.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      origin_bucket_name      = var.origin_jobs_bucket_name
      origin_filename         = var.origin_jobs_filename
      access_bucket_name      = var.access_jobs_bucket_name
      access_filename         = var.access_jobs_filename
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_validator_jobs_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "lambda_url_validator_jobs" {
  function_name      = aws_lambda_function.jobs_lambda_validator.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "lambda_validator_jobs_logs" {
  name              = "/aws/lambda/${var.lambda_validator_jobs_name}"
  retention_in_days = 30
}