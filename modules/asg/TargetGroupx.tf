resource "aws_lb_target_group" "tg" {
  name     = "${var.name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
  target_type = "instance"
  
  

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name = "${var.name}-tg"
    env = "${var.env}-env"
  }
}
