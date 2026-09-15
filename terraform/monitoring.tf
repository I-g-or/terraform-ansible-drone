module "ec2_monitoring" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0"

  name = "monitoring"

  ami = data.aws_ssm_parameter.ec2_ami.value

  instance_type = var.instance_type

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.monitoring-sg.id]

  iam_instance_profile = module.ec2_iam_role.instance_profile_name

  associate_public_ip_address = true

  enable_volume_tags = false

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device = {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name        = "monitoring"
    Project     = "terraform-ansible-drone"
    Environment = var.environment_name
    ManagedBy   = "terraform"
  }
}

resource "aws_eip" "monitoring" {
  domain = "vpc"
  tags = {
    Name        = "monitoring-eip"
    Project     = "terraform-ansible-drone"
    Environment = var.environment_name
    ManagedBy   = "terraform"
  }
}

resource "aws_eip_association" "monitoring" {
  instance_id   = module.ec2_monitoring.id
  allocation_id = aws_eip.monitoring.id
}

resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "grafana.igor1.pp.ua"
  type    = "A"
  ttl     = 300
  records = [aws_eip.monitoring.public_ip]
}