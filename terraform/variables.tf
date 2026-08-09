variable "environment_name" {
  type = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a"]
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
  type        = string
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
  type        = string
}
