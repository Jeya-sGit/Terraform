variable "vpc_availability_zone" {
  type = list(string)
  description = "List of availability zones for the VPC."
  default = ["ap-south-1a", "ap-south-1b"]
} 

variable "vpc_cidr" {
  description = "Determine the starting IP and the size of your VPC using CIDR notation"
  type        = string
  default     = "10.0.0.0/16"
}
