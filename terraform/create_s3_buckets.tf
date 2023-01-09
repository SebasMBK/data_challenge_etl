resource "aws_s3_bucket" "glue_scripts_bucket" {
  bucket        = var.glue_scripts_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "glue_scripts_bucket_versioning" {
  bucket = aws_s3_bucket.glue_scripts_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "glue_temp_bucket" {
  bucket        = "project-glue-temp-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "glue_temp_bucket_versioning" {
  bucket = aws_s3_bucket.glue_temp_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "hired_employees_backup_bucket" {
  bucket        = var.hired_employees_backup_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "hired_employees_backup_versioning" {
  bucket = aws_s3_bucket.hired_employees_backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "bucket_trigger_lambda_hired_employees" {
  bucket = aws_s3_bucket.hired_employees_backup_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.hired_employees_lambda_trigger.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.temp_folder_backup_name}/"
    filter_suffix       = ".parquet"
  }

  depends_on = [aws_lambda_permission.allow_bucket_trigger_hired_employees]
}

resource "aws_s3_bucket" "departments_backup_bucket" {
  bucket        = var.departments_backup_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "departments_backup_versioning" {
  bucket = aws_s3_bucket.departments_backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "bucket_trigger_lambda_departments" {
  bucket = aws_s3_bucket.departments_backup_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.departments_lambda_trigger.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.temp_folder_backup_name}/"
    filter_suffix       = ".parquet"
  }

  depends_on = [aws_lambda_permission.allow_bucket_trigger_departments]
}

resource "aws_s3_bucket" "jobs_backup_bucket" {
  bucket        = var.jobs_backup_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "jobs_backup_versioning" {
  bucket = aws_s3_bucket.jobs_backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "bucket_trigger_lambda_jobs" {
  bucket = aws_s3_bucket.jobs_backup_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.jobs_lambda_trigger.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.temp_folder_backup_name}/"
    filter_suffix       = ".parquet"
  }

  depends_on = [aws_lambda_permission.allow_bucket_trigger_jobs]
}

resource "aws_s3_bucket" "access_hired_employees_bucket" {
  bucket        = var.access_hired_employees_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "access_hired_employees_versioning" {
  bucket = aws_s3_bucket.access_hired_employees_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "access_departments_bucket" {
  bucket        = var.access_departments_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "access_department_versioning" {
  bucket = aws_s3_bucket.access_departments_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "access_jobs_bucket" {
  bucket        = var.access_jobs_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "access_jobs_versioning" {
  bucket = aws_s3_bucket.access_jobs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# These packages will be used for our lambda layers
resource "aws_s3_bucket" "packages_bucket" {
  bucket        = var.packages_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "packages_bucket_versioning" {
  bucket = aws_s3_bucket.packages_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "packages1" {
  bucket = aws_s3_bucket.packages_bucket.bucket
  key    = "packages_validator.zip"
  source = "../packages/packages1.zip"
}

resource "aws_s3_object" "packages2" {
  bucket = aws_s3_bucket.packages_bucket.bucket
  key    = "packages_redshift.zip"
  source = "../packages/packages2.zip"
}