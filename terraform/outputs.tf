output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "ec2_instance_id" {
  value = module.ec2.id
}

output "ec2_public_ip" {
  value = aws_eip.this.public_ip
}

output "ansible_ssm_bucket_name" {
  value = aws_s3_bucket.ansible_ssm.id
}

output "security_group_id" {
  value = module.security_group.id
}