terraform {
  backend "s3" {
    bucket  = "terraform-ansible-drone-terraform-state-bucket"
    key     = "terraform/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}