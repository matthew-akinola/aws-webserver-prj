#############################
##creating bucket for s3 backend
#########################


# creating VPC
module "VPC" {
  source                              = "./modules/VPC"
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  private_subnets                     = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets                      = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}

#Module for Application Load balancer, this will create Extenal Load balancer and internal load balancer
module "ALB" {
  source                = "./modules/ALB"
  name                  = "ACS-ext-alb"
  vpc_id                = module.VPC.vpc_id
  ext_alb_sg            = module.security.ext_alb_sg
  int_alb_sg            = module.security.int_alb_sg
  public_subnets        = [
                          module.VPC.public_subnets-1, 
                          module.VPC.public_subnets-2
                          ]
  private_subnets       = [
                          module.VPC.private_subnets-1, 
                          module.VPC.private_subnets-2
                          ]
  load_balancer_type    = "application"
  ip_address_type       = "ipv4"
}

module "security" {
  source = "./modules/Security"
  vpc_id = module.VPC.vpc_id
  public_subnets     = [module.VPC.public_subnets-1, module.VPC.public_subnets-2]
  private_subnet_1   = module.VPC.private_subnets-1
  private_subnet_2   = module.VPC.private_subnets-2
  database_subnets   = [module.VPC.private_subnets-3, module.VPC.private_subnets-4 ]
}


module "AutoScaling" {
  source            = "./modules/Autoscaling"
  ami_webserver     = var.webserver_ami
  ami_nginx         = var.nginx_ami
  desired_capacity  = 2
  min_size          = 2
  max_size          = 2
  web_sg            = [module.security.int_alb_sg]
  nginx_sg          = [module.security.nginx_sg]
  ext_alb_tgt       = module.ALB.ext_alb_tgt
  int_alb_tgt       = module.ALB.int_alb_tgt
  instance_profile  = module.VPC.instance_profile
  public_subnets    = [module.VPC.public_subnets-1, module.VPC.public_subnets-2]
  private_subnets   = [module.VPC.private_subnets-1, module.VPC.private_subnets-2]
  keypair           = var.keypair

}


# # RDS module; this module will create the RDS instance in the private subnet

module "RDS" {
  source           = "./modules/RDS"
  db_sg            = [module.security.rds_sg]
  database_subnets = [module.VPC.private_subnets-3, module.VPC.private_subnets-4]
}
