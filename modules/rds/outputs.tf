output "rds_address" {
  value = aws_db_instance.db_instance.address
}

output "rds_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "rds_availability_zone" {
  value = aws_db_instance.db_instance.availability_zone
}
