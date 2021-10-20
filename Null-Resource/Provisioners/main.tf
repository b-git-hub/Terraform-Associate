data "aws_vpc" "selected" {
  id = "vpc-8c1660e7"
}
/* This is creating a secuirty group for your VM */
resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "My server security group"
  /*The refereces the data created above */
  vpc_id = data.aws_vpc.selected.id

  ingress = [
    {
      /* Allow HTTP connection from any source */
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      /* Allow SSH only from my IP */
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["217.43.36.244/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

/*From the SSH keys located locally apply the public key to the deployer */
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDXhUR+7q3c+ldvXuoxfJTntCu2hEYDDTheBcS6Rov7BuvTQHwNqcH1H59rhHEziXrTRJvxCxyfPWhqSJSUv+hJ4MH2v4ebIYZSWJKZ8NEM8EoSCpSXRjUL72oVyMp3IV05SCb0vVFFKeiXJEx3KmQnbE5/vDmbGzdaaIXlGW8qZceEPxBldgL1yHW4/566hRw/wc9vkQmkfY0otYbRucbMJNmn0SCOpfhDq/0J9WKRHWDQAScHOh7xB9Watha14p3Ugp8WOJjeLvD63JDVbi1T/klQUYQg7DvT0EuUqmzpiBaFlFE9Yh497Ziowg/eqJflcUivo+Q4crg6jU2TMNy7KR0rk0M/2Qx3V3dqfjC99AwHrzjjS3M2TB2qdEhAHX7U55QFcdrRuL2ZdOFzlbkCsXN2hVYJmtqU3Nfi60XTvDUdWxP9qpFOH2XSRcVdQiOkhw7RnczF1wdM6lut1jpGoaayAS+MJN+KrQM65hn36nTO9ybZw9xmREDyJrlMM0= brian@DESKTOP-I603PK4"
}

/*Output Public IP of AWS Apache */
output "public_ip" {
  value = aws_instance.test-instance.public_ip
}

/* A Null Resource to check the status of an AWS instance on those checks */
resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.test-instance.id}"
  }
  depends_on = [
    aws_instance.test-instance
  ]
}

/* Pulling in that information from userdata.yaml */
data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

/* Information to deploy server in AWS */
resource "aws_instance" "test-instance" {
  ami           = "ami-074cce78125f09d61"
  instance_type = "t2.micro"
  /* Add the key generated and add it to your VM you are building */
  key_name = aws_key_pair.deployer.key_name
  /* Add the security group created above to your VM */
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  /* Referencing the data with the yaml information (install apache) */
  user_data = data.template_file.user_data.rendered
  /*Use a remote-exec to output a file on the host */
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("/home/brian/.ssh/terraform")
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${self.private_ip} >> /home/ec2-user/private_ips.txt"
    ]
  }

  tags = {
    Name = "MyServer"
  }
}
