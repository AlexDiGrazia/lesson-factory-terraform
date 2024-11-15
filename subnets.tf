data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.app_name}_Public_Subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.app_name}_Private_Subnet_${count.index + 1}"
  }
}