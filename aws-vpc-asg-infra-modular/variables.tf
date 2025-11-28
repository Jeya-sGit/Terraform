# Project Naming
variable "project_name" {
  description = "Prefix for all created resources."
  type        = string
  default     = "TerraformProject"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1"
}
