# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = var.db_subnet_group_name
  subnet_ids   = var.database_subnet_ids
  description  = "Subnet Group for Database"

  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-${var.db_subnet_group_name}"
    }
  )
}
