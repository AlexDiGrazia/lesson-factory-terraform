 resource "aws_db_instance" "lessonfactorydb" {
  allocated_storage    = 20
  db_name              = "lessonfactorydb"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  skip_final_snapshot  = true
  multi_az = false
  publicly_accessible = false
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = "${var.app_name}-db-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id
}
