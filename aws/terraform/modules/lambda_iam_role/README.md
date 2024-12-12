# Lambda IAM permissions

Create:
- IAM role which can be assumed by Lambda via a Trust policy
- Attach AWS Managed AWSLambdaBasicExecutionRole policy to allow logging to CloudWatch
- Attach custom policy which grants access to DynamoDB

## Example policies

Trust policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
```

AWSLambdaBasicExecutionRole (AWS Managed)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

DynamoDB permissions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DynamoDBTableAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem"
      ],
      "Resource": "arn:aws:dynamodb:eu-west-1:123456789012:table/dynlink-links-prod"
    }
  ]
}
```

The user needs permission to pass the role to the Lambda function (if passing an existing role) when deploying:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:PassRole"
      ],
      "Resource": "arn:aws:iam::123456789012:role/dynlink_lambda_prod"
    }
  ]
}
```
