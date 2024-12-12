// S3 Bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.name
  tags   = var.tags
}

// Turn these settings off to control access via a policy
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

// Optional: Attach custom policy to the bucket
resource "aws_s3_bucket_policy" "custom_bucket_policy" {
  count  = var.custom_policy == null ? 0 : 1
  bucket = aws_s3_bucket.s3_bucket
  policy = var.custom_policy
}

// Upload the index file
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "index.html"
  source       = var.index_file
  content_type = "text/html" # https://developer.mozilla.org/en-US/docs/Web/HTTP/MIME_types/Common_types
  etag         = filemd5(var.index_file)
}
