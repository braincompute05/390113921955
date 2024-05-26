variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19"]
}

variable "private_subnet_secondary_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["100.64.32.0/19", "100.64.64.0/19", "100.64.96.0/19"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "envirnoment" {
    type = string
    default = "dev"
}

variable "product-name" {
    type = string
    default = "eks-training01"
}

variable "node_group_instance_type" {
  description = "EC2 instance type for the EKS node group"
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of nodes in the EKS node group"
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes in the EKS node group"
  default     = 3
}

variable "min_size" {
  description = "Minimum number of nodes in the EKS node group"
  default     = 1
}

/*
variable "vpc_id" {
  description = "The VPC ID where EKS will be deployed"
}

variable "private_subnets" {
  description = "List of private subnets for the EKS cluster"
  type        = list(string)
}
*/