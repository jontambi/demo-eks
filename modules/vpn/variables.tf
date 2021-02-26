variable "customer_name" {
  type        = string
  description = "Name to be used customer resources as identifier."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where to create the cluster resources."
}

variable "environment" {
  description = "This is the environment where your cluster is deployed. qa, prod, or dev"
}

variable "vpn_connection_static_routes_destinations" {
  #  description = "List of CIDRs to be used as destination for static routes (used with `vpn_connection_static_routes_only = true`). Routes to destinations set here will be propagated to the routing tables of the subnets defined in `vpc_subnet_route_table_ids`."
  #  type        = list(any)
  #  default     = ["172.16.11.0/24", "10.20.0.0/16", "10.2.0.0/16", "172.21.21.0/24"]
}

variable "public_route_table_id" {
  description = "The ids of the VPC subnets for which routes from the VPN Gateway will be propagated."
}
variable "private_route_table_id" {
  description = "The ids of the VPC subnets for which routes from the VPN Gateway will be propagated."
}
