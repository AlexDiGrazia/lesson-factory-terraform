resource "aws_eip" "NAT_Gateway" {
  count = 2
  depends_on = [ aws_internet_gateway.internet_gateway ]
}