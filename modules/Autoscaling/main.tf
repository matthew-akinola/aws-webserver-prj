
# ------ Autoscaling group for reverse proxy nginx ---------

resource "aws_autoscaling_group" "nginx_asg" {
  name                      = "nginx-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  
  vpc_zone_identifier = var.public_subnets


  launch_template {
    id      = aws_launch_template.nginx_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Nginx-autoscale"
    propagate_at_launch = true
  }


}

# attaching autoscaling group of nginx to external load balancer
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.id
  alb_target_group_arn   = var.ext_alb_tgt
}


# ------ Autoscaling group for webserver ---------

resource "aws_autoscaling_group" "webserver_asg" {
  name                      = "webserver-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  
  vpc_zone_identifier = var.private_subnets


  launch_template {
    id      = aws_launch_template.webserver_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Nginx-autoscale"
    propagate_at_launch = true
  }
}

# attaching autoscaling group of nginx to external load balancer
resource "aws_autoscaling_attachment" "asg_attachment_webserver" {
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.id
  alb_target_group_arn   = var.ext_alb_tgt
}