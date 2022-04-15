resource "aws_security_group" "get-security-group-ec2" {
  name   = "get-security-group-ec2"
  vpc_id = aws_vpc.ec2_amazon_instance_vpc.id

  ingress {
    description = "Allow SSH"
    cidr_blocks = [local.self_ip_cidr]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [local.self_ip_cidr]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.self_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.base_tags, { Name = "get-security-group-ec2" })
}