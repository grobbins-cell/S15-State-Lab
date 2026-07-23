provider "aws" {
  region = "us-east-1"
}

# SABOTAGE 1: The Broken Backend
# Students must figure out why their state file isn't locking properly
terraform {
  backend "s3" {
    bucket = "tkh-state-bucket-YOUR-INITIALS"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
    # BUG: Missing DynamoDB table configuration for state locking
  }
}

# FIX: Dynamic AMI Lookup (Replaces hardcoded, deprecated AMI ID)
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "state_target" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"

  tags = {
    Name = "TKH-State-Tracking-Target"
  }
}