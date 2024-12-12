variable "name" {
  type        = string
  default     = "iam_for_lambda"
  description = "Policy name."
}

variable "description" {
  type        = string
  default     = "Allows Lambda functions to call AWS services on your behalf."
  description = "Policy description."
}

variable "dynamodb_table_arn" {
  type        = string
  description = "DynamoDB table ARN."
}
