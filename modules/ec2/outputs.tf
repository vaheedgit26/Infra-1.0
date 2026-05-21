# returns entire ec2_instance object which contains private_ip, public_ip, instance_id ... etc
#output "ec2_instance" {
#  value = aws_instance.ec2_instance
#}

output "network" {
  value = {
    public_ip  = aws_instance.ec2_instance.public_ip
    private_ip = aws_instance.ec2_instance.private_ip
    subnet_id  = aws_instance.ec2_instance.subnet_id
  }
}

output "security_group_ids" {
  value = aws_instance.ec2_instance.vpc_security_group_ids
}

output "instance_id" {
  value = aws_instance.ec2_instance.id
}

output "primary_network_interface_id" {
  value = aws_instance.ec2_instance.primary_network_interface_id
}

output "is_nat_instance" {
  value = var.is_nat_instance
}
