variable "alb_name" {}
variable "internal" {}
variable "alb_sg_ids" { type = list }
variable "subnets" { type = list }
variable "vpc_id" {}
variable "target_group_name" { type = list }

variable "http" { 
  type    = boolean 
  default = true 
}

variable "https" { 
  type    = boolean 
  default = false
}

variable "http_to_https" { 
  type = boolean 
  default = false
}

variable "project_name" {}
variable "env" {}
variable "common_tags" { type = map }

variable "alb_tags" {
  type    = map
  default = {}
}
