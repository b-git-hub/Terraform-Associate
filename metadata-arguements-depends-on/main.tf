/* Provided in Hashicorp Documentation to connect to AWS*/
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

/* Adding a bucket that depends on the AWS instance being up  */
resource "aws_s3_bucket" "bucket" {
  bucket = "mybigtestbucket-depends-on"
  depends_on = [
    aws_instance.test-instance
  ]
}

/* Information to deploy server in AWS */
resource "aws_instance" "test-instance" {
  provider      = aws
  ami           = "ami-074cce78125f09d61"
  instance_type = "t2.micro"


  /* Sets the name to the local value */
  tags = {
    Name = "MyServer-Brian"
  }
}


/*Declaring and Output Must be declared to be called in main tf*/
output "public_ip" {
  value = aws_instance.test-instance.public_ip
}