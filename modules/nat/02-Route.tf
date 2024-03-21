resource "aws_route_table" "private" {
  vpc_id = var.vpc

    route {
    cidr_block = var.public_cidr_block
    nat_gateway_id  = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name}-private"
    env = "${var.env}-env"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc

  route {
    cidr_block = var.public_cidr_block
    gateway_id = var.igw
  }

  

  tags = {
    Name = "${var.name}-public"
    env = "${var.env}-env"
  }
}

resource "aws_route_table_association" "private-eu-west-1a" {
  subnet_id      = var.private-eu-west-1a
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-1b" {
  subnet_id      = var.private-eu-west-1b
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-eu-west-1a" {
  subnet_id      = var.public-eu-west-1a
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-1b" {
  subnet_id      = var.public-eu-west-1b
  route_table_id = aws_route_table.public.id
}
