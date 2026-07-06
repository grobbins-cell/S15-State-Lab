provider "aws" {  
  region = "us-east-1"
}

# SABOTAGE 1: The Broken Backend
# Students must figure out why their state file isn't locking properly
terraform {
  backend "s3" {
    bucket         = "tkh-state-bucket-YOUR-INITIALS"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    # BUG: Missing DynamoDB table configuration for state locking
  }
}

resource "aws_instance" "state_target" {  
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t2.micro"  

  tags = {    
    Name = "TKH-State-Tracking-Target"  
  }
}