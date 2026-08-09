module "ec2_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.8"

  name                  = "ec2-role"
  use_name_prefix       = false
  create_instance_profile = true

  trust_policy_permissions = {
    TrustEC2 = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
    }
  }

  policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Project     = "terraform-ansible-drone"
    Environment = var.environment_name
    ManagedBy   = "terraform"
  }
}
