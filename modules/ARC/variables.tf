variable "region" {}
variable "project" {}
variable "env" {}

variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}

variable "github_org" {}
variable "github_repo" {}
variable "github_token" {
  sensitive = true
}
