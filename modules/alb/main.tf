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

# create Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<center><h1>Hello, I am from backend APP ALB</h1></center>"
      status_code  = "200"
    }
  }
}
