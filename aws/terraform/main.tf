// Terraform configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

// Provider configuration
provider "aws" {
  allowed_account_ids      = var.allowed_account_ids
  shared_credentials_files = var.shared_credentials_files
  profile                  = var.profile
  region                   = var.region

  default_tags {
    tags = var.tags
  }
}

// Get AWS Account ID and Region information
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

// Create a DynamoDB table
module "dynamodb" {
  source = "./modules/dynamodb"
  name   = "${var.project_name}-${var.table_name}-${var.environment}"
}

// Create an S3 bucket
module "s3" {
  source     = "./modules/s3"
  name       = "${var.project_name}-${var.bucket_name}-${var.environment}"
  index_file = "${var.source_dir}/website/index.html"
}

// Create a new IAM role for Lambda
#module "lambda_iam_role" {
#  source             = "./modules/lambda_iam_role"
#  name               = "my_new_lambda_iam_role"
#  dynamodb_table_arn = module.dynamodb.arn
#}

// Import existing IAM role for Lambda
module "lambda_iam_role" {
  source = "./modules/imports/lambda_iam_role"
  name   = "${var.project_name}_lambda_${var.environment}"
}

// Shared Javascript files of Lambda functions
locals {
  shared_js_files = [
    "${var.source_dir}/functions/logger.cjs",
    "${var.source_dir}/functions/helpers.mjs",
    "${var.source_dir}/functions/dynamodb.mjs"
  ]
}

// Create a Lambda function with an invocation URL
module "lambda_function_setlink" {
  source                = "./modules/lambda_function"
  function_name         = "${var.project_name}-setlink-${var.environment}"
  source_files          = concat(["${var.source_dir}/functions/setlink.mjs"], local.shared_js_files)
  dist_dir              = var.dist_dir
  handler               = "setlink.handler"
  role                  = module.lambda_iam_role.arn
  variables             = var.variables
  log_retention_in_days = var.log_retention_in_days
}

// Create a Lambda function with an invocation URL
module "lambda_function_getlink" {
  source                = "./modules/lambda_function"
  function_name         = "${var.project_name}-getlink-${var.environment}"
  source_files          = concat(["${var.source_dir}/functions/getlink.mjs"], local.shared_js_files)
  dist_dir              = var.dist_dir
  handler               = "getlink.handler"
  role                  = module.lambda_iam_role.arn
  variables             = var.variables
  log_retention_in_days = var.log_retention_in_days
}

// Create a Lambda function with an invocation URL
module "lambda_function_deletelink" {
  source                = "./modules/lambda_function"
  function_name         = "${var.project_name}-deletelink-${var.environment}"
  source_files          = concat(["${var.source_dir}/functions/deletelink.mjs"], local.shared_js_files)
  dist_dir              = var.dist_dir
  handler               = "deletelink.handler"
  role                  = module.lambda_iam_role.arn
  variables             = merge(var.secret_variables, var.variables)
  log_retention_in_days = var.log_retention_in_days
}

// Create a CloudFront Distribution
module "cloudfront" {
  source              = "./modules/cloudfront"
  project_name        = var.project_name
  environment         = var.environment
  bucket_name         = module.s3.name
  s3_domain_name      = module.s3.bucket_regional_domain_name
  s3_origin_id        = module.s3.name
  acm_certificate_arn = var.acm_certificate_arn
  aliases             = var.cloudfront_aliases
  api = {
    setlink = {
      lambda_domain_name = module.lambda_function_setlink.domain,
      lambda_origin_id   = "setlink",
      path_pattern       = "/api/setlink"
    },
    deletelink = {
      lambda_domain_name = module.lambda_function_deletelink.domain,
      lambda_origin_id   = "deletelink",
      path_pattern       = "/api/deletelink"
    },
    # 'getlink' has a catch-all path_pattern for strings of length >= 1.
    getlink = {
      lambda_domain_name = module.lambda_function_getlink.domain,
      lambda_origin_id   = "getlink",
      path_pattern       = "/?*"
    }
  }
  tags = {
    "Name" = "${var.project_name}-cloudfront-${var.environment}"
  }
}

// Allow CloudFront to access the S3 Bucket
resource "aws_s3_bucket_policy" "allow_cloudwatch" {
  bucket = module.s3.name
  policy = module.cloudfront.bucket_policy
}

// Allow CloudFront to access the Lambda functions
//
// Useful documents:
// https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html#concept_lambda_function_url
// https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-lambda.html
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
resource "aws_lambda_permission" "allow_cloudfront" {
  for_each = tomap({
    setlink    = module.lambda_function_setlink.arn,
    getlink    = module.lambda_function_getlink.arn,
    deletelink = module.lambda_function_deletelink.arn,
  })

  statement_id  = "AllowCloudFrontServicePrincipal"
  action        = "lambda:InvokeFunctionUrl"
  principal     = "cloudfront.amazonaws.com"
  source_arn    = module.cloudfront.arn
  function_name = each.value
}
