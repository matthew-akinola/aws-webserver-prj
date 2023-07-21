

variable "db_sg" {
  type = list
  description = "The DB security group"
}

variable "database_subnets" {
  type        = list
  description = "database subnets group"
}
