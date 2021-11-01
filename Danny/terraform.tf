terraform {
/* Provided in Hashicorp Documentation to connect to AWS*/
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
profile = "prod"
region = "us-east-1"
}

variable "aws_region" {
description = "The AWS region to deploy your instance"
default = "us-east-1"
}

variable "aws_amis" {
type = map(any)
default = {
"us-east-1" = "ami-0739f8cdb239fe9ae"
"us-west-2" = "ami-008b09448b998a562"
"us-east-2" = "ami-0ebc8f6f580a04647"
}
}



resource "aws_instance" "test-instance" {
  ami = lookup(var.aws_amis, var.aws_region)
  instance_type = "t2.micro"

  /* Sets the name to the local value */
  tags = {
    Name = "MyServer"
  }
}
 