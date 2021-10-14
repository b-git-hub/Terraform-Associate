/*Declare a local input used for hardcoded inputs */
locals {
  name = "Brian-Test"
}

/* Information to deploy server in AWS */
resource "aws_instance" "test-instance" {
  provider = aws.us-east
  ami           = "ami-074cce78125f09d61"
  instance_type = var.instance_type

/* Sets the name to the local value */
  tags = {
    Name = "MyServer-${local.name}"
  }
}

