output "alb_dns_name" {
  value       = aws_lb.ext_alb.dns_name
  description = "External load balance arn"
}

output "ext_alb_tgt" {
  description = "External Load balancaer target group"
  value       = aws_lb_target_group.ext_alb_tgt_grp.arn
}


output "int_alb_tgt" {
  description = "webserver target group"
  value       = aws_lb_target_group.int_alb_tgt_grp.arn
}
