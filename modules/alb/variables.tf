variable "alb_name" {}
variable "internal" {}
variable "alb_sg_ids" { type = list }
variable "subnets" { type = list }
variable "vpc_id" {}

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

variable "target_type" {
  type = string
  default = "ip"
}

variable "project_name" {}
variable "env" {}
variable "common_tags" { type = map }

variable "services" {
  description = "Microservices requiring ALB target groups and listener rules"

  type = map(object({
    tg_name       = string
    port          = number
    health_path   = string
    path_patterns = list(string)
    priority      = number
  }))

  validation {
    condition = alltrue([
      for service in values(var.services) :
      service.port >= 1 &&
      service.port <= 65535 &&
      service.priority >= 1 &&
      service.priority <= 50000 &&
      length(service.path_patterns) > 0
    ])

    error_message = "Each service must have a valid port, listener rule priority, and at least one path pattern."
  }
}

variable "alb_tags" {
  type    = map
  default = {}
}
