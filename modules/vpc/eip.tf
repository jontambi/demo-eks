resource "aws_eip" "eip_nat_1" {

  depends_on = [
    aws_internet_gateway.igw
  ]
}

#resource "aws_eip" "eip_nat_2" {

#  depends_on = [
#    aws_internet_gateway.igw
#  ]
#}
