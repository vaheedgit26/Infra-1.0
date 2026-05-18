# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-vpc-${var.vpc_count}"
    }
  )
}


# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-igw"
    }
  )
  depends_on = [aws_vpc.vpc]
}


# create public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr) > 0 ? length(var.public_subnet_cidr) : 0
  
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch


  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-public-subnet-${local.azs[count.index]}"
    },

    var.eks_cluster_name != null ? {
      "kubernetes.io/role/elb"                           = "1"          # For external facing ALB
      "kubernetes.io/cluster/${var.eks_cluster_name}"    = "owned"      # "shared"
    } : {}
  )

  depends_on = [aws_vpc.vpc]
}


# create private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0
  
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false


  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-private-subnet-${local.azs[count.index]}"
    },

    var.eks_cluster_name != null ? {
      "kubernetes.io/role/internal-elb"               = "1"       # For internal facing ALB
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"   # "shared"
    } : {}
  )
  depends_on = [aws_vpc.vpc]
}


# create database subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr) > 0 ? length(var.database_subnet_cidr) : 0
  
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.database_subnet_cidr[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-database-subnet-${local.azs[count.index]}"
    }
  )
  depends_on = [aws_vpc.vpc]
}


# create public route table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-public-RT"
    }
  )
  depends_on = [aws_subnet.public]
}


# create private route table 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-private-RT"
    }
  )
  depends_on = [aws_subnet.private]
}


# create database route table 
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.resource_name}-database-RT"
    }
  )
  depends_on = [aws_subnet.database]
}


# always add route seperately
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id

  depends_on = [aws_route_table.public]
}


# associate public route table to public subnet
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr) > 0 ? length(var.public_subnet_cidr) : 0
  
  subnet_id      = aws_subnet.public[count.index].id                      
  route_table_id = aws_route_table.public.id
  
   lifecycle {
    create_before_destroy = true  # Ensures new association is created before destroying the old one
  }
}

# ---------------------------------------------------------------------------------- #

# associate private route table to private subnet
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0

  subnet_id      = aws_subnet.private[count.index].id   #aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# associate database route table to database subnet
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr) > 0 ? length(var.database_subnet_cidr) : 0

  subnet_id      = aws_subnet.database[count.index].id    #aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
