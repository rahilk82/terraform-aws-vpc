resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.enable_vpc_ipv6
  tags = merge(var.tags,  {"Name" = format("%s-%s-vpc", var.service_name, var.env)})
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_ipv4_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { "type" = "public" }, {"Name" = format("%s-%s-public-subnet-%s", var.service_name, var.env, element(var.availability_zones, count.index))})
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_ipv4_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { "type" = "private" }, {"Name" = format("%s-%s-private-subnent-%s", var.service_name, var.env, element(var.availability_zones, count.index))})
  depends_on              = [aws_vpc.vpc]
}

resource "aws_subnet" "database" {
  count                   = length(var.database_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.database_ipv4_subnets[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { "type" = "database" }, {"Name" = format("%s-%s-database-subnent-%s", var.service_name, var.env, element(var.availability_zones, count.index))})
  depends_on              = [aws_vpc.vpc]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id     = aws_vpc.vpc.id
  tags       = merge(var.tags, {"Name" = format("%s-%s-internet-gateway", var.service_name, var.env)})
  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = merge(var.tags, {"Name" = format("%s-%s-public-route-table", var.service_name, var.env)})
  depends_on = [aws_vpc.vpc, aws_internet_gateway.internet_gateway]
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
  depends_on     = [aws_vpc.vpc, aws_route_table.public, aws_internet_gateway.internet_gateway]
}

resource "aws_eip" "nat" {
  count      = var.enable_nat_gateway ? 1 : 0
  vpc        = true
  tags       = merge(var.tags, {"Name" = format("%s-%s-nat-eip", var.service_name, var.env)})
  depends_on = [aws_vpc.vpc, aws_route_table.public, aws_internet_gateway.internet_gateway, aws_route_table_association.public]
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = merge(var.tags, {"Name" = format("%s-%s-nat-gateway", var.service_name, var.env)})
  depends_on    = [aws_vpc.vpc, aws_internet_gateway.internet_gateway, aws_eip.nat]
}

resource "aws_route_table" "private_nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
  tags = merge(var.tags, {"Name" = format("%s-%s-private-nat-route-table", var.service_name, var.env)})
  depends_on = [aws_vpc.vpc, aws_subnet.private, aws_nat_gateway.nat_gw]
}

resource "aws_route_table_association" "private_nat" {
  count          = var.enable_nat_gateway && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_nat[0].id
  depends_on     = [aws_vpc.vpc, aws_subnet.private, aws_nat_gateway.nat_gw, aws_route_table.private_nat]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  count      = length(var.database_subnets) > 0 ? 1 : 0
  name       = "${var.service_name}-${var.env}-db-subnet-group"
  subnet_ids = aws_subnet.database.*.id
  tags       = merge(var.tags, {"Name" = format("%s-%s-db-subnet-group", var.service_name, var.env)})
}
