resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.environment}-${var.customer_name}-vpn-gateway"
  }
}

resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 65000
  ip_address = "200.37.25.185"
  type       = "ipsec.1"

  tags = {
    Name = "${var.environment}-${var.customer_name}-customer-gateway"
  }
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "${var.environment}-${var.customer_name}-vpn-connection"
  }
}

resource "aws_vpn_connection_route" "connection_route" {
  count                  = length(var.vpn_connection_static_routes_destinations)
  destination_cidr_block = element(var.vpn_connection_static_routes_destinations, count.index)
  vpn_connection_id      = aws_vpn_connection.main.id
}

resource "aws_vpn_gateway_route_propagation" "private_subnets_vpn_routing" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = var.public_route_table_id
}
resource "aws_vpn_gateway_route_propagation" "onpremise_subnets_vpn_routing" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
  route_table_id = var.private_route_table_id
}

#https://github.com/terraform-aws-modules/terraform-aws-vpn-gateway/blob/v1.5.0/main.tf
#Multicloud VPN
#https://www.silect.is/blog/2020/1/28/creating-a-multi-cloud-vpn-with-terraform-between-aws-google-cloud-and-azure
#https://github.com/cloudposse/terraform-aws-vpn-connection
