data "aws_ami" "amazon_linux_2_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "get-apache-webserver" {
  ami                         = data.aws_ami.amazon_linux_2_ami.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.get-security-group-ec2.id]
  subnet_id                   = aws_subnet.ec2_amazon_instance_subnet.id
  key_name                    = aws_key_pair.get-ssh-key.key_name
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.get-private-key.private_key_pem
    host        = self.public_ip
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "./install_apache.sh"
    destination = "/tmp/install_apache.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "/tmp/install_apache.sh",
    ]
  }
}

resource "tls_private_key" "get-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "get-ssh-key" {
  public_key = tls_private_key.get-private-key.public_key_openssh
  key_name   = "get-ssh-key"
  tags       = local.base_tags
}

resource "aws_ec2_tag" "ec2-tags" {
  for_each    = merge(local.ec2_tags, local.ec2_tags)
  key         = each.key
  resource_id = aws_instance.get-apache-webserver.id
  value       = each.value
}
