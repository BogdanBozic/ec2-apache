locals {
  ec2_tags = {
    Name        = "test-ec2"
    Description = "Test instance"
    CostCenter  = "123456"
  }

  base_tags = {
    managed_by = "Terraform"
    owner      = "Bogdan"
  }

  self_ip_cidr = "${chomp(data.http.my-ip-address.body)}/32"
}
