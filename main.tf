/* Information to deploy server in AWS */
resource "aws_instance" "test-instance" {
  provider      = aws
  ami           = "ami-074cce78125f09d61"
  instance_type = var.instance_type

  /* Sets the name to the local value */
  tags = {
    Name = "MyServer-Brian"
  }
}

/*Declaring and Output*/
output "public_ip" {
  value = aws_instance.test-instance.public_ip
}