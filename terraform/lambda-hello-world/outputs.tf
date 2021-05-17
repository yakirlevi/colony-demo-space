output "lambda_output" {
  value = data.aws_lambda_invocation.start_hello_world.result
}
