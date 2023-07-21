# launch template for nginx

resource "aws_launch_template" "nginx_launch_template" {
  image_id               = var.ami_nginx
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.nginx_sg

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  placement {
    availability_zone = element(data.aws_availability_zones.available.names, 0)
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

  tags = {
      Name = "nginx-launch-template"
    }
  }

  user_data = filebase64("${path.module}/nginx.sh")
}



#webserver launch template config
resource "aws_launch_template" "webserver_launch_template" {
  image_id               = var.ami_webserver
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.web_sg

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  placement {
    availability_zone = element(data.aws_availability_zones.available.names, 0)
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

  tags = {
      Name = "webserver-launch-template"
    }
  }

  user_data = filebase64("${path.module}/nginx.sh")
}