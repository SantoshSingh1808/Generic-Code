output "vnet_ids" {
  description = "Map of all VNet IDs"
  value = {
    for key, vnet in azurerm_virtual_network.vnet :
    key => vnet.id
  }
}

output "subnet_ids" {
  value = { for s in azurerm_subnet.subnet : s.name => s.id }
}

output "network_security_group_ids" {
  description = "Map of NSG IDs"
  value = { for k, nsg in azurerm_network_security_group.nsg : k => nsg.id }
}

output "subnet_nsg_associations" {
  description = "NSG associations for subnets"
  value = { for k, v in azurerm_subnet_network_security_group_association.nsg_assoc : k => v.id }
}