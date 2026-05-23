##################################  Mandatory Variables  ####################################
variable "sg_name"{}
variable "sg_description" {}
variable "vpc_id" {}

### Tags
# variable "project" {}
# variable "env" {}

variable "common_tags" {
  type = map
  default = {}
}

###################################  Default Variables   ########################################
variable "sg_tags" {
  default = {}
}
