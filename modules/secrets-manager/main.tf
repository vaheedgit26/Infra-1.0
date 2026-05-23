resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "/${var.project}/${var.env}/db-credentials"
  description             = "Database credentials for the ${var.project}-${var.env} environment"
  recovery_window_in_days = 0

  tags = {
    Name    = "/${var.project}/${var.env}/db-credentials"
    Project = var.project
    Env     = var.env
    Terraform = "True"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}
