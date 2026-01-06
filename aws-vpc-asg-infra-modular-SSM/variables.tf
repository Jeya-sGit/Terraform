variable "aws_region" {
  description = "Deployment Region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix for all created resources (used for tagging and naming)."
  type        = string
  default     = "TerraformProject"
}

variable "vpc_cidr" {
  description = "The CIDR block for the custom VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_availability_zone" {
  description = "List of availability zones for the subnets. Must be in the specified region."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "instance_type" {
  description = "The type of EC2 instance to use in the Auto Scaling Group (e.g., t2.micro)."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instances."
  type        = string
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