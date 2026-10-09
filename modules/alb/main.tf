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
  count = var.http ? 1 : 0

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

# Create a Listener rule for ALB
resource "aws_lb_listener_rule" "app" {
  listener_arn = aws_lb_listener.http.arn       # local.app_alb_listener_arn
  priority     = 100                            # low priority will be evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_app_target_group.arn #aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["/*"]        # This matches all paths
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


###########################################################################################################################
/*
# Create HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"   # "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = local.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTPS Frontend ALB</h1>"
      status_code  = "200"
    }

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.frontend.arn
    }

  }
}


# create a listener on port 80 with redirect action to 443 (http ---> https)
# resource "aws_lb_listener" "alb_http_listener" {
#   load_balancer_arn = aws_lb.application_load_balancer.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = 443
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }


# Create a Listener rule for ALB
resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn #local.app_alb_listener_arn
  priority     = 100                      # low priority will be evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_app_target_group.arn #aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["/*"] # This matches all paths
    }
  }

  #   condition {
  #     host_header {
  #       values = ["${var.backend_tags.Component}.app-${var.environment}.${var.zone_name}"]  # backend.app-dev.daws81s.online
  #     }
  #   }
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}
*/
