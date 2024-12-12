output "name" {
  value       = aws_dynamodb_table.dynamodb.id
  description = "The name of the table."
}

output "arn" {
  value       = aws_dynamodb_table.dynamodb.arn
  description = "The Amazon Resource Name (ARN) of the table."
}
