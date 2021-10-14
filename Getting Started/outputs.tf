/*Declaring and Output*/
output "public_ip" {
  value = aws_instance.test-instance.public_ip
}