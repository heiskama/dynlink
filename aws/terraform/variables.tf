variable "allowed_account_ids" {
  type        = list(string)
  default     = [""]
  description = "List of allowed AWS account IDs to prevent you from mistakenly using an incorrect one (and potentially end up destroying a live environment). Get it with `aws sts get-caller-identity`. Leaving this as an empty string disables the check."
}

variable "shared_credentials_files" {
  type        = list(string)
  default     = ["~/.aws/credentials"]
  description = "AWS credentials file that has the access key and secret access key."
}

variable "profile" {
  type        = string
  default     = "my-profile"
  description = "Profile name of AWS credentials."
}

variable "region" {
  type        = string
  default     = "eu-west-1" # eu-west-1 = Europe (Ireland)
  description = "Region. See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions"
}

variable "project_name" {
  type        = string
  default     = "dynlink"
  description = "Project name. Used as a naming prefix."
}

variable "environment" {
  type        = string
  default     = "prod"
  description = "Environment. Used as a naming suffix."
}

variable "table_name" {
  type        = string
  default     = "links"
  description = "DynamoDB table name."
}

variable "bucket_name" {
  type        = string
  default     = "static"
  description = "S3 Bucket name."
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "ARN of the ACM Certificate."
}

variable "tags" {
  type = map(string)
  default = {
    "organization:project"     = "dynlink"
    "organization:environment" = "prod"
  }
  description = "Tags shared by all resources. Limits and requirements: https://docs.aws.amazon.com/tag-editor/latest/userguide/best-practices-and-strats.html#id_tags_naming_best_practices"
}

variable "cloudfront_aliases" {
  type        = list(string)
  default     = ["dyn.link"]
  description = "List of domain aliases for this distribution. This should match with the ACM certificate."
}

variable "variables" {
  type = map(string)
  default = {
    PROVIDER            = "AWS"
    ENVIRONMENT         = "PROD"
    LOG_LEVEL           = "LOG" // Level of verbosity: ERROR < WARN < INFO < LOG < DEBUG < TRACE
    DYNAMODB_TABLE      = "dynlink-links-prod"
    EXPIRE_LINK_IN_DAYS = "30"
    BASE_URL            = "https://dyn.link/"
  }
  description = "Environment variables for the Lambda functions."
}

variable "secret_variables" {
  type = map(string)
  // Define in secrets.auto.tfvars
  //default     = {
  //  PRIVATE_API_KEY = "..."
  //}
  sensitive   = true
  description = "Sensitive environment variables for the Lambda functions."
}

variable "log_retention_in_days" {
  type        = number
  default     = 30
  description = "Log retention in days for Lambda functions. 0 means never expire."
}

variable "source_dir" {
  type        = string
  default     = "../../src"
  description = "Path to the directory that contains source code (relative to modules)."
}

variable "dist_dir" {
  type        = string
  default     = "../../dist"
  description = "Path to the directory where deployment files are placed (relative to modules)."
}
