# backend "s3" {
#   bucket         = "my-tf-state-bucket-TFProject-001" 
#   key            = "dev/web-app/terraform.tfstate"
#   region         = "ap-south-1"
#   encrypt        = true
#   dynamodb_table = "my-tf-lock-table"
# }


module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  vpc_availability_zone = var.vpc_availability_zone
}

module "compute" {
  source             = "./modules/compute"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids


  project_name  = var.project_name
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