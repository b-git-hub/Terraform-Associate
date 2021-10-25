/* Referencing a module I created with all the code underneath it  */
module "aws_server" {
  source = ".//aws"
  instance_type = "t2.micro"
}

/*Declaring and Output from my submodules when using a submodule*/
output "public_ip" {
  value = module.aws_server.public_ip
}