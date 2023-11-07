variable "region" {
  type        = string
  description = "AWS Region"
}

variable "accountId" {
  type        = string
  description = "Account of the lambda function"
}

variable "name_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "iac"
}

variable "apigateway_input" {
  type        = map(string)
  description = "Map of input values for apigateway module"
  default     = {}
}

variable "lambda_invoke_arn" {
  type        = string
  description = "ARN of the lambda which will be invoked"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the lambda which will be invoked"
}
