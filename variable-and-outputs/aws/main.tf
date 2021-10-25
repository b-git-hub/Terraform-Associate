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

/*Declaring a variable, information found in terraform.tfvars*/
variable "instance_type" {
  type = string
}

/* Declaring a local value for reference in the script  */
locals  {
    ami           = "ami-074cce78125f09d61"
}

/* Information to deploy server in AWS */
resource "aws_instance" "test-instance" {
  provider      = aws
  ami           = local.ami
  instance_type = var.instance_type


  /* Sets the name to the local value */
  tags = {
    Name = "MyServer-Brian"
  }
}


/*Declaring and Output Must be declared to be called in main tf*/
output "public_ip" {
  value = aws_instance.test-instance.public_ip
}