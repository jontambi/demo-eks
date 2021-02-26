#
#  * Route Table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.vpc_name}-public-routeTable"

  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-${var.vpc_name}-private-routeTable"
  }
}

#resource "aws_route_table" "onpremise_route_table" {
#  vpc_id = aws_vpc.vpc.id
#
#  tags = {
#    Name = "${var.environment}-${var.vpc_name}-onpremise-routeTable"
#  }
#}

# Enabling the resources from public_subnet to access the Internet
# So we can access it later via SSH
resource "aws_route" "public_subnet_to_internet" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Enabling the resources from private_subnet to access the Onpremise Network
# So we can access to its resources
#resource "aws_route" "private_subnet_to_onpremise" {
#  route_table_id         = aws_route_table.onpremise_route_table.id
#  destination_cidr_block = "10.20.0.0/16"
#  gateway_id             = var.vpn_gateway_id
#}

resource "aws_route" "private_subnet_to_internet" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id         = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

#resource "aws_route_table_association" "onpremise_route_table_association" {
#  count          = length(var.private_subnets_cidr)
#  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
#  route_table_id = aws_route_table.onpremise_route_table.id
#}
