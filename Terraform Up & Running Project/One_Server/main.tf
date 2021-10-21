terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "dummy_server" {
  ami           = "ami-00399ec92321828f5" # us-west-2
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}