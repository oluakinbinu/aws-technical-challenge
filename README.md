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
