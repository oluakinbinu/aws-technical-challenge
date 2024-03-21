# aws_technical_challenge



## Introduction

This project aims to construct a proof-of-concept AWS environment managed via Terraform, emphasizing infrastructure as code. The design includes a VPC with four subnets across two availability zones, ensuring both internet-accessible and isolated subnets. The configuration features an EC2 instance with Red Hat Linux in one of the internet-facing subnets and an auto-scaling group across the private subnets, with a focus on automated Apache web server deployment. Additionally, an application load balancer will manage HTTP traffic, underpinned by security groups that define traffic rules. The project also incorporates an S3 bucket with lifecycle policies for efficient data management. Upon completion, documentation and the GitHub repository link will be sent to the recruitment point of contact, with an open channel for any immediate queries or issues.

## Architecture Diagram!

![Screenshot 2024-03-21 at 11 10 27 AM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/556324c0-9345-4f46-a885-23cd7de691b8)

##File Tree

![Screenshot 2024-03-21 at 12 06 03 PM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/f335c6ab-d827-42cb-a45f-de1ca153dd79)


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


###  LB Module

###  ASG Module



These groups of modules is designed to deploy scalable AWS infrastructure components seamlessly. Each module targets a specific AWS resource, enabling a customized and efficient cloud environment.

S3 Buckets Module

`Purpose:` Configures Amazon S3 buckets for scalable and secure object storage.

`Usage:` Ideal for storing application data, backups, and static content.

EC2 Instances Module

`Purpose:` Provisions Amazon EC2 instances to offer scalable compute capacity.

`Usage:` Use to deploy applications, run backend services, or host databases dynamically.

Load Balancer (LB) Module

`Purpose:` Establishes a Load Balancer to distribute incoming application traffic across multiple EC2 instances.

`Usage:` Enhances application availability and fault tolerance.

Auto Scaling Group (ASG) Module

`Purpose:` Automates the scaling of EC2 instances, adjusting the number based on load.

`Usage:` Ensures efficient resource utilization and consistent application performance during varying loads.
