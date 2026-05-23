output "db_secret_name" {
  description = "Name of the secret created"
  value       = aws_secretsmanager_secret.db_credentials.name
}

output "db_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.db_credentials.arn
}
