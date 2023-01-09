# This will compress all the files inside the directory "flask_app_users/"
data "archive_file" "zip_create_users_table_files" {
  type        = "zip"
  source_dir  = "../lambda_functions/flask_app_users/"
  output_path = "../lambda_functions/flask_app_users/create_users_table.zip"
}

# This creates the lambda function for users
resource "aws_lambda_function" "create_users_table" {
  filename      = data.archive_file.zip_create_users_table_files.output_path
  function_name = var.lambda_create_users_table_name
  role          = aws_iam_role.lambda_role_s3.arn
  layers        = [aws_lambda_layer_version.lambda_layer_redshift.arn]
  handler       = "lambda_flask.lambda_handler"
  timeout       = 300
  memory_size   = 512
  architectures = [var.function_arch]
  runtime       = var.function_runtime

  environment {
    variables = {
      database             = aws_redshift_cluster.project_cluster.database_name
      username             = aws_redshift_cluster.project_cluster.master_username
      password             = aws_redshift_cluster.project_cluster.master_password
      endpoint             = aws_redshift_cluster.project_cluster.endpoint
      main_table           = var.flask_users_table
      schema_name          = var.schema_name_flask
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.create_users_table_logs
  ]

}

# This is necessary to allow the creation of a URL
# It is possible to add restrictions to the authorization
resource "aws_lambda_function_url" "lambda_create_users_url" {
  function_name      = aws_lambda_function.create_users_table.function_name
  authorization_type = "NONE"
}

# Logging
resource "aws_cloudwatch_log_group" "create_users_table_logs" {
  name              = "/aws/lambda/${var.lambda_create_users_table_name}"
  retention_in_days = 30
}