provider "aws" {
  region = var.project_aws_region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

resource "aws_lambda_function" "python_lambda_function" {
  filename      = "./lambda_function.zip"  # Replace with your Python Lambda function's ZIP file path
  function_name = "StoreEventData"
  role          = aws_iam_role.lambda_role.arn
  handler       = "store.lambda_handler"  # Replace with your Python handler function
  
  runtime = "python3.8"  # or any Python runtime version you prefer
  memory_size = 256     # Adjust as needed
  timeout     = 30      # Adjust as needed
  
  environment {
    variables = {
      KEY = "VALUE"
      # Add more variables as needed
    }
  }
}


resource "aws_cognito_user_pool" "user_pool" {
  name = "my-user-pool"
  # Define other necessary attributes for your user pool
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = "my-user-pool-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  # Define other necessary attributes for your user pool client
}

resource "aws_api_gateway_authorizer" "api_authorizer" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  provider_arns = [aws_cognito_user_pool.user_pool.arn]
}

resource "aws_api_gateway_rest_api" "my_api" {
  name = "MyAPI"
}

resource "aws_api_gateway_resource" "my_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myresource"
}

resource "aws_api_gateway_method" "my_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_api_resource.id
  http_method   = "POST"  # Define the HTTP method (POST, GET, etc.)
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.my_api_resource.id
  http_method = aws_api_gateway_method.my_api_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.python_lambda_function.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"  # Define your desired stage name
}
