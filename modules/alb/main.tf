# Create ALB
resource "aws_lb" "alb" {
  name                       = "${var.alb_name}-${local.alb_type}"
  internal                   = var.internal
  load_balancer_type         = "application"
  security_groups            = var.alb_sg_ids
  subnets                    = var.subnets
  enable_deletion_protection = false      # For production: true

  # depends_on         = [aws_internet_gateway.igw_vpc]

  tags = merge(
    var.alb_tags,
    var.common_tags,
    {
      Name = "${local.alb_type}-${var.project}-${var.env}-alb"
    }
  )
}

# create HTTP Listener for ALB
resource "aws_lb_listener" "http" {
  count = var.listener_mode == "http" ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<center><h1>Hello, I am from Shopverse Frontend ALB</h1></center>"
      status_code  = "200"
    }
  }
}

# Create HTTPS Listener
resource "aws_lb_listener" "https" {
  count = var.listener_mode == "https_only" ||
          var.listener_mode == "http_to_https" ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = var.acm_certificate_arn
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<center><h1>Hello, I am from Shopverse Frontend ALB</h1></center>"
      status_code  = "200"
    }
  }

  lifecycle {
    precondition {
      condition = (
        var.acm_certificate_arn != null &&
        trimspace(coalesce(var.acm_certificate_arn, "")) != ""
      )
      error_message = "An ACM certificate ARN is required for HTTPS listener modes."
    }
  }
}

# Redirect HTTP to HTTPS
resource "aws_lb_listener" "http_redirect" {
  count = var.listener_mode == "http_to_https" ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Create a Listener rule for ALB
resource "aws_lb_listener_rule" "service" {
  for_each = var.services

  listener_arn = aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[each.key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }
}

# Create Target Group
resource "aws_lb_target_group" "service" {
  for_each = var.services

  name        = each.value.tg_name
  port        = each.value.port
  protocol    = "HTTP"
  target_type = var.target_type        # default: "ip"
  vpc_id      = var.vpc_id

  # deregistration_delay = 30

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = each.value.health_path
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, {
    Name    = "${each.value.tg_name}"
    Service = each.key
  })
}


