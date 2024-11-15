resource "aws_security_group" "private_ec2_SG" {
  name= "${var.app_name} Private EC2 Security Group"
  description= "Private SG"
  vpc_id = aws_vpc.main.id
}