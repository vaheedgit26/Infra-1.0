locals {
    resource_final_name = var.is_nat_instance ? "NAT-INSTANCE-${var.project}-${var.env}" : ( var.what_type_instance != null ? "${var.what_type_instance}-${var.project}-${var.env}-ec2" : "${var.project}-${var.env}-ec2")        # expense-dev-ec2
    root_volume_final_name = "${var.project}-${var.env}-ec2-root-volume"                   # expense-dev-ec2-root-volume
}
