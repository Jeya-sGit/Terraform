variable "vpc_id" {
  description = "The ID of the VPC where the Load Balancer and EC2 instances will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs for the Application Load Balancer (ALB)."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of Private Subnet IDs for the Auto Scaling Group (ASG) EC2 instances."
  type        = list(string)
}
variable "project_name" {
  description = "Prefix used for naming resources within the compute module."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to use in the Auto Scaling Group."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instances."
  type        = string
  # NOTE: The hardcoded ID 'ami-0d176f79571d18a8f' from your main.tf is placed here.
  # For production, it's better to use an aws_ami data source to fetch the latest.
  default     = "ami-0d176f79571d18a8f" 
}

variable "asg_min_size" {
  description = "The minimum number of EC2 instances the Auto Scaling Group should maintain."
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "The maximum number of EC2 instances the Auto Scaling Group can scale out to."
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "The number of EC2 instances that should be running immediately after deployment."
  type        = number
  default     = 2
}