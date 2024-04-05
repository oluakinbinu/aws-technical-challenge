
variable default_region {
    type = string
    description = "infrastructure region"
    default = "eu-west-1"
}

variable "name" {
  description = "name of application"
  type        = string
  default     = "app1"
}

variable "env" {
  description = "name of Enivorment"
  type        = string
  default     = "dev"
}

variable "cidr_block_range" {
  description = "VPC CIDR Block Range"
  type        = string
  default     = "10.1.0.0/16"
}

variable "sub1" {
  description = "subnet 1"
  type        = string
  default     = "10.1.0.0/24"
}

variable "sub2" {
  description = "subnet 2"
  type        = string
  default     = "10.1.1.0/24"
}

variable "sub3" {
  description = "subnet 3"
  type        = string
  default     = "10.1.2.0/24"
}

variable "sub4" {
  description = "subnet 4"
  type        = string
  default     = "10.1.3.0/24"
}
variable "az1" {
  description = "eu-west-1a"
  type        = string
  default = "eu-west-1a"
}
variable "az2" {
  description = "eu-west-1b"
  type        = string
  default = "eu-west-1b"
}
variable "eip_option" {
  default = true
}
variable "public_cidr_block" {
  default = "0.0.0.0/0"
  
}
variable "instance_ami" {
    type = string
    description = "instance ami - RHEL_8.6-x86_64-SQL_2022_Standard-2022.11.18"
    #default = "ami-04b82270e2c61ea45"
    default = "ami-08e592fbb0f535224"
}
variable "instance_root_device_size" {
    description = "root device size"
    default = 20
}
variable instance_size {
    type = string
    description = "ec2 instance size"
    default = "t2.micro"
}
variable "device_name" {
      type = string
      default = "/dev/sda1"  
}
variable "s3_name" {
  type    = string
  default = "logs"
}

variable "s3_name2" {
  type    = string
  default = "images"
}

resource "random_id" "s3name" {
  byte_length = 8
}

locals {
  s3_name = "${var.s3_name}-${random_id.s3name.hex}"
  s3_name2 = "${var.s3_name2}-${random_id.s3name.hex}"
}
