#
#  * Subnets
#

# The private subnet where the Virtual Machine will live
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets_cidr)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  map_public_ip_on_launch = false

  tags = map(
    "Name", "${var.environment}-${var.vpc_name}-private-subnet-${count.index + 1}",
    "kubernetes.io/cluster/${var.environment}-${var.vpc_name}-cluster", "shared",
    "kubernetes.io/role/internal-elb", "1",
  )
}

# The public subnet where the Virtual Machine will live
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets_cidr)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = map(
    "Name", "${var.environment}-${var.vpc_name}-public-subnet-${count.index + 1}",
    "kubernetes.io/cluster/${var.environment}-${var.vpc_name}-cluster", "shared",
    "kubernetes.io/role/elb", "1",
  )

}
