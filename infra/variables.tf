variable "region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "198.168.0.0/16"
}

variable "subnet_cidr" {
  type = "list"
  default = ["198.168.1.0/24", "198.168.2.0/24", "198.168.3.0/24"]
}

data "aws_availability_zones" "azs" {}


