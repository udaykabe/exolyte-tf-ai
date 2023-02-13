# Create a VPC for this app
resource "aws_vpc" "uat" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

# Create Internet Gateway for VPC
resource "aws_internet_gateway" "uat-gw" {
  vpc_id = aws_vpc.uat.id
}

# Create a route table to route non-local traffic via the Internet Gateway
resource "aws_route_table" "route-table-uat" {
  vpc_id = aws_vpc.uat.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.uat-gw.id
  }
}

# Create subnet for the UAT environment
resource "aws_subnet" "subnet-uat" {
  # creates a subnet
  cidr_block = "10.0.0.0/24"
  vpc_id     = aws_vpc.uat.id
  #availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  depends_on = [aws_internet_gateway.uat-gw]
}

resource "aws_eip" "ip-uat" {
  vpc = true

  instance = aws_spot_instance_request.test_worker.spot_instance_id
  #associate_with_private_ip = aws_spot_instance_request.test_worker.private_ip
  #network_interface = aws_network_interface.uat_nic.id

  depends_on = [
    aws_internet_gateway.uat-gw,
    aws_spot_instance_request.test_worker
  ]

  tags = {
    "Name" = "${var.app_name}-EIP"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet-uat.id
  route_table_id = aws_route_table.route-table-uat.id
}

resource "aws_network_interface" "uat_nic" {
  description = "UAT NIC"
  subnet_id   = aws_subnet.subnet-uat.id

  tags = {
    Name = "${var.app_name}-NIC"
  }
}
