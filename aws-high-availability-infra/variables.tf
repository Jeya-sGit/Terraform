variable "aws_region" {
  description = "Resource Deployment Region"
  type        = string
  default     = "ap-south-1"
}

variable "az_1" {
  description = "Resource Deployment Region's Availability Zone 1"
  type        = string
  default     = "ap-south-1a"
}

variable "az_2" {
  description = "Resource Deployment Region's Availability Zone 2"
  type        = string
  default     = "ap-south-1b"
}

variable "vpc_cidr" {
  description = "Determine the starting IP and the size of your VPC using CIDR notation"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "Determine the starting IP and the size of your Public_Subnet1 using CIDR notation"
  type        = string
  default     = "10.0.0.0/20"
}

variable "public_subnet2_cidr" {
  description = "Determine the starting IP and the size of your Public_Subnet1 using CIDR notation"
  type        = string
  default     = "10.0.16.0/20"
}

variable "private_subnet1_cidr" {
  description = "Determine the starting IP and the size of your Public_Subnet1 using CIDR notation"
  type        = string
  default     = "10.0.128.0/20"
}

variable "private_subnet2_cidr" {
  description = "Determine the starting IP and the size of your Public_Subnet1 using CIDR notation"
  type        = string
  default     = "10.0.144.0/20"
}

