locals {
  reserved_subnets = [
    "AzureBastionSubnet",
    "GatewaySubnet",
    "AzureFirewallSubnet",
    "AzureFirewallManagementSubnet",
    "RouteServerSubnet",
    "PrivateEndpointSubnet"
  ]
}
