# This resource is necessary for scheduling the pipeline
resource "aws_cloudwatch_event_rule" "eventbridge_pipeline_schedule" {
  name                = "schedule_pipeline"
  description         = "Schedule AWS Step Function containing Lambda functions"
  schedule_expression = "rate(60 minutes)"
  role_arn            = aws_iam_role.eventbridge_role.arn

}

resource "aws_cloudwatch_event_target" "step_functions_cloudwatch_target" {
  rule      = aws_cloudwatch_event_rule.eventbridge_pipeline_schedule.name
  target_id = "sendEventToStepFunctions"
  arn       = aws_sfn_state_machine.step_functions.arn
  role_arn  = aws_iam_role.eventbridge_role.arn

}