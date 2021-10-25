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

/* Deploying a data set that searches AWS based on a filter  */
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

/* Information to deploy server in AWS */
resource "aws_instance" "test-instance" {
  provider      = aws
  ami           = data.aws_ami.ubuntu.id
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