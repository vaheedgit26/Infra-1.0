# Create ALB
resource "aws_lb" "application_load_balancer" {
  name                       = "${local.resource_name}-alb-${local.alb_type}"
  internal                   = var.internal
  load_balancer_type         = "application"
  security_groups            = var.alb_sg_ids
  subnets                    = var.subnets
  enable_deletion_protection = false

  #depends_on         = [aws_internet_gateway.igw_vpc]

  tags = merge(
    var.alb_tags,
    var.common_tags,
    {
      Name = "${local.alb_type}-${var.project_name}-${var.env}-alb"
    }
  )
}
