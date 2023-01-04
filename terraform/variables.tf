variable "project_region" {
  type    = string
  default = "us-east-1"
}

variable "origin_hired_employees_bucket_name" {
  type    = string
  default = "origin-hired-employees"
}

variable "origin_departments_bucket_name" {
  type    = string
  default = "origin-departments"
}

variable "origin_jobs_bucket_name" {
  type    = string
  default = "origin-jobs"
}

variable "origin_hired_employees_filename" {
  type    = string
  default = "hired_employees.csv"
}

variable "origin_departments_filename" {
  type    = string
  default = "departments.csv"
}

variable "origin_jobs_filename" {
  type    = string
  default = "jobs.csv"
}

variable "access_hired_employees_bucket_name" {
  type    = string
  default = "access-data-hired-employees"
}

variable "access_departments_bucket_name" {
  type    = string
  default = "access-data-departments"
}

variable "access_jobs_bucket_name" {
  type    = string
  default = "access-data-jobs"
}

variable "access_hired_employees_filename" {
  type    = string
  default = "access_hired_employees.csv"
}

variable "access_departments_filename" {
  type    = string
  default = "access_departments.csv"
}

variable "access_jobs_filename" {
  type    = string
  default = "access_jobs.csv"
}

variable "packages_bucket_name" {
    type = string
    default = "lambdalayerspackages"
}

variable "lambda_validator_hired_employees_name" {
    type = string
    default = "validator_hired_employees"
}

variable "lambda_validator_departments_name" {
    type = string
    default = "validator_departments"
}

variable "lambda_validator_jobs_name" {
    type = string
    default = "validator_jobs"
}

variable "function_runtime" {
  type    = string
  default = "python3.9"
}

variable "function_arch" {
  type    = string
  default = "x86_64"
}