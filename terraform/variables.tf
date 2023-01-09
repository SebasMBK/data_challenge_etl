variable "project_region" {
  type    = string
  default = "us-east-1"
}

variable "glue_scripts_bucket_name" {
  type    = string
  default = "project-glue-scripts-bucket"
}

variable "glue_py_hired_employees_name" {
  type    = string
  default = "hired_employees_glue_script.py"
}

variable "glue_py_departments_name" {
  type    = string
  default = "departments_glue_script.py"
}

variable "glue_py_jobs_name" {
  type    = string
  default = "jobs_glue_script.py"
}

variable "hired_employees_backup_bucket_name" {
  type    = string
  default = "backup-hired-employees-table"
}

variable "departments_backup_bucket_name" {
  type    = string
  default = "backup-departments-table"
}

variable "jobs_backup_bucket_name" {
  type    = string
  default = "backup-jobs-table"
}

variable "temp_folder_backup_name" {
  type    = string
  default = "temp_backup_folder"
}

variable "backup_folder_name" {
  type    = string
  default = "backup_folder"
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

variable "lambda_trigger_hired_employees_name" {
    type = string
    default = "trigger_glue_hired_employees"
}

variable "lambda_trigger_departments_name" {
    type = string
    default = "trigger_glue_departments"
}

variable "glue_job_hired_employees_name" {
    type = string
    default = "convert_files_hired_employees"
}

variable "glue_job_departments_name" {
    type = string
    default = "convert_files_departments"
}

variable "glue_job_jobs_name" {
    type = string
    default = "convert_files_jobs"
}

variable "lambda_trigger_jobs_name" {
    type = string
    default = "trigger_glue_jobs"
}

variable "lambda_redshift_hired_employees_name" {
    type = string
    default = "redshift_hired_employees"
}

variable "lambda_redshift_departments_name" {
    type = string
    default = "redshift_departments"
}

variable "lambda_redshift_jobs_name" {
    type = string
    default = "redshift_jobs"
}

variable "lambda_create_users_table_name" {
    type = string
    default = "create_users_table"
}

variable "function_runtime" {
  type    = string
  default = "python3.9"
}

variable "function_arch" {
  type    = string
  default = "x86_64"
}

variable "redshift_user" {
  type        = string
  description = "User for Redshift"
  sensitive   = true
}

variable "redshift_pass" {
  type        = string
  description = "Password for Redshift"
  sensitive   = true
}

variable "redshift_dbname" {
  type    = string
  default = "dbemployees"
}

variable "redshift_cluster" {
  type    = string
  default = "project-cluster"
}

variable "hired_employees_table" {
  type    = string
  default = "hired_employees"
}

variable "departments_table" {
  type    = string
  default = "departments"
}

variable "jobs_table" {
  type    = string
  default = "jobs"
}

variable "flask_users_table" {
  type    = string
  default = "users_table"
}

variable "staging_table_hired_employees" {
  type    = string
  default = "staging_table_hired_employees"
}

variable "staging_table_departments" {
  type    = string
  default = "staging_table_departments"
}

variable "staging_table_jobs" {
  type    = string
  default = "staging_table_jobs"
}

variable "schema_name" {
  type    = string
  default = "employees"
}

variable "schema_name_flask" {
  type    = string
  default = "users"
}

variable "container_service_name" {
  type    = string
  default = "flask-api-application"
}

variable "container_flag" {
  type    = string
  default = "flask-app"
}

variable "docker_image_name" {
  type    = string
  default = "flask-api-employees"
}

variable "jwt_secret_key" {
  type = string
  description = "JWT secret key for your Flask App. Make sure to keep it secret."
  sensitive = true
}