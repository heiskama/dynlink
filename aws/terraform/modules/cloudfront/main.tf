// CloudFront Origin Access Control for S3
resource "aws_cloudfront_origin_access_control" "oac_s3" {
  name                              = "${var.project_name}-s3-${var.environment}"
  description                       = "Origin Access Control to access ${var.s3_origin_id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

// CloudFront Origin Access Control for Lambda
resource "aws_cloudfront_origin_access_control" "oac_lambda" {
  name                              = "${var.project_name}-lambda-${var.environment}"
  description                       = "Origin Access Control to access Lambda Functions in ${var.project_name}-${var.environment}"
  origin_access_control_origin_type = "lambda"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

// CloudFront Distribution
resource "aws_cloudfront_distribution" "cloudfront" {
  # S3 origin
  origin {
    domain_name              = var.s3_domain_name
    origin_id                = var.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_s3.id
  }

  # Lambda URL origin: setlink
  origin {
    domain_name              = var.api.setlink.lambda_domain_name
    origin_id                = var.api.setlink.lambda_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_lambda.id

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Lambda URL origin: deletelink
  origin {
    domain_name              = var.api.deletelink.lambda_domain_name
    origin_id                = var.api.deletelink.lambda_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_lambda.id

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Lambda URL origin: getlink
  origin {
    domain_name              = var.api.getlink.lambda_domain_name
    origin_id                = var.api.getlink.lambda_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_lambda.id

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Index cache behavior
  ordered_cache_behavior {
    # Using the AWS Managed Caching Policy: CachingDisabled.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-policy-caching-disabled
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    path_pattern           = "/index.html"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.s3_origin_id
    viewer_protocol_policy = "redirect-to-https" # Force HTTPS
  }

  # API cache behavior: setlink
  ordered_cache_behavior {
    # Using the AWS Managed Caching Policy: CachingDisabled.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-policy-caching-disabled
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    path_pattern           = var.api.setlink.path_pattern
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.api.setlink.lambda_origin_id
    viewer_protocol_policy = "redirect-to-https" # Force HTTPS
    # Using the AWS Managed Origin Request Policy: AllViewerExceptHostHeader.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html#managed-origin-request-policy-all-viewer-except-host-header
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }

  # API cache behavior: deletelink
  ordered_cache_behavior {
    # Using the AWS Managed Caching Policy: CachingDisabled.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-policy-caching-disabled
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    path_pattern           = var.api.deletelink.path_pattern
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.api.deletelink.lambda_origin_id
    viewer_protocol_policy = "redirect-to-https" # Force HTTPS
    # Using the AWS Managed Origin Request Policy: AllViewerExceptHostHeader.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html#managed-origin-request-policy-all-viewer-except-host-header
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }

  # API cache behavior: getlink
  ordered_cache_behavior {
    # Using the AWS Managed Caching Policy: CachingDisabled.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-policy-caching-disabled
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    path_pattern           = var.api.getlink.path_pattern
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.api.getlink.lambda_origin_id
    viewer_protocol_policy = "redirect-to-https" # Force HTTPS
    # Using the AWS Managed Origin Request Policy: AllViewerExceptHostHeader.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html#managed-origin-request-policy-all-viewer-except-host-header
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }

  # Index cache behavior
  default_cache_behavior {
    # Using the AWS Managed Caching Policy: CachingDisabled.
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-policy-caching-disabled
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.s3_origin_id
    viewer_protocol_policy = "redirect-to-https" # Force HTTPS
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021" # Default = TLSv1, Recommended = TLSv1.2_2021
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  comment             = "${var.project_name}-cloudfront-${var.environment}"
  price_class         = "PriceClass_100" # Use only North America and Europe edge locations
  aliases             = var.aliases
  default_root_object = "index.html"
  tags                = var.tags
}

// Create a bucket policy template for this distribution
data "template_file" "bucket_policy" {
  template = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : {
        "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.bucket_name}/*",
        "Condition" : {
          "StringEquals" : {
            //"AWS:SourceArn": "arn:aws:cloudfront::${var.aws_account}:distribution/${aws_cloudfront_distribution.cloudfront.id}"
            "AWS:SourceArn" : aws_cloudfront_distribution.cloudfront.arn
          }
        }
      }
    }
  )
}
