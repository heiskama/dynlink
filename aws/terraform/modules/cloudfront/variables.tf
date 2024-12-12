variable "project_name" {
  type        = string
  description = "Project name. Used as a naming prefix."
}

variable "environment" {
  type        = string
  description = "Environment. Used as a naming suffix."
}

variable "bucket_name" {
  type        = string
  description = "Bucket name of the S3 Origin. This is used to create an access policy template."
}

variable "s3_domain_name" {
  type        = string
  description = "Domain name of the CloudFront Origin."
}

variable "s3_origin_id" {
  type        = string
  default     = "s3_static_site"
  description = "ID for the CloudFront Origin."
}

variable "api" {
  type        = map(map(string))
  description = "API configuration"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to set. Limits and requirements: https://docs.aws.amazon.com/tag-editor/latest/userguide/best-practices-and-strats.html#id_tags_naming_best_practices"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM Certificate to use."
}

variable "aliases" {
  type        = list(string)
  description = "List of domain aliases for this distribution. This should match with the ACM certificate."
}
