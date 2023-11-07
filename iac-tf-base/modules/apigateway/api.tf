resource "aws_api_gateway_rest_api" "restApi" {
  name        = var.apigateway_input["name"]
  description = var.apigateway_input["description"]

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "restApiResource" {
  rest_api_id = aws_api_gateway_rest_api.restApi.id
  parent_id   = aws_api_gateway_rest_api.restApi.root_resource_id
  path_part   = var.apigateway_input["path_part"]
  //path_part   = "{proxy+}"
}

resource "aws_api_gateway_model" "restApiReqModel" {
  rest_api_id  = aws_api_gateway_rest_api.restApi.id
  name         = "reqModel1"
  content_type = "application/json"

  schema = jsonencode({
    type = "object",
    "properties" : {
      "code_type" : {
        "type" : "string"
      },
      "code_value" : {
        "type" : "string"
      },
      "shipcomp_code" : {
        "type" : "string"
      }
    },
    "required" : ["code_type", "code_value", "shipcomp_code"],
    "additionalProperties" : false
  })
}

resource "aws_api_gateway_model" "restApiRespModel" {
  rest_api_id  = aws_api_gateway_rest_api.restApi.id
  name         = "respModel1"
  content_type = "application/json"

  schema = jsonencode({
    type = "object",
    "properties" : {
      "code_amount" : {
        "type" : "string"
      },
      "code_interval" : {
        "type" : "string"
      },
      "code_length" : {
        "type" : "string"
      },
      "code_rate" : {
        "type" : "string"
      },
      "code_type" : {
        "type" : "string"
      },
      "code_value" : {
        "type" : "string"
      },
      "code_xref" : {
        "type" : "string"
      },
      "description" : {
        "type" : "string"
      },
      "time_stamp" : {
        "type" : "string"
      },
      "code_flag" : {
        "type" : "string"
      },
      "date_stamp" : {
        "type" : "string"
      },
      "delete_flag" : {
        "type" : "string"
      },
      "user_id" : {
        "type" : "string"
      },
      "shipcomp_code" : {
        "type" : "string"
      }
    },
    "additionalProperties" : false
  })
}

resource "aws_api_gateway_method" "restApiMethod" {
  rest_api_id   = aws_api_gateway_rest_api.restApi.id
  resource_id   = aws_api_gateway_resource.restApiResource.id
  http_method   = var.apigateway_input["http_method"]
  authorization = "NONE"

  request_models = {
    "application/json" = aws_api_gateway_model.restApiReqModel.name
  }
}

resource "aws_api_gateway_method_response" "restApiMethodResp_200" {
  rest_api_id = aws_api_gateway_rest_api.restApi.id
  resource_id = aws_api_gateway_resource.restApiResource.id
  http_method = var.apigateway_input["http_method"]
  status_code = "200"

  response_models = {
    "application/json": aws_api_gateway_model.restApiRespModel.name
  }
}

resource "aws_api_gateway_integration" "restApiIntegration" {
  rest_api_id = aws_api_gateway_rest_api.restApi.id
  resource_id = aws_api_gateway_resource.restApiResource.id
  http_method = aws_api_gateway_method.restApiMethod.http_method

  integration_http_method = var.apigateway_input["integration_http_method"]
  type                    = var.apigateway_input["type"]
  //uri                     = var.lambda_arn
  uri = var.lambda_invoke_arn

  request_templates = {
    "application/xml" = <<EOF
    {
      "body": $input.json('$')
    }
    EOF
  }
}

resource "aws_api_gateway_integration_response" "restApiIntegrationResp" {
  rest_api_id = aws_api_gateway_rest_api.restApi.id
  resource_id = aws_api_gateway_resource.restApiResource.id
  http_method = aws_api_gateway_method.restApiMethod.http_method

  status_code = aws_api_gateway_method_response.restApiMethodResp_200.status_code
}

resource "aws_lambda_permission" "lambdaPermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.restApi.id}/*/${aws_api_gateway_method.restApiMethod.http_method}${aws_api_gateway_resource.restApiResource.path}"
}

resource "aws_api_gateway_deployment" "pointcode" {
  depends_on  = [aws_api_gateway_integration.restApiIntegration]
  rest_api_id = aws_api_gateway_rest_api.restApi.id
  stage_name  = var.apigateway_input["stage_name"]
}
