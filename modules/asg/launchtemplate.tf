resource "aws_launch_template" "lt" {
  name_prefix   = "${var.name}-LT"
  image_id      = var.instance_ami
  instance_type = var.instance_type 
  ## key_name = "MyLinuxBox"

  block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_size = var.instance_root_device_size
    }
  }
  vpc_security_group_ids = [var.sg-servers]

    user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
      EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
    Name = "${var.name}-app"
    env = "${var.env}-env"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
