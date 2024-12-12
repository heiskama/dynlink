output "name" {
  value       = var.function_name
  description = "The name of the function."
}

output "arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "The Amazon Resource Name (ARN) of the function."
}

output "url" {
  value       = aws_lambda_function_url.endpoint.function_url
  description = "The HTTP URL endpoint for the function in the format 'https://<url_id>.lambda-url.<region>.on.aws/'."
}

output "domain" {
  value       = trimsuffix(trimprefix(aws_lambda_function_url.endpoint.function_url, "https://"), "/")
  description = "The domain name of the function in the format '<url_id>.lambda-url.<region>.on.aws'."
}

output "url_id" {
  value       = aws_lambda_function_url.endpoint.url_id
  description = "A generated ID for the endpoint."
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.lambda.name
  description = "The name of the function log group."
}

output "files" {
  value       = setintersection(fileset(dirname(var.source_files[0]), "*"), [for file in var.source_files : basename(file)])
  description = "The set of files to be included in the deployment package."
}
