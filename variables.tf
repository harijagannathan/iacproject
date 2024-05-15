variable "region" {
  description = "A region to use for the deployment"
  type        = string
  default     = "eu-north-1"
}

variable "config_file" {
  description = "AWS Config File"
  type        = string
}

variable "credential_file" {
  description = "AWS Credential File"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "availability_zones" {
  type        = map(string)
  description = "Availability Zones"
  default = {
    0 = "eu-north-1a",
    1 = "eu-north-1b"
  }
}

variable "max_instance_count" {
  type        = number
  description = "Maximum Number of EC2 instances in Auto Scaling Group"
}

variable "min_instance_count" {
  type        = number
  description = "Minimun Number of EC2 instances in Auto Scaling Group"
}

variable "desired_instance_count" {
  type        = number
  description = "Desired Number of EC2 instances in Auto Scaling Group"
}