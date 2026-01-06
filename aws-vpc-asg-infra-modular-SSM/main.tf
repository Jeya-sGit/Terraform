module "vpc" {
  source = "./modules/vpc"

  vpc_availability_zone = var.vpc_availability_zone
  cidr_block            = var.vpc_cidr
}

module "compute" {
  source             = "./modules/compute"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type = var.instance_type
  ami_id        = var.ami_id


  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.compute.alb_dns_name
}
