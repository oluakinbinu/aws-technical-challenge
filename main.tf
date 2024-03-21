
module "ec2_app" {
   source = "./modules/ec2"
    name = var.name
   env = var.env
   instance_size = var.instance_size
   instance_ami = var.instance_ami
   subnet   =  module.vpc.public-eu-west-1b
   instance_root_device_size = var.instance_root_device_size
   sg = module.sg.sg-servers
}

module "s3"{
   source = "./modules/s3"
   s3_name = var.s3_name
   s3_name2 = var.s3_name2
}
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

module "nat" {
   source = "./modules/nat"   
   name = var.name
   env = var.env
   vpc = module.vpc.vpc
   eip_option = var.eip_option
   igw = module.vpc.igw
   public-eu-west-1a = module.vpc.public-eu-west-1a
   public-eu-west-1b =  module.vpc.public-eu-west-1b
   private-eu-west-1a = module.vpc.private-eu-west-1a
   private-eu-west-1b = module.vpc.private-eu-west-1b
   public_cidr_block = var.public_cidr_block
}
module "sg" {
   source =  "./modules/sg"  
   name = var.name
   env = var.env
   vpc = module.vpc.vpc
   public_cidr_block = var.public_cidr_block
}
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
module "lb" {
   source =  "./modules/lb"  
   name = var.name
   env = var.env
   public-eu-west-1a = module.vpc.public-eu-west-1a
   public-eu-west-1b =  module.vpc.public-eu-west-1b
   sg-LB01 = module.sg.sg-LB01
   target_group = module.asg.target_group
}