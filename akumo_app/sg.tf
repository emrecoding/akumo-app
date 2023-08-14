resource "aws_security_group" "akumo_app_sg" {
  name        = "akumo_app_sg_${var.env}"
  description = "Allow SSH inbound traffic for ${var.env}"
  vpc_id      = data.aws_vpc.default_vpc.id
  tags = merge(local.common_tags, {
    Name = "akumo_app_sg_${var.env}"
  })
}


resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  description       = "this security group allows port 22 access"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["This should include CIDR IPs of the local IP you are using to access AWS, and the VPC CIDR to have intra-instance access"]
  security_group_id = aws_security_group.akumo_app_sg.id
}

resource "aws_security_group_rule" "ssh_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.akumo_app_sg.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  description       = "this security group allows port 443 access"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.akumo_app_sg.id
}