output "alb_arn" {
    value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "target_group_arns" {
  description = "Target group ARNs indexed by microservice name"

  value = {
    for name, target_group in aws_lb_target_group.service :
    name => target_group.arn
  }
}

# Your environment can then access individual target groups:

# module.alb.target_group_arns["backend"]
# module.alb.target_group_arns["frontend"]
# module.alb.target_group_arns["orders"]
