resource "aws_iam_role" "lambda-role" {
  name = "lambda-role-${var.sandbox_id}"

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

resource "aws_iam_policy" "lambda-logging" {
  name        = "lambda-logging-${var.sandbox_id}"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Bind the Lambda role to the policy that defines CloudWatch rights.
resource "aws_iam_role_policy_attachment" "lambda-logs" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.lambda-logging.arn
}
