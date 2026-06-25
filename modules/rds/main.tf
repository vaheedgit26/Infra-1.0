# create subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = var.db_subnet_group_name
  subnet_ids   = var.database_subnet_ids
  description  = "Subnet Group for Database"

  tags = merge(
    var.common_tags,
    { Name = var.db_subnet_group_name} }
  )
}

# create RDS instance
resource "aws_db_instance" "db_instance" {
  identifier              = var.identifier
  availability_zone       = var.availability_zone
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type        # "gp2"
  storage_encrypted       = var.storage_encrypted   # true
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name  # var.db_subnet_group_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  multi_az                = var.env == "prod" ? true : false
  skip_final_snapshot     = var.env == "prod" ? false : true
  backup_retention_period = var.env == "prod" ? 7 : 0
  deletion_protection     = var.env == "prod" ? true : false
  publicly_accessible     = false
  
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-${var.identifier}"
    }
  )
}
