# aws_technical_challenge

## Introduction

This project aims to construct a proof-of-concept AWS environment managed via Terraform, emphasizing infrastructure as code. The design includes a VPC with four subnets across two availability zones, ensuring both internet-accessible and isolated subnets. The configuration features an EC2 instance with Red Hat Linux in one of the internet-facing subnets and an auto-scaling group across the private subnets, with a focus on automated Apache web server deployment. Additionally, an application load balancer will manage HTTP traffic, underpinned by security groups that define traffic rules. The project also incorporates an S3 bucket with lifecycle policies for efficient data management. Upon completion, documentation and the GitHub repository link will be sent to the recruitment point of contact, with an open channel for any immediate queries or issues.

## Architecture Diagram!

![Screenshot 2024-03-21 at 11 10 27 AM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/556324c0-9345-4f46-a885-23cd7de691b8)

##File Tree

![Screenshot 2024-03-21 at 12 06 03 PM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/f335c6ab-d827-42cb-a45f-de1ca153dd79)

##Base_modules 
The base modules form the foundational infrastructure for a scalable networking layer, encompassing VPC, subnets, private routes, IGWs, and EIPs.

`modules/base_modules/vpc`:
 
This module defines an AWS VPC resource, specifying its CIDR block and applying both predefined and dynamic tags for easy identification and management.

`modules/base_modules/sub`:

This module establishes an AWS subnet within a specified VPC, assigning it to an availability zone and defining its CIDR block. It also merges predefined tags with a dynamic "Name" tag for streamlined organization and identification.

`modules/base_modules/igw`:

This modules creates an Internet Gateway (IGW) which is a critical component that enables communication between instances in an AWS VPC and the internet. It allows resources within the VPC to send and receive traffic from the internet, facilitating both inbound and outbound internet connectivity.

`modules/base_modules/nat`:

This module creates an AWS NAT Gateway, positioned within a specified subnet and utilizing a designated Elastic IP allocation ID for external connectivity. It incorporates merged tags for efficient resource identification and management. The creation of this NAT Gateway is contingent on the prior establishment of an Internet Gateway (IGW), ensuring a structured network flow for instances in private subnets to access the internet securely.
 
`modules/base_modules/eip`:

This module provisions an AWS Elastic IP (EIP) within the VPC domain, applying merged tags for streamlined resource tracking and management. It assigns a static public IP address to ensure consistent internet access for associated resources.

`modules/base_modules/public_route`:

This module sets up an AWS Route Table for a specified VPC, defining a route that directs traffic from within the VPC to the internet via an Internet Gateway (IGW),which will be used in for the public subnets. It utilizes merged tags, including a custom "Name" tag, for effective resource identification and organization.

`modules/base_modules/private_route`:

This module creates an AWS Route Table associated with a specific VPC. It configures a route that allows traffic from the VPC to reach the internet through a NAT Gateway, using a specified CIDR block. The setup includes merged tags for improved resource identification, with a "Name" tag for easy reference.

## Modules 

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
