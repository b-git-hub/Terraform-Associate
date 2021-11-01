terraform {
  /* Using the s3 bucket and dynamoDB connect Terraform Backend to AWS  */
/*
  backend "s3" {
    bucket = "brian-tf-state-123789654321"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "brian-tf-locks"
    encrypt = true
  }
*/
  
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


/* Creates a bucket to store the terrafrom state file  */
resource "aws_s3_bucket" "terraform_state" {
  bucket = "brian-tf-state-123789654321"
  force_destroy = true
  lifecycle {
    prevent_destroy = false
    
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

/* Creating a dynamoDB to store the lock file  */
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "brian-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  } 
}

