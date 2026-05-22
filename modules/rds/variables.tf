variable "db_subnet_group_name" {}
variable "database_subnet_ids"  {}
variable "common_tags" { default = {} }

# RDS variables
variable "identifier"             {}
variable "availability_zone"      {}
variable "engine"                 {}
variable "engine_version"         {}
variable "instance_class"         {}
variable "allocated_storage"      {}
variable "storage_type"           {}
variable "storage_encrypted"      {}
variable "db_name"                {}
variable "db_username"            {}
variable "db_password"            {}
variable "vpc_security_group_ids" {}
