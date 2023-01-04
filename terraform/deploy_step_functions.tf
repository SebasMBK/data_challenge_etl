resource "aws_sfn_state_machine" "step_functions" {
  name     = "project_state_machine"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
  "Comment": "Project State Machine",
  "StartAt": "Parallel pipelines",
  "States": {
    "Parallel pipelines": {
      "Type": "Parallel",
      "Branches": [
        {
          "StartAt": "Validator Hired Employees",
          "States": {
            "Validator Hired Employees": {
              "Type": "Task",
              "Resource": "${aws_lambda_function.hired_employees_lambda_validator.arn}",
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 2,
                  "BackoffRate": 2
                }
              ],
              "End": true
            }
          }
        },
        {
          "StartAt": "Validator Departments",
          "States": {
            "Validator Departments": {
              "Type": "Task",
              "Resource": "${aws_lambda_function.departments_lambda_validator.arn}",
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 2,
                  "BackoffRate": 2
                }
              ],
              "Next": "Redshift departments"
            },
            "Redshift departments": {
              "Type": "Task",
              "Resource": "${aws_lambda_function.departments_lambda_redshift.arn}",
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 2,
                  "BackoffRate": 2
                }
              ],
              "End": true
            }
          }
        },
        {
          "StartAt": "Validator Jobs",
          "States": {
            "Validator Jobs": {
              "Type": "Task",
              "Resource": "${aws_lambda_function.jobs_lambda_validator.arn}",
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 2,
                  "BackoffRate": 2
                }
              ],
              "Next": "Redshift jobs"
            },
            "Redshift jobs": {
              "Type": "Task",
              "Resource": "${aws_lambda_function.jobs_lambda_redshift.arn}",
              "Retry": [
                {
                  "ErrorEquals": [
                    "Lambda.ServiceException",
                    "Lambda.AWSLambdaException",
                    "Lambda.SdkClientException",
                    "Lambda.TooManyRequestsException"
                  ],
                  "IntervalSeconds": 2,
                  "MaxAttempts": 2,
                  "BackoffRate": 2
                }
              ],
              "End": true
            }
          }
        }
      ],
      "Next": "Redshift hired employees"
    },
    "Redshift hired employees": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.hired_employees_lambda_redshift.arn}",
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 2,
          "BackoffRate": 2
        }
      ],
      "End": true
    }
  }
}
EOF

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.stepfunctions_logs.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

}

# Logging
resource "aws_cloudwatch_log_group" "stepfunctions_logs" {
  name              = "/aws/states/state_machine_execution"
  retention_in_days = 30
}