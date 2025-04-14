resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-vpc"
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name                                           = "${var.cluster_name}-public-${var.availability_zones[count.index]}"
      "kubernetes.io/cluster/${var.cluster_name}"    = "shared"
      "kubernetes.io/role/elb"                       = "1"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.availability_zones))
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name                                           = "${var.cluster_name}-private-${var.availability_zones[count.index]}"
      "kubernetes.io/cluster/${var.cluster_name}"    = "shared"
      "kubernetes.io/role/internal-elb"              = "1"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-nat-eip-${var.availability_zones[count.index]}"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-nat-${var.availability_zones[count.index]}"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-public-rt"
    }
  )
}

resource "aws_route_table" "private" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-private-rt-${var.availability_zones[count.index]}"
    }
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
