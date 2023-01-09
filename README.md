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
