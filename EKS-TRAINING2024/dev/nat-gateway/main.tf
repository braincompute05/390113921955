# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "elastic_ip_nat_gateway" {
  count = 1

  vpc = true

  tags = {
    Name = "elastic_ip_nat_gateway"
  }
}


#Creating a NAT Gateway!
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_nat_gateway[0].id
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]

  tags = {
    Name = "eks-training01-nat-gateway1"
  }
}



#creating route table for nat gateway
resource "aws_route_table" "nat-Gateway-route" {
  depends_on = [
    aws_nat_gateway.nat_gateway
  ]

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

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
  subnet_id      = element(data.terraform_remote_state.vpc.outputs.private_subnets, count.index)

# Route Table ID
  route_table_id = aws_route_table.nat-Gateway-route.id
}