locals {
  resource_name = "${var.project}-${var.env}"
  alb_type      = var.internal ? "internal" : "external"
}
