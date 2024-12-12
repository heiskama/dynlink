output "id" {
  value = aws_cloudfront_distribution.cloudfront.id
}

output "arn" {
  value = aws_cloudfront_distribution.cloudfront.arn
}

output "domain_name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}

output "origin_access_control_id_s3" {
  value = aws_cloudfront_origin_access_control.oac_s3.id
}

output "origin_access_control_id_lambda" {
  value = aws_cloudfront_origin_access_control.oac_lambda.id
}

output "bucket_policy" {
  value = data.template_file.bucket_policy.rendered
}
