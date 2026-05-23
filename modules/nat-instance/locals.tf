locals {
  resource_name = "${var.project}-${var.env}"

  nat-instance-sg      = "${var.resource_name}-nat-instance-sg"
  private-instance-sg  = "${var.resource_name}-private-instance-sg"
  database-instance-sg = "${var.resource_name}-database-instance-sg"
}
