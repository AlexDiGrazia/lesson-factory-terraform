resource "aws_security_group" "private_ec2_SG" {
  name        = "${var.app_name} Private EC2 Security Group"
  description = "Private SG"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.app_name}-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_from_lb_to_api" {
  security_group_id = aws_security_group.private_ec2_SG.id
  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.load_balancer_security_group.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_from_lb_to_frontend" {
  security_group_id = aws_security_group.private_ec2_SG.id
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.load_balancer_security_group.id
}

#add an ingress rule to allow traffic on port 80 from the load balancer

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic" {
  security_group_id = aws_security_group.private_ec2_SG.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "load_balancer_security_group" {
  name        = "${var.app_name} Load Balancer Security Group"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.app_name} Application Load Balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_vpc_traffic" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "db_sg" {
  name = "${var.app_name}-db-sg"
  description = "Database Security Group"
  vpc_id = module.vpc.vpc_id  
  
  tags = {
    Name = "${var.app_name}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_traffic_db_private" {
  security_group_id = aws_security_group.db_sg.id
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.private_ec2_SG.id
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.app_name}-bastion-sg"
  description = "Bastion SG"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${var.app_name}-bastion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_traffic_db_bastion" {
   security_group_id = aws_security_group.db_sg.id
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
