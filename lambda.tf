resource "aws_lambda_function" "autotag_lambda" {
  filename      = "./scripts/autotag.zip"
  function_name = "lambda_function_autotag"
  role          = "${aws_iam_role.autotag_lambda_role.arn}"
  handler       = "autotag.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("./scripts/autotag.zip")}"

  runtime = "python3.7"

  environment {
    variables = {
      Account = "non-prod"
    }
  }
}