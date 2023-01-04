# This will take the compressed file with all the necessary packages and take it to lambda layers
resource "aws_lambda_layer_version" "lambda_layer_validator" {
  s3_bucket  = aws_s3_bucket.packages_bucket.bucket
  s3_key     = aws_s3_object.packages1.key
  layer_name = "packages_validator_layer_lambda"

  compatible_runtimes      = [var.function_runtime]
  compatible_architectures = [var.function_arch]
}

resource "aws_lambda_layer_version" "lambda_layer_redshift" {
  s3_bucket  = aws_s3_bucket.packages_bucket.bucket
  s3_key     = aws_s3_object.packages2.key
  layer_name = "packages_redshift_layer_lambda"

  compatible_runtimes      = [var.function_runtime]
  compatible_architectures = [var.function_arch]
}