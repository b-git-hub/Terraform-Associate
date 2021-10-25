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


/* Information to deploy server in AWS with an example of count*/
resource "aws_instance" "test-instance" {
  provider      = aws
  ami           = "ami-074cce78125f09d61"
  instance_type = "t2.micro"
  count = 2


  /* Sets the name to the local value */
  tags = {
    Name = "MyServer-${count.index}"
  }
}


/*Declaring and Output Must be declared to be called in main tf*/
output "public_ip" {
  value = aws_instance.test-instance[1].public_ip
}