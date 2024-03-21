# aws_technical_challenge



## Introduction

This project aims to construct a proof-of-concept AWS environment managed via Terraform, emphasizing infrastructure as code. The design includes a VPC with four subnets across two availability zones, ensuring both internet-accessible and isolated subnets. The configuration features an EC2 instance with Red Hat Linux in one of the internet-facing subnets and an auto-scaling group across the private subnets, with a focus on automated Apache web server deployment. Additionally, an application load balancer will manage HTTP traffic, underpinned by security groups that define traffic rules. The project also incorporates an S3 bucket with lifecycle policies for efficient data management. Upon completion, documentation and the GitHub repository link will be sent to the recruitment point of contact, with an open channel for any immediate queries or issues.

## Architecture Diagram!

![Screenshot 2024-03-21 at 11 10 27 AM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/556324c0-9345-4f46-a885-23cd7de691b8)

##File Tree

![Screenshot 2024-03-21 at 12 06 03 PM](https://github.com/oluakinbinu/aws_technical_challenge/assets/154087956/f335c6ab-d827-42cb-a45f-de1ca153dd79)


## Modules

###  Virtual Private Cloud (VPC)

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

'modules/vpc/1-Subnets.tf'


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
