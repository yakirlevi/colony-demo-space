data "archive_file" "lambda_function_start-stop-ec2" {
  type        = "zip"
  source_dir  = "${path.module}/hello_world"
  output_path = "${path.module}/hello_world.zip"
}

data "aws_lambda_invocation" "start_hello_world" {
  function_name = aws_lambda_function.hello_world.function_name

  input = <<JSON
  {
    "Example": "data"
  }
  JSON
}

resource "aws_lambda_function" "hello_world" {
  function_name = "hello_world_${var.sandbox_id}"
  description   = "Hello world example"
  role          = var.lambda_role_arn
  handler       = "hello_world.handler"
  runtime       = "nodejs12.x"
  timeout       = "120"
  depends_on    = [aws_cloudwatch_log_group.hello_world_log_group]
  filename      = "${path.module}/hello_world.zip"
}

resource "aws_cloudwatch_log_group" "hello_world_log_group" {
  name              = "/aws/lambda/hello_world_${var.sandbox_id}"
  retention_in_days = 3
}