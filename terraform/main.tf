module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment_name}-vpc"
  cidr =  var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_subnets

  create_igw         = true
  enable_nat_gateway = false
  enable_vpn_gateway = false

  map_public_ip_on_launch = true

  tags = {
    Project     = "terraform-ansible-drone"
    Environment = var.environment_name
    ManagedBy   = "terraform"
  }

  public_subnet_tags = {
    Name = "${var.environment_name}-terraform-ansible-drone-public-subnet"
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0"

  name = "igor1"

  ami = data.aws_ssm_parameter.ec2_ami.value

  instance_type = var.instance_type

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security_group.id]

  iam_instance_profile = module.ec2_iam_role.instance_profile_name

  associate_public_ip_address = true

  root_block_device = {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  # user_data = <<-EOF
  #   #!/bin/bash
  #   apt-get update
  # EOF

  tags = {
    Project     = "terraform-ansible-drone"
    Environment = var.environment_name
    ManagedBy   = "terraform"
  }
}

data "aws_ssm_parameter" "ec2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_eip" "this" {
  domain = "vpc"
  tags = {
    Project     = "terraform-ansible-drone"
    Environment = var.environment_name
    ManagedBy   = "terraform"
  }
}

resource "aws_eip_association" "this" {
  instance_id   = module.ec2.id
  allocation_id = aws_eip.this.id
}

data "aws_route53_zone" "this" {
  name = "igor1.pp.ua"
}

resource "aws_route53_record" "igor1" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "igor1.pp.ua"
  type    = "A"
  ttl     = 300
  records = [aws_eip.this.public_ip]
}