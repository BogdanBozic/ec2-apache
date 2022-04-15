output "my-ip" {
  value = local.self_ip_cidr
}

output "public-ip" {
  value = aws_instance.get-apache-webserver.public_ip
}

output "public-dns" {
  value = aws_instance.get-apache-webserver.public_dns
}
