resource "aws_security_group" "sg-servers" {
  name        = "${var.name}-sg-servers"
  description = "${var.name}-sg-servers"
  vpc_id      = var.vpc

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr_block]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks =[var.public_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr_block]
  }

  tags = {
    Name = "${var.name}-sg-servers"
    env = "${var.env}-env"
  }

}


resource "aws_security_group" "sg-LB01" {
  name        = "${var.name}-sg-lb"
  description = "${var.name}-sg-lb"
  vpc_id      = var.vpc

  ingress {
    description = "MyHomePage"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks =[var.public_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =[var.public_cidr_block]
  }

  tags = {
    Name = "${var.name}-sg-lb"
    env = "${var.env}-env"
  }

}
