resource "aws_lb" "alb" {
  name               = "${var.name}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg-LB01]
  subnets            = [
    var.public-eu-west-1a,
    var.public-eu-west-1b,
  ]
  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-lb"
    env = "${var.env}-env"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group
  }
}
