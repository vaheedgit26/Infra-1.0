################  NAT Instance variables  ####################################
variable "vpc_id" {}
variable "public_subnet_cidr" { type = list(any) }
variable "private_subnet_cidr" { type = list }
# variable "private_subnet_ids" { type = list }

variable private_route_table_id { type = string }
variable database_route_table_id { type = string }
# variable nat_primary_network_interface_id { type = string }

variable "is_nat_instance" { default = true }
variable "is_eip_required" { default = false }

# For nat user data VPC_CIDR purpose
#variable "vpc_cidr" {
#  type    = string
#  default = null

#  validation {
#    condition     = !(var.is_nat_instance == true && var.vpc_cidr == null)    
#    error_message = "vpc_cidr must be provided when is_nat_instance is true"
#  }
#}
############### Common variables for all Modules ############################
variable "project" {}
variable "env" {}
variable "common_tags" {
  type = map
  default = {}
}
############### SG-MODULE related variables   ################################
# variable "project" {}
# variable "env" {}
# variable "common_tags" { type = map }
# variable "vpc_id" {}  
# already declared above variables for other purpose

variable "remote_ip_to_connect_nat_instance" {}
variable "vpc_cidr" {}

#############  EC2-MODULE related variables   #################################
# variable "project" {}
# variable "env" {}
# variable "common_tags" { type = map }

variable "ami_id" {}
variable "public_key_name" {}
variable "public_subnet_ID_to_launch_nat_instance" {}

variable "root_volume_size" {}
variable "instance_type" {}
