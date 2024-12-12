variable "function_name" {
  type        = string
  description = "Name of the Lambda function."
}

variable "source_files" {
  type        = list(string)
  description = "If the files are not in the current working directory you will need to include a path.module in the filename."

  validation {
    condition = alltrue([
      for file in var.source_files :
      dirname(file) == dirname(element(var.source_files, 0))
    ])
    error_message = "Source files should all be in the same directory"
  }
}

variable "dist_dir" {
  type        = string
  description = "Directory where to place the deployment package."
}

variable "handler" {
  type        = string
  description = "Function and handler method."
}

variable "runtime" {
  type        = string
  default     = "nodejs20.x"
  description = "Runtime of the Lambda function. See https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html for depreciation dates."
}

variable "role" {
  type        = string
  description = "IAM role ARN for the Lambda function."
}

variable "variables" {
  type        = map(string)
  default     = {}
  description = "Environment variables for the Lambda function."
}

variable "secret_variables" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Sensitive environment variables for the Lambda function."
}

variable "authorization_type" {
  type        = string
  default     = "AWS_IAM"
  description = "Authorization type: AWS_IAM or NONE"
}
variable "log_retention_in_days" {
  type        = number
  default     = 30
  description = "Log retention in days. 0 means never expire."
}

variable "keep_logs_on_destroy" {
  type        = bool
  default     = false
  description = "Set whether logs are kept or deleted when the resource is deleted from Terraform."
}
