# this  makes  vpc.id which is aws_vpc.app1.id
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block_range

  tags = {
    Name = "${var.name}-vpc"
    env = "${var.env}-env"
  }
}
