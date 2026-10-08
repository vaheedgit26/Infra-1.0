variable "internal" {}
variable "alb_sg_ids" { type = list }
variable "subnets" { type = list }
# variable "vpc_id" {}

variable "project_name" {}
variable "env" {}
variable "common_tags" { type = map }

variable "alb_tags" {
  type    = map
  default = {}
}
