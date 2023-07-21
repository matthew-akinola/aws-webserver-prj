
output "ext_alb_sg" {
  value = aws_security_group.ext_alb_sg.id
}

output "rds_sg" {
  value = aws_security_group.rds_sg.id
}

output "int_alb_sg" {
  value = aws_security_group.int_alb_sg.id
}

output "nginx_sg" {
  value = aws_security_group.nginx_sg.id
}