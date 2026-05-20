output "nat_instance_id" {
  value = module.ec2.instance_id
}

output "primary_network_interface_id" {
  value = module.ec2.primary_network_interface_id
}

output "is_nat_instance" {
  value = module.ec2.is_nat_instance
}
