module "apigateway" {
  source = "./modules/apigateway"

  name_prefix          = local.name_prefix
  lambda_invoke_arn    = module.lambdafunction.lambda_function_invoke_arn
  apigateway_input     = local.apigateway_input
  lambda_function_name = module.lambdafunction.lambda_function_name
  region               = local.aws_region
  accountId            = local.accountId
}