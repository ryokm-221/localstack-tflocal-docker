variable "aws_s3_path_style" {
  default = "false"
}

variable "dynamodb_table_name" {
  default = "sample_table"
}

provider "aws" {
  s3_use_path_style = var.aws_s3_path_style
}

resource "aws_dynamodb_table" "db_sample" {
  name = var.dynamodb_table_name
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  hash_key = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}

resource "aws_iam_role" "func_sample_iam" {
  name = "func_sample_iam"
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

resource "aws_iam_role_policy" "func_sample_iam_policy" {
  name = "dynamodb_access_policy"
  role = aws_iam_role.func_sample_iam.id
  policy = jsonencode({
    Version =  "2012-10-17"
    Statement = [{
      Action = [
        "dynamodb:PutItem",
        "dynamodb:Query"
      ]
      Resource = "*"
      Effect = "Allow"
    }]
  })
}

resource "aws_lambda_function" "func_sample" {
  function_name = "func_sample"
  filename = "lambda_func.zip"
  handler = "index.handler"
  runtime = "nodejs14.x"
  role = aws_iam_role.func_sample_iam.arn
  source_code_hash = filebase64sha256("lambda_func.zip")
  environment {
    variables = {
      DynamoDBEndpoint = "http://localstack:4566"
      DynamoDBTableName = var.dynamodb_table_name
    }
  }
}