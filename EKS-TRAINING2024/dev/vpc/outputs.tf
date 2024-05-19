output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.eks-training01.id
}

output "public_subnets" {
  description = "The ID of the public_subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
  description = "The ID of the private_subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "secondary_ip_private_subnets" {
  description = "The ID of the secondary_ip_private_subnets"
  value       = aws_subnet.secondary_ip_private_subnets[*].id
}

