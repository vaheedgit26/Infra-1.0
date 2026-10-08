# Create ALB
resource "aws_lb" "alb" {
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

# create HTTP Listener for ALB
resource "aws_lb_listener" "http" {
  count = var.http ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
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

###########################################################################################################################
/*
# Create HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTPS Frontend ALB</h1>"
      status_code  = "200"
    }
  }
}

# Create DNS record
resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.daws90s.shop" # *.daws90s.shop
  type    = "A"

  alias {
    # AWS details
    name                   = aws_lb.public_alb.dns_name
    zone_id                = aws_lb.public_alb.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}
*/
