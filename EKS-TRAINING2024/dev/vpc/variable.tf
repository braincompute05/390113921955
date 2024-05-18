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