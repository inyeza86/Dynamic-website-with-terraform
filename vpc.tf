# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-VPC"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.environment}-IGW"
  }
}

# Create a Public Subnet AZ1
resource "aws_subnet" "my_public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-Public-Subnet-AZ1"
  }
}

# Create public subnet AZ2
# terraform aws create public subnet

resource "aws_subnet" "my_public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-Public-Subnet-AZ2"
  }
}

# Create public route table

resource "aws_route_table" "my_public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.environment}-Public-Route-Table"
  }
}

# Associate public subnet1 with public route table

resource "aws_route_table_association" "my_public_subnet1_association" {
  subnet_id      = aws_subnet.my_public_subnet1.id
  route_table_id = aws_route_table.my_public_route_table.id
}

# Associate public subnet2 with public route table

resource "aws_route_table_association" "my_public_subnet2_association" {
  subnet_id      = aws_subnet.my_public_subnet2.id
  route_table_id = aws_route_table.my_public_route_table.id
}

# Create  private App subnet AZ1
resource "aws_subnet" "my_private_app_subnet_az1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_app_subnet_az1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-Private-App-Subnet-AZ1"
  }
}

# Create Private App subnet AZ2
resource "aws_subnet" "my_private_app_subnet_az2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_app_subnet_az2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-Private-App-Subnet-AZ2"
  }
}

# Create DB private subnet AZ1
resource "aws_subnet" "my_private_data_subnet_az1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_data_subnet_az1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-Private-data-Subnet-AZ1"
  }
}

# Create DB private subnet AZ2
resource "aws_subnet" "my_private_data_subnet_az2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_data_subnet_az2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-Private-data-Subnet-AZ2"
  }
}


# Create Nat-gateway IN public subnet az1
# 1. create elastic ip for the NAT Gateway IN PUBLIC SUBNET AZ1

resource "aws_eip" "eip_for_nat_gateway_az1" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-EIP-AZ1"
  }

}
# 2. create nat-gateway IN public subnet az1

resource "aws_nat_gateway" "dev-nat-gateway-az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = aws_subnet.my_public_subnet1.id

  tags = {
    Name = "${var.environment}-NATGW-AZ1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.

  depends_on = [aws_internet_gateway.my_igw]
}

# create nat-gateway IN public subnet az2
# terraform aws create nat gateway
# 1. create elastic ip for the NAT Gateway IN PUBLIC SUBNET AZ2

resource "aws_eip" "eip_for_nat_gateway_az2" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-EIP-AZ2"
  }

}

# 2. create nat-gateway IN public subnet az2

resource "aws_nat_gateway" "dev-nat-gateway-az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = aws_subnet.my_public_subnet2.id

  tags = {
    Name = "${var.environment}-NATGW-AZ2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my_igw]
}

#create private route table1
# terraform aws create route table

resource "aws_route_table" "my_private_route_table-AZ1" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev-nat-gateway-az1.id
  }

  tags = {
    Name = "${var.environment}-Private-RT-AZ1"
  }
}

#create private route table2
# terraform aws create route table

resource "aws_route_table" "my_private_route_table-AZ2" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev-nat-gateway-az2.id
  }

  tags = {
    Name = "${var.environment}-Private-RT-AZ2"
  }
}

# Associate private app subnet az1 with private route table AZ1
# terraform aws associate subnet with route table

resource "aws_route_table_association" "my_private_subnet1_association" {
  subnet_id      = aws_subnet.my_private_app_subnet_az1.id
  route_table_id = aws_route_table.my_private_route_table-AZ1.id
}

# Associate private data subnet az1 with private route table AZ1
# terraform aws associate subnet with route table

resource "aws_route_table_association" "my_private_subnet2_association" {
  subnet_id      = aws_subnet.my_private_data_subnet_az1.id
  route_table_id = aws_route_table.my_private_route_table-AZ1.id
}
# Associate private app subnet az2 with private route table AZ2
# terraform aws associate subnet with route table

resource "aws_route_table_association" "my_private_subnet3_association" {
  subnet_id      = aws_subnet.my_private_app_subnet_az2.id
  route_table_id = aws_route_table.my_private_route_table-AZ2.id
}
# Associate private data subnet az2 with private route table AZ2
# terraform aws associate subnet with route table

resource "aws_route_table_association" "my_private_subnet4_association" {
  subnet_id      = aws_subnet.my_private_data_subnet_az2.id
  route_table_id = aws_route_table.my_private_route_table-AZ2.id
}


