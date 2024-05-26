#Main VPC created with CIDR block 
resource "aws_vpc" "eks-training01" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Project EKS"
   Envirnoment = var.envirnoment
   Product = var.product-name
   "kubernetes.io/cluster/${var.cluster-name}" = "shared"
 }
}

#Mapping Secondary IP Range to VPC
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.eks-training01.id
  cidr_block = "100.64.0.0/16"
}

#creating Internet gateway attached to VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.eks-training01.id

  tags = {
    Name = "eks-training01_internet_gateway"
  }
}

#Creating three Public subnets below
resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.eks-training01.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Public_Subnet${count.index + 1}",
   "kubernetes.io/role/elb" = "1",
   "kubernetes.io/cluster/${var.cluster-name}" = "shared"
 }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks-training01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-routes"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count = 3

  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.eks-training01.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Private_Subnet${count.index + 1}"
   "kubernetes.io/role/internal-elb" = "1",
   "kubernetes.io/cluster/${var.cluster-name}" = "shared"
 }
}

resource "aws_subnet" "secondary_ip_private_subnets" {
 count      = length(var.private_subnet_secondary_cidrs)
 vpc_id     = aws_vpc.eks-training01.id
 cidr_block = element(var.private_subnet_secondary_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Secondary_Private_Subnet${count.index + 1}"
 }
}