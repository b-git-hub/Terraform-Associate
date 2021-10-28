/* Having to define and external allow rule specifically for lb to allow health checks of servers  */
resource "aws_security_group" "lb" {
  name        = "LB-Traffic"
  description = "Allow LB traffic"

  ingress = [
    {
      description      = "HTTP for VMs"
      from_port        = var.lb_Port_Number
      to_port          = var.lb_Port_Number
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "Allow outbboound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_security_group" "http" {
  name        = "VM-Traffic"
  description = "Allow VMs"

  ingress = [
    {
      description      = "HTTP for Access"
      from_port        = var.Port_Number
      to_port          = var.Port_Number
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}