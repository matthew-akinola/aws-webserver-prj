# create DB subnet group from the database subnets
resource "aws_db_subnet_group" "django_k8s_rds" {
  name       = "django_k8s_rds"
  subnet_ids = var.database_subnets

  tags = {
      Name = "django-k8s-database"
    }
  
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "django_k8s_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "14.7"
  instance_class         = "db.t2.micro"
  db_name                   = "webserver-db"
  username               = local.secret_map["username"]
  password               = local.secret_map["password"]
  db_subnet_group_name   = aws_db_subnet_group.django_k8s_rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.db_sg
  multi_az               = "true"
}

