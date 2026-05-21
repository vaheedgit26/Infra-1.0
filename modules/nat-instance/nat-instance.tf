module "ec2" {
  # source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/ec2"
  source = "../ec2"

  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  public_key_name             = var.public_key_name
  sg_ids                      = [module.nat_sg.sg_id]
  subnet_id                   = var.public_subnet_ID_to_launch_nat_instance  # "subnet-088e8443a70102e2a" #1a
  associate_public_ip_address = true
  is_nat_instance             = var.is_nat_instance  # creates NAT instance if true
  is_eip_required             = var.is_eip_required
  root_volume_size            = var.root_volume_size
  # user_data                 = file("${path.module}/nat_user_data.sh")

  vpc_cidr                    = var.vpc_cidr     # For NAT user data VPC_CIDR purpose

  project                     = var.project
  env                         = var.env
  common_tags                 = var.common_tags
}
