# CloudFront

Module for creating a CloudFront distribution with an S3 origin and Lambda origins, using custom domain alias(es) and an ACM certificate.

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution

CloudFront provides two ways to send authenticated requests to an Amazon S3 origin: `origin access control (OAC)` and `origin access identity (OAI)`. If your origin is an Amazon S3 bucket configured as a website endpoint, you must set it up with CloudFront as a custom origin. That means you can't use OAC (or OAI). [Source](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html). **This module uses the Origin Access Control (OAC) method.**

[Example S3 bucket policy](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html#create-oac-overview-s3) that allows read-only access to a CloudFront OAC.

```json
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::<S3 bucket name>/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "arn:aws:cloudfront::111122223333:distribution/<CloudFront distribution ID>"
            }
        }
    }
}
```
