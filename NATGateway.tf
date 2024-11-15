resource "aws_nat_gateway" "main" {
  count = 2
  allocation_id = aws_eip.NAT_Gateway[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.app_name} NAT Gateway ${count.index + 1}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}