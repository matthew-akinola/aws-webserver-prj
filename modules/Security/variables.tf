
variable "vpc_id" {
  type        = string
  description = "The vpc ID"
}

# The public subnet froup for external loadbalancer
variable "public_subnets" {
  type        = list
  description = "Public subnets to deploy external ALB"
}

variable "private_subnet_1" {
  type        = string
  description = "Private subnets to deploy Internal ALB"
}
variable "private_subnet_2" {
  type        = string
  description = "Private subnets to deploy Internal ALB"
}

variable "database_subnets" {
  type        = list
  description = "RDS Private subnets"
}