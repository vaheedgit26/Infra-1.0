locals {
  resource_name = "${var.project_name}-${var.env}"
  alb_type      = var.internal ? "internal" : "external"
}
