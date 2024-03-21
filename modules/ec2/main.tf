#EC2 Instance
resource "aws_instance" "app" {

  ami           = var.instance_ami
  instance_type = var.instance_size
  subnet_id     = var.subnet
  vpc_security_group_ids = [var.sg]
    key_name = "RedHatVM"
    
    user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl start httpd
    systemctl enable httpd
      EOF
  )

  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name}-ec2"
    env = "${var.env}-env"
  }
 
} 




