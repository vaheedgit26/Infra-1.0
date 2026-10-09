variable "alb_name" {}
variable "internal" {}
variable "alb_sg_ids" { type = list }
variable "subnets" { type = list }
variable "vpc_id" {}

variable "http_only" {
  description = "Create an HTTP listener only"
  type        = bool
  default     = false
}

variable "http_only" {
  description = "Create an HTTP listener only"
  type        = bool
  default     = false
}

variable "https_only" {
  description = "Create an HTTPS listener only"
  type        = bool
  default     = false
}

variable "http_to_https" {
  description = "Create HTTP redirect and HTTPS application listeners"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN required for HTTPS modes"
  type        = string
  default     = null
  nullable    = true
}

variable "listener_mode" {
  description = "Listener mode: http_only, https_only, or http_to_https"
  type        = string
  default     = "http"         # "http", "https" "http_to_https"

  validation {
    condition = contains(
      ["http", "https", "http_to_https"],
      var.listener_mode
    )
    error_message = "Choose http_only, https_only, or http_to_https."
  }
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
