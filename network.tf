data "http" "my-ip-address" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_vpc" "ec2_amazon_instance_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.base_tags, { Name = "GET ec2 amazon instance vpc" })
}

resource "aws_subnet" "ec2_amazon_instance_subnet" {
  vpc_id            = aws_vpc.ec2_amazon_instance_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = merge(local.base_tags, { Name = "GET ec2 amazon instance subnet" })
}

resource "aws_internet_gateway" "get-internet-gateway" {
  vpc_id = aws_vpc.ec2_amazon_instance_vpc.id
  tags   = local.base_tags
}

resource "aws_route_table" "get-route-table" {
  vpc_id = aws_vpc.ec2_amazon_instance_vpc.id
  tags   = local.base_tags
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.get-internet-gateway.id
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.ec2_amazon_instance_subnet.id
  route_table_id = aws_route_table.get-route-table.id
}