output "vpn_gateway_id" {
  value = aws_vpn_gateway.vpn_gateway.id
}

output "vpn_id" {
  value = aws_vpn_connection.main.id
}
