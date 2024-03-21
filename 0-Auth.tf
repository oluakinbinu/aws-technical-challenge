provider "aws" {
   region = var.default_region
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version ="~> 5.41.0"
    }
  }
}
