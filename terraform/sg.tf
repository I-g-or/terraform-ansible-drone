module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0"

  name        = "igor1-sg"
  description = "Security group for igor1.pp.ua (HTTP + HTTPS)"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS"
    }
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol    = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
      description = "HTTP"
    }
    # ssh = {
    #   from_port   = 22
    #   to_port     = 22
    #   ip_protocol    = "tcp"
    #   cidr_ipv4 = "0.0.0.0/0"
    #   description = "SSH"
    # }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "All outbound"
    }
  }

  tags = {
    Project     = "terraform-ansible-drone"
    Environment = var.environment_name
    ManagedBy   = "terraform"
  }
}