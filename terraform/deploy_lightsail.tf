# This serves as a placeholder to execute the command that will create our docker image locally
resource "null_resource" "create-docker-image" {
  provisioner "local-exec" {

    command = "docker build -t ${var.docker_image_name} ."
    working_dir = "../api_service/"
  
  }
}

# This will host our Flask App
resource "awslightsail_container_service" "lightsail_container" {
  name        = var.container_service_name
  power       = "micro"
  scale       = 1
  is_disabled = false

  depends_on = [
    null_resource.create-docker-image
  ]
}

# This serves as a placeholder to executed the command that will push our locally created docker image
resource "null_resource" "push-image-to-lightsail" {
  provisioner "local-exec" {

    command = "aws lightsail push-container-image --service-name ${var.container_service_name} --label ${var.container_flag} --region ${var.project_region} --image ${var.docker_image_name}"
    working_dir = "../api_service/"
  }

  depends_on = [
    awslightsail_container_service.lightsail_container
  ]
}


# This will deploy the container
resource "awslightsail_container_deployment" "flask_api_container" {
  container_service_name = awslightsail_container_service.lightsail_container.id
  container {
    container_name = var.container_service_name
    image          = ":${var.container_service_name}.${var.container_flag}.latest"

    port {
      port_number = 80
      protocol    = "HTTP"
    }

    environment {
      key = "DATABASE_URL"
      value = "postgresql://${var.redshift_user}:${var.redshift_pass}@${aws_redshift_cluster.project_cluster.endpoint}/${var.redshift_dbname}"
    }

    environment {
      key = "TABLE_SCHEMA"
      value = "${var.schema_name}"
    }

    environment {
      key = "DEPARTMENTS_TABLE_NAME"
      value = "${var.departments_table}"
    }
    
    environment {
      key = "HIRED_EMPLOYEES_TABLE_NAME"
      value = "${var.hired_employees_table}"
    }

    environment {
      key = "JOBS_TABLE_NAME"
      value = "${var.jobs_table}"
    }

    environment {
      key = "USERS_TABLE_NAME"
      value = "${var.flask_users_table}"
    }

    environment {
      key = "FLASK_TABLE_SCHEMA"
      value = "${var.schema_name_flask}"
    }

    environment {
      key = "IAM_ROLE"
      value = "${aws_iam_role.project_redshift_role.arn}"
    }

    environment {
      key = "DEPARTMENTS_BACKUP_BUCKET"
      value = "${var.departments_backup_bucket_name}"
    }

    environment {
      key = "HIRED_EMPLOYEES_BACKUP_BUCKET"
      value = "${var.hired_employees_backup_bucket_name}"
    }
    
    environment {
      key = "JOBS_BACKUP_BUCKET"
      value = "${var.jobs_backup_bucket_name}"
    }

    environment {
      key = "TEMP_BACKUP_FOLDER"
      value = "${var.temp_folder_backup_name}"
    }

    environment {
      key = "BACKUP_FOLDER"
      value = "${var.backup_folder_name}"
    }

    environment {
      key = "JWT_SECRET_KEY"
      value = "${var.jwt_secret_key}"
    }
  }

  public_endpoint {
    container_name = var.container_service_name
    container_port = 80

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout_seconds     = 2
      interval_seconds    = 5
      path                = "/"
      success_codes       = "200-499"
    }
  }

  depends_on = [
    null_resource.push-image-to-lightsail
  ]

}