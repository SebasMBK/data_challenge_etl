# data_challenge_etl

This project creates a pipeline that takes data from our sources in an AWS S3 bucket, processes it using lambda functions and, finally, stores it in a redshift database.
After our ETL pipeline is completed, we add a FLASK REST API to interact with the data. This Flask App allow us to retrieve data, create data and backup and restore tables that are living inside our database.

The tools that were used for the project are:
- [AWS](https://aws.amazon.com/) for hosting the infraestructure.
- [AWS S3](https://aws.amazon.com/es/s3/) as our storage.
- [AWS Lambda](https://aws.amazon.com/es/lambda/) as our transformations and data loading executor.
- [AWS Redshift](https://aws.amazon.com/redshift/) as our data warehouse.
- [AWS Glue](https://aws.amazon.com/es/glue/) as the tool that will transform our file formats.
- [AWS Step Functions](https://aws.amazon.com/step-functions/?nc1=h_ls) for orchestrating our pipeline.
- [AWS Eventbrigde](https://aws.amazon.com/eventbridge/) for scheduling our pipeline.
- [AWS Lightsail Containers](https://aws.amazon.com/es/lightsail/) for hosting our Flask REST API App.
- [Terraform](https://www.terraform.io/) as IaC for the infra provisioning.
- [Docker](https://www.docker.com/) for containerizing our Flask API package.
- [Insomnia](https://insomnia.rest/) for developing and testing our FLASK API.
- [Power BI](https://powerbi.microsoft.com/) for data visualization.
- [Python](https://www.python.org/) as the main programming language.

## Project's Architecture

## Client's requirements
Client's requested metrics:
1. Number of employees hired for each job and department in 2021 divided by quarter.

![Project Req 1](https://github.com/SebasMBK/data_challenge_etl/blob/main/images/req1.png)

2. List of ids, name and number of employees hired of each department that hired more employees than the mean of employees hired in 2021 for all the departments.

![Project Req 2](https://github.com/SebasMBK/data_challenge_etl/blob/main/images/req2.png)

## Project's requirements
These next requirements need to be installed locally for the correct functioning of the solution:
1. [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) for account configuring and terraform provisioning.
2. [AWS CLI Lighstail plugin](https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-install-software) for deploying our containers and pushing the docker images to the AWS Lightsail Containers' Repository.
3. [Terraform](https://www.terraform.io/) to provision the infraestructure.
4. [Docker](https://www.docker.com/) to containerize the Flask REST API App image.

## Start Pipeline
Terraform will initialize everything that we need for the creation of the pipeline. Just clone the repo and execute the next commands inside the terraform folder:
1.  `terraform init`: This will initiate terraform in the folder.
2.  `terraform apply`: This will create our infraestructure. You will be prompt with some required inputs.
3.  (Only run if you want to destroy the infraestructure) `terraform destroy`: This destroys the created infraestructure.

## Flask REST API
|Path|Request Type| Parameters|
|---|---|---|
|`/register`| POST| username(str), password(str). This method registers a user to the Flask API. This is necessary since all endpoints require authentication.|
|`/login`| POST| username(str), password(str). This method logs in a user to the Flask API. This returns an access token that has to be used as the authorization header.|
|`/logout`| POST| No parameters required. This method logs out a user from the Flask API. Use the access token in the authorization header for logging out.|
|`/hiredemployees`| POST| id(int), name(str), datetime_(timestamp-example: 2021-03-01T14:02:01Z), department_id(int), job_id(int). Inserts data to our table.|
|`/hiredemployees/backup`|GET| No parameters required. This request creates a backup for the selected table and returns a message indicating the name of the backup.|
|`/hiredemployees/restore/<str:backup_name>`|GET| No parameters required. This request restores a table from a specified backup name(obtained from the backup method).|
|`/departments`| POST| id(int), department(str). Inserts data to our table.|
|`/departments/backup`|GET| No parameters required. This request creates a backup for the selected table and returns a message indicating the name of the backup.|
|`/departments/restore/<str:backup_name>`|GET| No parameters required. This request restores a table from a specified backup name(obtained from the backup method).|
|`/jobs`| POST| id(int), job(str). Inserts data to our table.|
|`/jobs/backup`|GET| No parameters required. This request creates a backup for the selected table and returns a message indicating the name of the backup.|
|`/jobs/restore/<str:backup_name>`|GET| No parameters required. This request restores a table from a specified backup name(obtained from the backup method).|
|`/hired2021`|GET| No parameters required. This returns the client's requirement(1).|
|`/qtrlyhired`|GET| No parameters required. This returns the client's requirement(2).|

- All endpoints require an authorization header. The access token is provided when the login endpoint is used.
  1. Register.
  2. Login.
  3. Insert the access token in the authorization header.
- The path URL/swagger-ui will show the documentation of the Flask API.
