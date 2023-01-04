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