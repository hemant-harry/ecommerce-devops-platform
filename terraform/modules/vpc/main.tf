resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr
  enable_dns_hostnames =  true 
  enable_dns_support = true


  tags =  {
    Name = "Ecommerce-vpc"
  }
}


# 2 public  subnet 

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ecommers-public-${count.index +1}"
    Tier =  "public"
  }
}

  

# 2  private subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id 
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  

  tags = {
    Name = "ecmmoers-private-${count.index +1}"
    Teie = "private"
  }
}



# Internet GateWay

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Ecommers-IGW"
  }

}

# EIP for Nat-Gateway

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "ecommers-nat-EIP"
  }
}


# Nat gateway

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id 

  tags = {
    Name = "ecommerce-Nat"
  }

  depends_on = [
             aws_internet_gateway.main
           ]
  

}





# Public  Route Table 

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "ecommerce-public-rt"
  }
}

# Private Route Table 

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "ecommerce-Private-rt"
  }
}


# Route table ----> Internet 

resource "aws_route" "public_internet" {
  route_table_id = aws_route_table.public.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id

}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

# public-subnet associate with public route table 

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id 
  route_table_id = aws_route_table.public.id
}



# private subnet associate with private route table 

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


