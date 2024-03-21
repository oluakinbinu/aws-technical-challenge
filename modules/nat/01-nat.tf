resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-eip"
    env = "${var.env}-env"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.public-eu-west-1a
  tags = {
    Name = "${var.name}-nat"
    env = "${var.env}-env"
  }

  depends_on = [var.igw]
}
