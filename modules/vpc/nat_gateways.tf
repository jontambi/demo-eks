resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.eip_nat_1.id
  subnet_id     = "subnet-0538b74579e68bc81"
  #subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.environment}-${var.vpc_name}-natgateway-1"
  }
}

#resource "aws_nat_gateway" "nat_gateway_2" {
#  allocation_id = aws_eip.eip_nat_2.id
#  subnet_id     = aws_subnet.public_subnet[1].id
#
#  tags = {
#    Name = "${var.environment}-${var.vpc_name}-natgateway-2"
#  }
#}
