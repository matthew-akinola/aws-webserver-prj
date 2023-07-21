
#---------------------------------

resource "aws_lb" "ext_alb" {
  name            = var.name
  internal        = false
  security_groups = [var.ext_alb_sg]

  subnets = var.public_subnets

  tags = {
      Name = "${var.name}-ext-alb"
    }
  
  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

#--- create a target group for the external load balancer
resource "aws_lb_target_group" "ext_alb_tgt_grp" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "alb-tgt-grp"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

#--- create a listener for the load balancer

resource "aws_lb_listener" "ext_alb_listener" {
  load_balancer_arn = aws_lb.ext_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.oyindamola.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ext_alb_tgt_grp.arn
  }
}



# ----------------------------
#Internal Load Balancers for webservers
#---------------------------------

resource "aws_lb" "int_alb" {
  name     = "djangoproject-internal-alb"
  internal = true

  security_groups = [var.int_alb_sg]

  subnets = var.private_subnets

    tags = {
      Name = "djangoproject-internal-alb"
    }

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}


# --- target group  for webserver -------

resource "aws_lb_target_group" "int_alb_tgt_grp" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name     = "webserver-tgt-grp"
   port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id
  }


resource "aws_lb_listener" "int_alb_listener" {
  load_balancer_arn = aws_lb.int_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.oyindamola.certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.int_alb_tgt_grp.arn
  }
}












