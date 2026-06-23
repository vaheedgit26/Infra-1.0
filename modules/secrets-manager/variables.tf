variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "common_tags" { default = {} }

variable "db_secret_name" {
  description = "Secret name to store in Secrets Manager"
  type        = string
  # sensitive   = true
}

variable "db_username" {
  description = "Database username to store in Secrets Manager"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password to store in Secrets Manager"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT token to store in Secrets Manager"
  type        = string
  sensitive   = true
  default     = "this-is-default-jwt-web-token-created"
}
