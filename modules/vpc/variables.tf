variable "environment" {
  description = "This is the environment where your cluster is deployed. qa, prod, or dev"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC cidr block"
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = string
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = string
  default     = true
}

variable "private_subnets_cidr" {
  description = "VPC Private Subnets"
}

variable "public_subnets_cidr" {
  description = "VPC Public Subnets"
}

#variable "vpn_gateway_id" {}

variable "map_public_ip_on_launch" {
  description = "Assign a public IP address to instances launched into these subnets"
  type        = string
}

variable "azs" {
  description = "Available zones"
}

#variable "vpn_connection_static_routes_destinations" {
#  description = "List of CIDRs to be used as destination for static routes (used with vpn_connection_static_routes_only = true). Routes to destinations set here will be propagated to the routing tables of the subnets defined in vpc_subnet_route_table_ids."
#  type        = list(any)
#}

