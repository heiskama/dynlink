output "arn" {
  value       = aws_iam_role.iam_for_lambda.arn
  description = "Amazon Resource Name (ARN) specifying the role."
}

output "id" {
  value       = aws_iam_role.iam_for_lambda.id
  description = "Name of the role."
}

output "unique_id" {
  value       = aws_iam_role.iam_for_lambda.unique_id
  description = "Stable and unique string identifying the role."
}
