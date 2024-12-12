output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = "${data.aws_region.current.name}, ${data.aws_region.current.description}"
}

output "lambda_iam_role" {
  value = module.lambda_iam_role.arn
}

output "lambda_function_setlink" {
  value = [
    "Function: ${module.lambda_function_setlink.arn}",
    "URL: ${module.lambda_function_setlink.url}",
    "Log group: ${module.lambda_function_setlink.log_group_name}"
  ]
}

output "lambda_function_getlink" {
  value = [
    "Function: ${module.lambda_function_getlink.arn}",
    "URL: ${module.lambda_function_getlink.url}",
    "Log group: ${module.lambda_function_getlink.log_group_name}"
  ]
}

output "lambda_function_deletelink" {
  value = [
    "Function: ${module.lambda_function_deletelink.arn}",
    "URL: ${module.lambda_function_deletelink.url}",
    "Log group: ${module.lambda_function_deletelink.log_group_name}"
  ]
}

output "dynamodb" {
  value = module.dynamodb.arn
}

output "s3" {
  value = module.s3.arn
}

output "cloudfront" {
  value = [
    "Domain: ${module.cloudfront.domain_name}",
    "ARN: ${module.cloudfront.arn}"
  ]
}

output "files" {
  value = distinct(flatten([
    module.lambda_function_setlink.files,
    module.lambda_function_getlink.files,
    module.lambda_function_deletelink.files
    ])
  )
}
