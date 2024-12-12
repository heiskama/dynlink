// Create a deployment package
data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${var.dist_dir}/${var.function_name}.zip"
  source_dir  = dirname(var.source_files[0])
  excludes    = setsubtract(fileset(dirname(var.source_files[0]), "*"), [for file in var.source_files : basename(file)])
}

// Lambda function
resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  filename         = data.archive_file.lambda.output_path
  handler          = var.handler
  runtime          = var.runtime
  role             = var.role
  source_code_hash = data.archive_file.lambda.output_base64sha256
  environment {
    #variables = merge(var.secret_variables, var.variables)
    variables = var.variables
  }
}

// Function URL
resource "aws_lambda_function_url" "endpoint" {
  function_name      = aws_lambda_function.lambda_function.function_name
  authorization_type = var.authorization_type
  #qualifier          = "$LATEST"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    #max_age           = 0  # default
    #max_age           = 86400  # max
  }
}

// Function log group
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days
  skip_destroy      = var.keep_logs_on_destroy
}
