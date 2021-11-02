/* Having to define and external allow rule specifically for lb to allow health checks of servers  */
resource "aws_security_group" "lb" {
  name        = "${var.cluster_name}-alb"
  description = "Allow LB traffic"
}

/* When using modules it's best practise to seperate out resources into seperate chunks where possible  */

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id
  description       = "HTTP for VMs"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.lb.id

  description      = "Allow outbbound"
  from_port        = local.any_port
  to_port          = local.any_port
  protocol         = local.any_protocol
  cidr_blocks      = local.all_ips
}

resource "aws_security_group" "http" {
  name        = "${var.cluster_name}-instance"
  description = "Allow VMs"
}

resource "aws_security_group_rule" "allow_vmhttp_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.http.id
  description       = "HTTP for Access"
  from_port         = "8080"
  to_port           = "8080"
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}