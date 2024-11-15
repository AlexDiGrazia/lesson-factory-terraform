resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

   tags = {
    Name = "${var.app_name} Public Route Table"
    description = "tells all outbound traffic from public subnet to be routed to the Internet Gateway"
  }
}

resource "aws_route_table_association" "public_RT_associatoin" {
  count = 2
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}