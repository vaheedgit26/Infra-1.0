# Route table entry to forward traffic from private instances to NAT instance (This is the main step)
resource "aws_route" "private_outbound_nat_route" {
  route_table_id         =  var.private_route_table_id                    # module.vpc.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   =  module.ec2.primary_network_interface_id       # aws_instance.nat_instance.primary_network_interface_id
}

# Route table entry to forward traffic from database instances to NAT instance (This is the main step)
resource "aws_route" "database_outbound_nat_route" {
  route_table_id         =  var.database_route_table_id                   # module.vpc.database_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   =  module.ec2.primary_network_interface_id       # aws_instance.nat_instance.primary_network_interface_id
}
