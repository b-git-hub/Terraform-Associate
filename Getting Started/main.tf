terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.62.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}



resource "aws_instance" "test-instance" {
  ami           = "ami-074cce78125f09d61"
  instance_type = var.instance_type

  tags = {
    Name = "Test Instance for Training"
  }
}