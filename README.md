# aws_technical_challenge



## Introduction

This project aims to construct a proof-of-concept AWS environment managed via Terraform, emphasizing infrastructure as code. The design includes a VPC with four subnets across two availability zones, ensuring both internet-accessible and isolated subnets. The configuration features an EC2 instance with Red Hat Linux in one of the internet-facing subnets and an auto-scaling group across the private subnets, with a focus on automated Apache web server deployment. Additionally, an application load balancer will manage HTTP traffic, underpinned by security groups that define traffic rules. The project also incorporates an S3 bucket with lifecycle policies for efficient data management. Upon completion, documentation and the GitHub repository link will be sent to the recruitment point of contact, with an open channel for any immediate queries or issues.

## Architecture Diagram!

![Screenshot 2024-03-21 at 11 10 27 AM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/556324c0-9345-4f46-a885-23cd7de691b8)

##File Tree

![Screenshot 2024-03-21 at 12 06 03 PM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/8a8a8daf-91ac-42c5-9082-8ff35720a9f9)


## Result

application load balancer (ALB) that listens on TCP port 80 (HTTP) and forwards traffic to the ASG in subnets sub3 and sub4

![Screenshot 2024-03-21 at 6 50 36 PM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/72ac94fb-50bb-46a7-8fd0-02ae8b7ee09d)


## Modules

###  Virtual Private Cloud (VPC) Module

A VPC (Virtual Private Cloud) enables you to launch and manage a private, isolated section of the cloud where you can run resources in a network you define. It combines security with scalability and customization, allowing for secure hosting of applications, creation of complex network architectures, and connection to your on-premise networks.

'modules/vpc/1-VPC.tf'

This module defines an AWS Virtual Private Cloud (VPC) resource, which is a segment of a cloud network in AWS where you can launch AWS resources. The cidr_block attribute specifies the IP address range for the VPC, determined by the variable var.cidr_block_range. It also applies tags to the VPC for identification and organization, using variables for dynamic naming based on environment and a generic name prefix.

```hcl
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block_range

  tags = {
    Name = "${var.name}-vpc"
    env = "${var.env}-env"
  }
}
```

'modules/vpc/1-Subnets.tf'

This Terraform configuration defines and creates four subnets within a specified AWS VPC (Virtual Private Cloud). Two of these subnets are public (accessible from the internet), each in a different availability zone (eu-west-1a and eu-west-1b), with automatic public IP assignment enabled. The other two subnets are private (not directly accessible from the internet), also each in one of the two mentioned availability zones. Each subnet is assigned a CIDR block (IP address range) and tagged with a name and environment for identification and management purposes.

```hcl
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
```
'modules/vpc/3-IGW.tf'

This Terraform configuration creates an AWS Internet Gateway and associates it with a specific Virtual Private Cloud (VPC) identified by aws_vpc.vpc.id. The Internet Gateway facilitates communication between the VPC and the internet. It is tagged with a name and environment for easy identification and management.

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
    env = "${var.env}-env"
  }
}
```
'modules/vpc/var.tf'

Within the `'var.tf' file, individual variables are defined to serve as inputs for the modules.

```hcl
# Defines the overall CIDR block range for the VPC. This determines the IP address range available for all subnets within the VPC.
variable "cidr_block_range" {}

# Defines the CIDR block for the first subnet. This is typically a subset of the VPC's CIDR block, designated for specific use within the VPC.
variable "sub1" {}

# Defines the CIDR block for the second subnet, another subset of the VPC's CIDR block, potentially serving a different purpose or hosting different resources compared to sub1.
variable "sub2" {}

# Defines the CIDR block for the third subnet. This may be configured for a specific use case within the VPC, separate from the first two subnets.
variable "sub3" {}

# Defines the CIDR block for the fourth subnet. Like the others, this is a subset of the VPC's CIDR block, designated for its unique role within the VPC.
variable "sub4" {}

# Specifies the name to be used in naming resources. This allows for easier identification and management of resources within AWS.
variable "name" {}

# Defines the environment tag for resources. This is used to differentiate resources across various deployment environments (e.g., development, testing, production).
variable "env" {}

# Identifies the first availability zone in which resources may be deployed. Availability zones are isolated locations within data center regions from which public cloud services originate and operate.
variable "az1" {}

# Identifies the second availability zone for deploying resources, providing an option for redundancy and high availability across physical locations within a region.
variable "az2" {}

```

'modules/vpc/output.tf'

The 'output.tf'generates outputs, such as VPC and subnet IDs, which are referenced in other configurations to enhance module reusability, enabling seamless integration with autoscaling groups and load balancers modules.

```hcl
# Outputs the ID of the public subnet in the eu-west-1a availability zone. Used for referencing this subnet in other configurations.
output "public-eu-west-1a" {
  value = aws_subnet.public-eu-west-1a.id
}

# Outputs the ID of the public subnet in the eu-west-1b availability zone. Allows for identification and use in subsequent configurations.
output "public-eu-west-1b" {
  value = aws_subnet.public-eu-west-1b.id
}

# Outputs the ID of the private subnet in the eu-west-1a availability zone. Essential for referencing the subnet in further cloud infrastructure setups.
output "private-eu-west-1a" {
  value = aws_subnet.private-eu-west-1a.id
}

# Outputs the ID of the private subnet in the eu-west-1b availability zone. Enables this subnet's ID to be utilized in additional configurations.
output "private-eu-west-1b" {
  value = aws_subnet.private-eu-west-1b.id
}

# Outputs the ID of the VPC. This is crucial for linking various resources and services within the same Virtual Private Cloud.
output "vpc"{
  value = aws_vpc.vpc.id
}

# Outputs the ID of the Internet Gateway. This ID is important for configurations that require internet connectivity through this gateway.
output "igw"{
  value = aws_internet_gateway.igw.id
}

```

###  Security Group Module

In the security group module, a security group will be established for the server layer, enabling HTTPS access through port 80 from a specified CIDR block. For demonstration purposes, 0.0.0.0/16 will be used, though it is recommended to utilize corporate IP addresses in production environments for enhanced security.

'modules/sg/sg.tf'
```hcl

# This resource defines a security group for server layer within the specified VPC.
resource "aws_security_group" "sg-servers" {
  # Names the security group using a variable for easy identification.
  name        = "${var.name}-sg-servers"
  # Provides a description for the security group, again using a variable for clarity and consistency.
  description = "${var.name}-sg-servers"
  # Associates the security group with a VPC specified by a variable.
  vpc_id      = var.vpc

  # Defines an ingress rule for HTTP traffic.
  ingress {
    description = "MyHomePage"          # A description of the ingress rule for clarity.
    from_port   = 80                    # The starting port of the range; here, it specifies port 80 for HTTP.
    to_port     = 80                    # The ending port of the range; matching from_port as it's a single port.
    protocol    = "tcp"                 # Specifies the protocol used, in this case, TCP for HTTP traffic.
    cidr_blocks = [var.public_cidr_block] # The CIDR blocks from which traffic is allowed, specified by a variable.
  }

  # Defines an ingress rule for SSH access.
  ingress {
    description = "SSH"                 # A description of the ingress rule for SSH access.
    from_port   = 22                    # The starting port for SSH traffic.
    to_port     = 22                    # The ending port for SSH traffic, same as from_port for a single port.
    protocol    = "tcp"                 # Specifies the protocol, TCP, for SSH traffic.
    cidr_blocks = [var.public_cidr_block] # The CIDR blocks allowed for SSH access, specified by a variable.
  }
}
```

'modules/sg/var.tf'

Variables defined in the 'var.tf' file serve as inputs for configuring the security groups.

```hcl

# Defines a unique identifier or name for resources, facilitating easier identification and management within AWS.
variable "name" {}

# Specifies the environment (e.g., development, staging, production) to which the resources belong, aiding in resource organization and management.
variable "env" {}

# Holds the ID of the VPC (Virtual Private Cloud) within which the resources will be created, ensuring proper network isolation and segmentation.
variable "vpc" {}

# Contains the CIDR block for public access, determining the IP address range that can interact with certain resources, particularly for defining ingress rules.
variable "public_cidr_block" {}
```

'modules/sg/output.tf'

The 'output.tf'generates outputs, such as security group IDs, which are referenced in other configurations to enhance module reusability,

```hcl
# Output declaration for the server security group ID. This allows other configurations to reference the security group's unique identifier.
output "sg-servers" {
    value = aws_security_group.sg-servers.id
}

# Output declaration for the load balancer security group ID. Enables the ID to be referenced in subsequent configurations, facilitating integration with other AWS resources.
output "sg-LB01" {
    value = aws_security_group.sg-LB01.id
}
```

###  EC2 Module

EC2 Instances Module

`Purpose:` Provisions Amazon EC2 instances to offer scalable compute capacity.

`Usage:` Use to deploy applications, run backend services, or host databases dynamically.

'modules/ec2/main.tf'

```hcl
# Define an AWS EC2 instance resource named 'app'.
resource "aws_instance" "app" {
  # The Amazon Machine Image (AMI) ID to use for the instance. This determines the OS and initial state of the instance.
  ami           = var.instance_ami

  # The type of instance to start. This defines the hardware of the host computer used for your instance.
  instance_type = var.instance_size

  # The ID of the subnet to launch the instance in. Determines the networking and location within the AWS infrastructure.
  subnet_id     = var.subnet

  # A list of security group IDs to assign to the instance for controlling access to and from the instance.
  vpc_security_group_ids = [var.sg]

  # The key name of the Key Pair to use for the instance; this enables SSH access to the instance.
  key_name = "RedHatVM"
  
  # User data script to run on instance startup. This script updates the system, installs, starts, and enables the Apache web server.
  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF
  )

  # Configuration block for the root block device, or the instance's primary storage device.
  root_block_device {
    volume_size = var.instance_root_device_size # The size of the volume in gigabytes.
    volume_type = "gp3" # The type of volume. gp3 is a type of SSD.
  }

  # A map of tags to assign to the resource. Useful for naming and organizing resources within AWS.
  tags = {
    Name = "${var.name}-ec2"
    env = "${var.env}-env"
  }
}
```

###  ASG Module

`Purpose:` Automates the scaling of EC2 instances, adjusting the number based on load.

`Usage:` Ensures efficient resource utilization and consistent application performance during varying loads.

The autoscaling module is structured across three distinct files: autoscaling group, target groups, and launch template.

'modules/asg/AutoScalingGroup.tf'
```hcl
# Resource definition for an AWS Auto Scaling Group.
resource "aws_autoscaling_group" "asg" {
  name_prefix           = "${var.name}-auto-scaling-group" # Name prefix for the auto scaling group.
  min_size              = 3 # Minimum number of instances in the group.
  max_size              = 15 # Maximum number of instances in the group.
  desired_capacity      = 6 # Desired number of instances in the group.
  vpc_zone_identifier   = [var.private-eu-west-1a, var.private-eu-west-1b] # Subnets for the instances.
  health_check_type     = "ELB" # Type of health check.
  health_check_grace_period = 300 # Time before health check starts.
  force_delete          = true # Force delete new instances upon ASG deletion.
  target_group_arns     = [aws_lb_target_group.tg.arn] # Target group for load balancing.

  # Configuration for the launch template.
  launch_template {
    id      = aws_launch_template.lt.id # Launch template ID.
    version = "$Latest" # Version of the launch template to use.
  }

  # Metrics to be collected.
  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]

  # Initial lifecycle hook for instance launching.
  initial_lifecycle_hook {
    name                  = "instance-protection-launch"
    lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
    default_result        = "CONTINUE"
    heartbeat_timeout     = 60
    notification_metadata = "{\"key\":\"value\"}"
  }

  # Initial lifecycle hook for instance terminating.
  initial_lifecycle_hook {
    name                  = "scale-in-protection"
    lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
    default_result        = "CONTINUE"
    heartbeat_timeout     = 300
  }

  # Tags to propagate to each instance at launch.
  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.env}-env"
    propagate_at_launch = true
  }
}

# Defines an Auto Scaling Policy for CPU utilization.
resource "aws_autoscaling_policy" "scaling_policy" {
  name                   = "${var.name}-cpu-target" # Policy name.
  autoscaling_group_name = aws_autoscaling_group.asg.name # Associated ASG.

  policy_type = "TargetTrackingScaling" # Policy type for target tracking.
  estimated_instance_warmup = 120 # Warm-up time for new instances.

  # Configuration for tracking CPU utilization.
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 75.0 # Target CPU utilization percentage.
  }
}

# Attaches the Auto Scaling group to a target group for load balancing.
resource "aws_autoscaling_attachment" "app1_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}

```

'modules/asg/launchtemplate.tf'
```hcl
# AWS Launch Template Configuration
resource "aws_launch_template" "lt" {
  # Defines a prefix for the launch template name, incorporating a variable for dynamic naming.
  name_prefix   = "${var.name}-LT"

  # Specifies the AMI ID and instance type for instances launched using this template.
  image_id      = var.instance_ami
  instance_type = var.instance_type 

  # Optional: Specify the key name for SSH access to the instances.

  # Configures the block device mapping for the instance's root volume.
  block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_size = var.instance_root_device_size
    }
  }

  # Associates the launch template with specific security groups.
  vpc_security_group_ids = [var.sg-servers]

  # User data script to automate software installation and setup upon instance launch.
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF
  )

  # Applies tagging specifications to instances launched from this template for organization and tracking.
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-app"
      env = "${var.env}-env"
    }
  }

  # Ensures that a new launch template version is created before the old one is destroyed during updates.
  lifecycle {
    create_before_destroy = true
  }
}

```

'modules/asg/TargetGroupx.tf'
```hcl
resource "aws_launch_template" "lt" {
  # Sets a prefix for the launch template name, dynamically appending the provided variable.
  name_prefix   = "${var.name}-LT"

  # Specifies the AMI ID for instances launched from this template.
  image_id      = var.instance_ami

  # Defines the instance type for instances to be launched.
  instance_type = var.instance_type
  
  # Uncomment to specify a key pair for SSH access.
  ## key_name = "MyLinuxBox"

  # Configures block device mappings for the root device.
  block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_size = var.instance_root_device_size
    }
  }

  # Specifies the security groups that instances will belong to.
  vpc_security_group_ids = [var.sg-servers]

  # User data script to run commands on instance launch. Here, it updates and installs an HTTP server.
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF
  )

  # Applies tags to instances launched from this template.
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-app"
      env  = "${var.env}-env"
    }
  }

  # Ensures that a new launch template is created before destroying the old one during updates.
  lifecycle {
    create_before_destroy = true
  }
}

```

###  LB Module

`Purpose:` Establishes a Load Balancer to distribute incoming application traffic across multiple EC2 instances.

`Usage:` Enhances application availability and fault tolerance.

'modules/lb/LoadBalancer.tf'

```hcl
# Defines an AWS Application Load Balancer (ALB) resource.
resource "aws_lb" "alb" {
  # Name of the load balancer, incorporating a variable for dynamic naming.
  name               = "${var.name}-load-balancer"

  # Specifies that the load balancer is internet-facing rather than internal.
  internal           = false

  # Sets the load balancer type to 'application', suitable for HTTP/HTTPS traffic.
  load_balancer_type = "application"

  # Associates the load balancer with security groups defined by a variable.
  security_groups    = [var.sg-LB01]

  # Assigns the load balancer to subnets, allowing it to receive traffic from these locations.
  subnets            = [
    var.public-eu-west-1a,
    var.public-eu-west-1b,
  ]

  # Disables deletion protection, allowing the load balancer to be deleted without additional steps.
  enable_deletion_protection = false

  # Applies tags to the load balancer for identification and organization.
  tags = {
    Name = "${var.name}-lb"
    env  = "${var.env}-env"
  }
}

# Defines a listener for the AWS Application Load Balancer.
resource "aws_lb_listener" "http" {
  # Associates the listener with the previously defined ALB using its Amazon Resource Name (ARN).
  load_balancer_arn = aws_lb.alb.arn

  # Configures the listener to accept traffic on port 80, standard for HTTP.
  port              = 80

  # Sets the protocol for the listener to HTTP.
  protocol          = "HTTP"

  # Defines the default action for the listener. In this case, forwarding traffic to a target group specified by a variable.
  default_action {
    type             = "forward"
    target_group_arn = var.target_group
  }
}
```


###  S3 Module

S3 Buckets Module

`Purpose:` Configures Amazon S3 buckets for scalable and secure object storage.

`Usage:` Ideal for storing application data, backups, and static content.

'modules/s3/01-S3.tf'

```hcl
# Creates an AWS S3 bucket with a specific name for storing static project files. Tags the bucket for easy identification.
resource "aws_s3_bucket" "s3" {
  bucket = local.s3_name  # Bucket name from local variables

  tags = {
    Name        = "static-project"  # Name tag for the bucket
    Environment = "Dev"             # Environment tag, indicating this bucket is used in development
  }
}

# Creates a second AWS S3 bucket with another specific name, following the same tagging convention as the first.
resource "aws_s3_bucket" "s32" {
  bucket = local.s3_name2  # Second bucket name from local variables

  tags = {
    Name        = "static-project"  # Same naming convention for consistency
    Environment = "Dev"             # Indicates this is also a development environment resource
  }
}

# Configures a lifecycle rule for the first S3 bucket to automatically expire (delete) all files in a specific folder after 90 days.
resource "aws_s3_bucket_lifecycle_configuration" "l1" {
  bucket = local.s3_name  # Applies to the first bucket

  rule {
    status = "Enabled"  # Rule is active
    id     = "expire_all_files"  # Identifies the purpose of the rule
    expiration {
        days = 90  # Number of days after which files are expired
    }
    filter {
      and {
        prefix = "log/"  # Targets files in the "log/" folder

        tags = {
          rule      = "log"
          autoclean = "true"  # Tags to further specify and identify rule application
        }
      }
    }
  }
}

# Sets up a lifecycle configuration for the second S3 bucket to transition files to the GLACIER storage class after 90 days, optimizing for cost and access patterns.
resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
   bucket = local.s3_name2  # Applies to the second bucket

   rule {
     id = "images"  # Identifies the rule focus on image files
     status = "Enabled"  # Rule is active

     transition {
       days          = 90  # Timeframe after which to transition files
       storage_class = "GLACIER"  # Moves files to colder storage for cost efficiency
     }
   }
}
```

'modules/s3/var.tf'


Variables defined in the 'var.tf' file serve as inputs for configuring the s3 bucket configurations
```hcl
# Define a variable for the first S3 bucket name. You can uncomment the default line to provide a default name.
variable "s3_name" {
  type    = string
  # default = "logs"
}

# Define a variable for the second S3 bucket name. The default name can be set by uncommenting the default line.
variable "s3_name2" {
  type    = string
  # default = "images"
}

# Create a random ID to ensure unique bucket names, avoiding conflicts. The length of the ID is set to 8 bytes.
resource "random_id" "s3name" {
  byte_length = 8
}

# Using locals to construct unique S3 bucket names by appending the generated random ID to the variable values.
locals {
  s3_name = "${var.s3_name}-${random_id.s3name.hex}"
  s3_name2 = "${var.s3_name2}-${random_id.s3name.hex}"
}
```


#main.tf

To ensure cohesive deployment of the infrastructure, a main.tf file was created, aggregating and referencing all established variables.

```hcl
# EC2 Instance Module: Configures and launches an EC2 instance with specified attributes such as name, environment, instance size, AMI, subnet, root device size, and security group.
module "ec2_app" {
   source = "./modules/ec2"
   name = var.name
   env = var.env
   instance_size = var.instance_size
   instance_ami = var.instance_ami
   subnet = module.vpc.public-eu-west-1b
   instance_root_device_size = var.instance_root_device_size
   sg = module.sg.sg-servers
}

# S3 Module: Sets up two S3 buckets with specified names.
module "s3" {
   source = "./modules/s3"
   s3_name = var.s3_name
   s3_name2 = var.s3_name2
}

# VPC Module: Creates a Virtual Private Cloud with a specified CIDR block range and sets up four subnets.
module "vpc" {
   source = "./modules/vpc"   
   cidr_block_range = var.cidr_block_range
   sub1 = var.sub1
   sub2 = var.sub2
   sub3 = var.sub3
   sub4 = var.sub4
   name = var.name
   env = var.env
   az1 = var.az1
   az2 = var.az2
}

# NAT Module: Configures a NAT gateway with associated Elastic IP, Internet Gateway, and subnets for both public and private network access.
module "nat" {
   source = "./modules/nat"   
   name = var.name
   env = var.env
   vpc = module.vpc.vpc
   eip_option = var.eip_option
   igw = module.vpc.igw
   public-eu-west-1a = module.vpc.public-eu-west-1a
   public-eu-west-1b = module.vpc.public-eu-west-1b
   private-eu-west-1a = module.vpc.private-eu-west-1a
   private-eu-west-1b = module.vpc.private-eu-west-1b
   public_cidr_block = var.public_cidr_block
}

# Security Group Module: Creates security groups within the VPC for managing access to resources.
module "sg" {
   source =  "./modules/sg"  
   name = var.name
   env = var.env
   vpc = module.vpc.vpc
   public_cidr_block = var.public_cidr_block
}

# Auto Scaling Group Module: Sets up an auto-scaling group for EC2 instances, including configuration for instance type, AMI, security groups, and networking.
module "asg" {
   source =  "./modules/asg"  
   instance_ami = var.instance_ami
   instance_type = var.instance_size
   device_name = var.device_name
   instance_root_device_size = var.instance_root_device_size
   sg-LB01 = module.sg.sg-LB01
   sg-servers = module.sg.sg-servers
   name = var.name
   env = var.env
   vpc = module.vpc.vpc
   private-eu-west-1a = module.vpc.private-eu-west-1a
   private-eu-west-1b = module.vpc.private-eu-west-1b
}

# Load Balancer Module: Configures a load balancer with specified settings, including security groups, target groups, and associated subnets.
module "lb" {
   source =  "./modules/lb"  
   name = var.name
   env = var.env
   public-eu-west-1a = module.vpc.public-eu-west-1a
   public-eu-west-1b = module.vpc.public-eu-west-1b
   sg-LB01 = module.sg.sg-LB01
   target_group = module.asg.target_group
}

```


## Referenced used 
https://access.redhat.com/solutions/15356#us_west_1_rhel9
https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
https://access.redhat.com/documentation/en-us/jboss_enterprise_application_platform/6.3/html/administration_and_configuration_guide/install_the_apache_httpd_in_red_hat_enterprise_linux_with_jboss_eap_6_rpm
https://stackoverflow.com/questions/63979469/terraform-code-to-delete-objects-in-the-bucket-after-10-days
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
