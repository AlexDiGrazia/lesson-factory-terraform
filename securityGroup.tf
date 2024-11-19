resource "aws_security_group" "private_ec2_SG" {
  name= "${var.app_name} Private EC2 Security Group"
  description= "Private SG"
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic" {
  security_group_id = aws_security_group.private_ec2_SG.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}