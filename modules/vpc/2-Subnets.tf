#These are   for  public

resource "aws_subnet" "public-eu-west-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.sub1
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-subnet1"
    env = "${var.env}-env"
  }
}

resource "aws_subnet" "public-eu-west-1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.sub2
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-subnet2"
    env = "${var.env}-env"
  }
}


#these are for private
resource "aws_subnet" "private-eu-west-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.sub3
  availability_zone = var.az1

  tags = {
    Name = "${var.name}-subnet"
    env = "${var.env}-env3"
  }
}

resource "aws_subnet" "private-eu-west-1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.sub4
  availability_zone = var.az2

  tags = {
    Name = "${var.name}-subnet"
    env = "${var.env}-env4"
  }
}


