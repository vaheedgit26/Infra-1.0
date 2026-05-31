locals {
  resource_name = "${var.project}-${var.env}"

  nat-instance-sg      = "${local.resource_name}-nat-instance-sg"
  private-instance-sg  = "${local.resource_name}-private-instance-sg"
  database-instance-sg = "${local.resource_name}-database-instance-sg"
}
