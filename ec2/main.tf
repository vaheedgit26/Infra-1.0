resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.public_key_name
  vpc_security_group_ids      = var.sg_ids      # for multiple values        # [var.sg_id] --> for single value
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile

  # user_data                   = var.is_nat_instance ? file("${path.module}/nat_user_data.sh") : var.user_data

  user_data = var.is_nat_instance ? templatefile("${path.module}/nat_user_data.sh.tpl", { vpc_cidr = var.vpc_cidr }) : var.user_data
  
  # If 'source_dest_check = false' --> NAT Instance 
  # If 'source_dest_check = true'  --> Normal Instance
  source_dest_check           = var.is_nat_instance ? false : true

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.root_volume_size
    volume_type           = "gp2"

    tags = {
      Name          = local.root_volume_final_name 
      Project       = var.project
      Environment   = var.env
    }
  }

  timeouts {
      create = "10m"
      update = "10m"
      delete = "10m"
  }
  
  tags = merge(
      var.common_tags,
      var.ec2_tags,
      {
          Name = local.resource_final_name 
      }
    )
}

# Allocate EIP
resource "aws_eip" "nat" {
  count = ((var.is_nat_instance) && (var.is_eip_required)) ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# Associate EIP to Instance
resource "aws_eip_association" "nat" {
  # count = ((var.is_nat_instance) && (var.is_eip_required)) ? 1 : 0
  count = length(aws_eip.nat)

  instance_id   = aws_instance.ec2_instance.id
  allocation_id = aws_eip.nat[count.index].id
}
#########################################################################################################
# Create and attach EIP (Elastic IP) for NAT INSTANCE
#resource "aws_eip" "nat_instance_eip" {
#  count = ((var.is_nat_instance) && (var.is_eip_required)) ? 1 : 0

#  domain   = "vpc"
#  instance = aws_instance.ec2_instance.id
#  # network_interface = aws_instance.ec2_instance.primary_network_interface_id
#}
#########################################################################################################
