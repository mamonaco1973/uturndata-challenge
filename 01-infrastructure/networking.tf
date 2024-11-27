
# Create the main VPC for the tech challenge

resource "aws_vpc" "challenge-vpc" {
  cidr_block           = "10.0.0.0/24" # Use smallish CIDR block to play well with others
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "challenge-vpc"
  }
}

# Create the IPv4 internet gateway for public subnets

resource "aws_internet_gateway" "challenge-igw" {
  vpc_id = aws_vpc.challenge-vpc.id
  tags = {
    Name = "challenge-igw"
  }
}

# Create the route table and routes for public internet traffic

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.challenge-vpc.id
  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.challenge-igw.id
}

# Create the first public subnet

resource "aws_subnet" "challenge-subnet-1" {
  vpc_id                  = aws_vpc.challenge-vpc.id
  cidr_block              = "10.0.0.0/26" # Subnet A CIDR block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a" # Replace with your region's AZ
  tags = {
    Name = "challenge-subnet-1"
  }
}

# Create the second public subnet

resource "aws_subnet" "challenge-subnet-2" {
  vpc_id                  = aws_vpc.challenge-vpc.id
  cidr_block              = "10.0.0.64/26" # Subnet B CIDR block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b" # Replace with your region's AZ
  tags = {
    Name = "challenge-subnet-2"
  }
}

# Add the public routes to the new subnets

resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.challenge-subnet-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.challenge-subnet-2.id
  route_table_id = aws_route_table.public.id
}

# Create the DynamoDB Gateway VPC Endpoint

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.challenge-vpc.id
  service_name      = "com.amazonaws.us-east-2.dynamodb" # Adjust to your region
  vpc_endpoint_type = "Gateway"

  # Attach to the route table
  route_table_ids = [
    aws_route_table.public.id
  ]

  # Optional Policy for Endpoint
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "dynamodb:*",
      "Resource": "*"
    }
  ]
}
EOT
}
