// Policy to allow Lambda to assume the IAM role
data "template_file" "lambda_trust_policy" {
  template = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          }
        }
      ]
    }
  )
}

// IAM role for Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name               = var.name
  assume_role_policy = data.template_file.lambda_trust_policy.rendered
  description        = var.description
  #managed_policy_arns = [""]  # Deprecated. Use aws_iam_role_policy_attachments_exclusive instead.
}

// DynamoDB access permissions template
// Provides Get/Put/Delete/Update permissions to a DynamoDB table.
data "template_file" "custom_dynamodb_access_policy" {
  # https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/iam-policy-example-data-crud.html
  template = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "DynamoDBTableAccess",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:UpdateItem"
          ],
          "Resource" : var.dynamodb_table_arn
        }
      ]
    }
  )
}

// DynamoDB access policy
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "${var.name}-dynamodb"
  description = "Provides Get/Put/Delete/Update permissions to a DynamoDB table."
  policy      = data.template_file.custom_dynamodb_access_policy.rendered
}

// Attach policies to the IAM role
resource "aws_iam_role_policy_attachments_exclusive" "lambda_cloudwatch_permissions" {
  role_name = aws_iam_role.iam_for_lambda.name
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", # Provides write permissions to CloudWatch Logs. AWS Managed.
    aws_iam_policy.dynamodb_policy.arn
  ]
}
