resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = var.db_secret_name
  description             = "Database credentials for the ${var.project}-${var.env} environment"
  recovery_window_in_days = 0

  tags = merge (
    var.common_tags,
    { # Name = "/${var.project}/${var.env}/db-credentials" 
      Name = var.db_secret_name
    }
  )
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}
