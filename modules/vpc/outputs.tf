output "project"                 { value = var.project }
output "env"                     { value = var.env     }

output "vpc_id"                  { value = aws_vpc.vpc.id }
output "vpc_cidr"                { value = var.vpc_cidr   }
output "availability_zones"      { value = local.azs      }

output "public_subnet_cidr"      { value = var.public_subnet_cidr   }
output "private_subnet_cidr"     { value = var.private_subnet_cidr  }
output "database_subnet_cidr"    { value = var.database_subnet_cidr }

output "public_subnet_ids"       { value = aws_subnet.public[*].id  }
output "private_subnet_ids"      { value = aws_subnet.private.*.id  }
output "database_subnet_ids"     { value = aws_subnet.database.*.id }

output "public_route_table_id"   { value = aws_route_table.public.id   }
output "private_route_table_id"  { value = aws_route_table.private.id  }
output "database_route_table_id" { value = aws_route_table.database.id }

# This returns entire 'internet_gateway' object, if you want only 'id' then use "aws_internet_gateway.internet_gateway.id"
output "internet_gateway"        { value = aws_internet_gateway.internet_gateway }

output "eks_cluster_name" {
  value = var.eks_cluster_name != null ? var.eks_cluster_name : "Normal VPC, It does not have EKS cluster name"
}
