
resource "aws_iam_role" "lambda_exec" {
  name = "${var.name_prefix}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${var.name_prefix}-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action   = ["elasticache:*"],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })

  depends_on = [aws_iam_role.lambda_exec]
}
resource "aws_lambda_function" "pointcode-app" {
  function_name    = "pointcode-app"
  runtime          = "java17"
  handler          = "com.infy.templates.aws.app.AppHandler::handleRequest"
  role             = aws_iam_role.lambda_exec.arn
  filename         = var.lambda_payload_filename
  source_code_hash = filebase64sha256(var.lambda_payload_filename)
  timeout          = 60

  vpc_config {
    subnet_ids         = var.pub_subnet_ids
    security_group_ids = ["${var.sg_id}"]
  }

  environment {
    variables = {
      REDIS_ENDPOINT = var.redis_endpoint
      REDIS_HOST     = var.redis_url
      REDIS_PORT     = var.redis_port
    }
  }

  depends_on = [aws_iam_policy.lambda_policy]
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_exec.name
}
