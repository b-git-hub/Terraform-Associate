/* Outputting information that can be found in the state file hosted on AWS  */
output "address" {
  value = aws_db_instance.example.address
  description = "connect to the database on this endpoint"
}

output "port" {
 value = aws_db_instance.example.port
 description = "The port the database is listening on"
}