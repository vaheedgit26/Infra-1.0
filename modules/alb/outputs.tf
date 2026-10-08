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

output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend.arn
}

output "frontend_target_group_name" {
  value = aws_lb_target_group.frontend.name
}
