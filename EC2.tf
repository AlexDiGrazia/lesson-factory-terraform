resource "aws_instance" "private_ec2" {
  count                       = 2
  ami                         = "ami-08a0d1e16fc3f61ea"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.private_ec2_SG.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = false
  subnet_id                   = module.vpc.private_subnet_ids[count.index]
 
  user_data = file("./docker-script.sh")

  tags = {
    Name = "${var.app_name} Private EC2 instance ${count.index + 1}"
  }
}


output "private_ec2s" {
  value = aws_instance.private_ec2[*].id
}