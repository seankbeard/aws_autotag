resource "aws_cloudwatch_event_rule" "autotag_event" {
  name        = "autotag_event"
  description = "AutoTag new Resources"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "RunInstances",
      "CreateImage",
      "CreateSnapshot",
      "CreateVolume"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda_function" {
  rule      = "${aws_cloudwatch_event_rule.autotag_event.name}"
  target_id = "TriggerFunction"
  arn       = "${aws_lambda_function.autotag_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_trigger" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.autotag_lambda.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.autotag_event.arn}"
}