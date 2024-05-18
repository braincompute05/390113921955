#Main VPC created with CIDR block 
resource "aws_vpc" "eks-training01" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Project EKS"
   Envirnoment = var.envirnoment
   Product = var.product-name
 }
}

#Mapping Secondary IP Range to VPC
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.eks-training01.id
  cidr_block = "100.64.0.0/16"
}

#Internet gateway attached to VPC
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
   Name = "Public_Subnet${count.index + 1}"
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

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "elastic_ip_nat_gateway" {
  count = 1

  vpc = true

  tags = {
    Name = "elastic_IP_nat_gateway"
  }
}


#Creating a NAT Gateway!
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_nat_gateway[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "eks-training01-nat-gateway1"
  }
}



#creating route table for nat gateway
resource "aws_route_table" "nat-Gateway-route" {
  depends_on = [
    aws_nat_gateway.nat_gateway
  ]

  vpc_id = aws_vpc.eks-training01.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}

# Creating an Route Table Association of the NAT Gateway route 
# table with the Private Subnet!
resource "aws_route_table_association" "Nat-Gateway-route-association" {
  depends_on = [
    aws_route_table.nat-Gateway-route
  ]

#  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  count          = 3
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)

# Route Table ID
  route_table_id = aws_route_table.nat-Gateway-route.id
}


resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.eks-training01.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 tags = {
   Name = "Private_Subnet${count.index + 1}"
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

/*
resource "aws_ec2_ipv4_cidr_block_association" "secondary_ip_address" {
  count      = length(var.private_subnet_secondary_cidrs)
  subnet_id      = aws_subnet.private_subnets[*].id
  ipv4_cidr_block = element(var.private_subnet_secondary_cidr, count.index)
}
*/