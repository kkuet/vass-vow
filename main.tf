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

resource "aws_lambda_function" "store_lambda_function" {
  filename      = "./lambda_function.zip"  # Replace with your Python Lambda function's ZIP file path
  function_name = "StoreEventData"
  role          = aws_iam_role.lambda_role.arn
  handler       = "store.lambda_handler"  # Replace with your Python handler function
  
  runtime = "python3.10"  # or any Python runtime version you prefer
  memory_size = 256     # Adjust as needed
  timeout     = 30      # Adjust as needed
  
  environment {
    variables = {
      KEY = "VALUE"
      # Add more variables as needed
    }
  }
}

resource "aws_lambda_function" "get_files_function" {
  filename      = "./lambda_files.zip"  # Replace with your Python Lambda function's ZIP file path
  function_name = "FilesLambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_files.lambda_handler"  # Replace with your Python handler function
  
  runtime = "python3.10"  # or any Python runtime version you prefer
  memory_size = 256     # Adjust as needed
  timeout     = 30      # Adjust as needed
  
  environment {
    variables = {
      KEY = "VALUE"
      # Add more variables as needed
    }
  }
}

resource "aws_lambda_function" "get_file_by_id_function" {
  filename      = "./lambda_files.zip"  # Replace with your Python Lambda function's ZIP file path
  function_name = "FilesByIdLambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_files.lambda_handler_by_id"  # Replace with your Python handler function
  
  runtime = "python3.10"  # or any Python runtime version you prefer
  memory_size = 256     # Adjust as needed
  timeout     = 30      # Adjust as needed
  
  environment {
    variables = {
      KEY = "VALUE"
      # Add more variables as needed
    }
  }
}

resource "aws_lambda_function" "get_tests_by_id_function" {
  filename      = "./lambda_files.zip"  # Replace with your Python Lambda function's ZIP file path
  function_name = "TestLambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_files.lambda_handler_tests_by_id"  # Replace with your Python handler function
  
  runtime = "python3.10"  # or any Python runtime version you prefer
  memory_size = 256     # Adjust as needed
  timeout     = 30      # Adjust as needed
  
  environment {
    variables = {
      KEY = "VALUE"
      # Add more variables as needed
    }
  }
}

resource "aws_lambda_function" "get_testequipments_by_id_function" {
  filename      = "./lambda_files.zip"  # Replace with your Python Lambda function's ZIP file path
  function_name = "TestEquipmentLambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_files.lambda_testequipments_by_id"  # Replace with your Python handler function
  
  runtime = "python3.10"  # or any Python runtime version you prefer
  memory_size = 256     # Adjust as needed
  timeout     = 30      # Adjust as needed
  
  environment {
    variables = {
      KEY = "VALUE"
      # Add more variables as needed
    }
  }
}


resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  parent_id   = aws_api_gateway_rest_api.vw_api.root_resource_id
  path_part = "allfiles"
}

resource "aws_api_gateway_method" "root_get" {
  rest_api_id   = aws_api_gateway_rest_api.vw_api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.root_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_files_function.invoke_arn
}

resource "aws_lambda_permission" "allow_api_gateway_root" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_files_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vw_api.execution_arn}/*/*"
}

resource "aws_api_gateway_resource" "files_resource" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  parent_id   = aws_api_gateway_rest_api.vw_api.root_resource_id
  path_part   = "files"  # El path para /files
}

resource "aws_api_gateway_resource" "file_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  parent_id   = aws_api_gateway_resource.files_resource.id
  path_part   = "{file_id}"  # El path parameter file_id
}

resource "aws_api_gateway_method" "file_id_get" {
  rest_api_id   = aws_api_gateway_rest_api.vw_api.id
  resource_id   = aws_api_gateway_resource.file_id_resource.id
  http_method   = "GET"
  authorization = "NONE"  # O el tipo de autorización que necesites
}


resource "aws_api_gateway_integration" "lambda_file_id" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  resource_id = aws_api_gateway_resource.file_id_resource.id
  http_method = aws_api_gateway_method.file_id_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_file_by_id_function.invoke_arn
}

resource "aws_api_gateway_resource" "file_id_tests_resource" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  parent_id   = aws_api_gateway_resource.file_id_resource.id
  path_part   = "tests"  # El path para /tests
}

resource "aws_api_gateway_method" "file_id_tests_get" {
  rest_api_id   = aws_api_gateway_rest_api.vw_api.id
  resource_id   = aws_api_gateway_resource.file_id_tests_resource.id
  http_method   = "GET"
  authorization = "NONE"  # O el tipo de autorización que necesites
}

resource "aws_api_gateway_integration" "lambda_file_id_tests" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  resource_id = aws_api_gateway_resource.file_id_tests_resource.id
  http_method = aws_api_gateway_method.file_id_tests_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_tests_by_id_function.invoke_arn
}


resource "aws_api_gateway_resource" "file_id_testsequipments_resource" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  parent_id   = aws_api_gateway_resource.file_id_resource.id
  path_part   = "testsequipments"  # El path para /tests
}

resource "aws_api_gateway_method" "file_id_testsequipments_get" {
  rest_api_id   = aws_api_gateway_rest_api.vw_api.id
  resource_id   = aws_api_gateway_resource.file_id_testsequipments_resource.id
  http_method   = "GET"
  authorization = "NONE"  # O el tipo de autorización que necesites
}

resource "aws_api_gateway_integration" "lambda_file_id_testsequipments" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  resource_id = aws_api_gateway_resource.file_id_testsequipments_resource.id
  http_method = aws_api_gateway_method.file_id_testsequipments_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_testequipments_by_id_function.invoke_arn
}



resource "aws_api_gateway_resource" "upload_resource" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  parent_id   = aws_api_gateway_rest_api.vw_api.root_resource_id
  path_part   = "upload"  # El path para /upload
}

resource "aws_api_gateway_method" "upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.vw_api.id
  resource_id   = aws_api_gateway_resource.upload_resource.id
  http_method   = "POST"
  authorization = "NONE"  # O el tipo de autorización que necesites
}

resource "aws_api_gateway_integration" "lambda_upload" {
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  resource_id = aws_api_gateway_resource.upload_resource.id
  http_method = aws_api_gateway_method.upload_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.store_lambda_function.invoke_arn
}




resource "aws_lambda_permission" "allow_api_gateway_file_id" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_file_by_id_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vw_api.execution_arn}/*/GET/files/{file_id}"
}


resource "aws_lambda_permission" "allow_api_gateway_file_id_tests" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_tests_by_id_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vw_api.execution_arn}/*/GET/files/{file_id}/tests"
}

resource "aws_lambda_permission" "allow_api_gateway_file_id_testsequipments" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_testequipments_by_id_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vw_api.execution_arn}/*/GET/files/{file_id}/testsequipments"
}


resource "aws_lambda_permission" "allow_api_gateway_upload" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.store_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.vw_api.execution_arn}/*/POST/upload"
}

resource "aws_api_gateway_deployment" "vw_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_file_id,
    aws_api_gateway_integration.lambda_file_id_tests,
    aws_api_gateway_integration.lambda_file_id_testsequipments,
    aws_api_gateway_integration.lambda_upload
  ]
  rest_api_id = aws_api_gateway_rest_api.vw_api.id
  stage_name  = "prod"
}

resource "aws_api_gateway_api_key" "MyApiKey" {
  name = "my-api-key"
}

resource "aws_api_gateway_usage_plan" "MyUsagePlan" {
  name        = "MyUsagePlan"
  api_stages {
    api_id = aws_api_gateway_rest_api.vw_api.id
    stage  = "prod"
  }
}

resource "aws_api_gateway_usage_plan_key" "MyUsagePlanKey" {
  key_id        = aws_api_gateway_api_key.MyApiKey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.MyUsagePlan.id
}


resource "aws_api_gateway_rest_api" "vw_api" {
  name = "MyAPI"
  description = "API for file management"
}


data "aws_vpc" "default" {
  default = true
}

resource "aws_db_parameter_group" "example_parameter_group" {
  name        = "postgres15-4-parameters"
  family      = "postgres15"
  description = "Parameter group for PostgreSQL 15.4"

  # Add other parameters as needed for your configuration
}

resource "aws_db_instance" "events_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.r5.large"
  username             = "usuario"
  password             = "password"  # Replace with your desired password
  publicly_accessible  = true

  # Change the following parameter group and subnet group IDs as per your configuration
  parameter_group_name = aws_db_parameter_group.example_parameter_group.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]  # Replace with your security group ID

  tags = {
    Name = "example-db"
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "db-security-group"
  description = "Example security group for RDS"

  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 5431
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust this to restrict access to specific IPs if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
