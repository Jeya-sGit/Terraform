variable "project_name" {
  description = "Prefix for all created resources (used for tagging and naming)."
  type        = string
  default     = "TerraformProject"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_availability_zone" {
  description = "The AWS Availability Zone to deploy resources in"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}
