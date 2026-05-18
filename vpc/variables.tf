# variable "region" {}
variable "vpc_cidr" {}
variable "project" {}
variable "env" {}

variable "eks_cluster_name" { default = null }   # For EKS public and private subnet tags for ELBs 

variable "vpc_count" {
  type = number
  default = 1
}

# Tag related variable
variable "common_tags" {
  type = map
  default = {} 
}

variable "vpc_tags" {
  type = map
  default = {}
}

variable "create_nat_gateway" { 
  type = bool 
  default = false
}

variable "create_nat_instance" {
  type = bool
  default = false
}

variable "map_public_ip_on_launch" {
  type = bool
  default = true
}

####################################################################
#####               Variable Validations                       #####
####################################################################
variable "max_azs" { 
  type = number
  default = 2
}

variable "azs_count" {
  type = number
  #default = 1

  validation {
    condition     = (var.azs_count > 0) && (var.azs_count <= var.max_azs)
    error_message = "Please provide azs_count min:1 max:2"
  }
}

variable "public_subnet_count" {
  type = number
  #default = 1

  validation {
    condition     = (var.public_subnet_count > 0) && (var.public_subnet_count == var.azs_count) && (var.public_subnet_count <= var.max_azs)
    error_message = "Please provide public_subnet_count min:1 max:2 and matches the number of availability zones (var.azs_count)."
  }
}

variable "private_subnet_count" {
  type = number
  #default = 1

  validation {
    condition     = (var.private_subnet_count > 0) && (var.private_subnet_count == var.azs_count) && (var.private_subnet_count <= var.max_azs)
    error_message = "Please provide private_subnet_count min:1 max:2 and matches the number of availability zones (var.azs_count)."
  }
}

variable "database_subnet_count" {
  type = number
  #default = 1

  validation {
    condition     = (var.database_subnet_count > 0) && (var.database_subnet_count == var.azs_count) && (var.database_subnet_count <= var.max_azs)
    error_message = "Please provide database_subnet_count min:1 max:2 and matches the number of availability zones (var.azs_count)."
  }
}

variable "public_subnet_cidr" {
  type = list(any)

  validation {
    condition     = length(var.public_subnet_cidr) > 0 && length(var.public_subnet_cidr) == var.public_subnet_count && length(var.public_subnet_cidr) <= var.max_azs
    error_message = "Please provide public_subnet_cidr min:1 max:2 and matches the number of public subnets (var.public_subnet_count)."
  }
}

variable "private_subnet_cidr" {
  type = list(any)

  validation {
    condition     = length(var.private_subnet_cidr) > 0 && length(var.private_subnet_cidr) == var.private_subnet_count && length(var.private_subnet_cidr) <= var.max_azs
    error_message = "Please provide private_subnet_cidr min:1 max:2 and matches the number of private subnets (var.private_subnet_count)."
  }
}

variable "database_subnet_cidr" {
  type = list(any)

  validation {
    condition     = length(var.database_subnet_cidr) > 0 && length(var.database_subnet_cidr) == var.database_subnet_count && length(var.database_subnet_cidr) <= var.max_azs
    error_message = "Please provide database_subnet_cidr min:1 max:2 and matches the number of database subnets (var.database_subnet_count)."
  }
}
