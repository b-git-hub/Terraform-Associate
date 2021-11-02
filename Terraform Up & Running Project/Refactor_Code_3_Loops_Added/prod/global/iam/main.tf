terraform {
  /* Using the s3 bucket and dynamoDB connect Terraform Backend to AWS  */
  backend "s3" {
    bucket = "brian-tf-state-123789654321"
    key    = "global/iam/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "brian-tf-locks"
    encrypt = true
    profile = "prod"
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0"
    }
  }
}

provider "aws" {
  profile = "prod"
  region = "us-east-2"
}

resource "aws_iam_user" "example" {
    count = 3
    name = "neo.${count.index}"
}