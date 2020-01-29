resource "aws_iam_policy" "autotag_policy" {
  name = "autotag_policy"

  policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : [
        {
            "Sid" : "iamforautotag",
            "Effect" : "Allow",
            "Action" : "cloudtrail:LookupEvents",
            "Resource" : "*"
        },
        {
            "Sid" : "Stmt1458923121000",
            "Effect" : "Allow",
            "Action" : [
                "ec2:CreateTags",
                "ec2:Describe*",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource" : [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "autotag_lambda_role" {
  name = "autotag_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "autotag-IAM-policy-attachment" {
  name       = "autotag-IAM-policy-attachment"
  roles      = ["${aws_iam_role.autotag_lambda_role.name}"]
  policy_arn = aws_iam_policy.autotag_policy.arn
}

