output "lambda_function_arn" {
  value = aws_lambda_function.pointcode-app.arn
}

output "lambda_function_invoke_arn" {
  value = aws_lambda_function.pointcode-app.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.pointcode-app.function_name
}