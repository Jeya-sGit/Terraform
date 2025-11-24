variable "aws_region" {
  description = "Resource Deployment Region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "Determine the starting IP and the size of your VPC using CIDR notation"
  type        = string
  default     = "10.0.0.0/16"
}