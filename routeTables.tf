resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.app_name} Public Route Table"
  }
}

resource "aws_route_table_association" "public_RT_association" {
  count = 2
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}




resource "aws_route_table" "private_route_table" {
    count = 2
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.main[count.index].id
    }

     tags = {
    Name = "${var.app_name} Private Route Table ${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_RT_association" {
  count = 2
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}