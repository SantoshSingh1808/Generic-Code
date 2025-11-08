resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for pair in flatten([
      for vnet_name, vnet in var.virtual_networks : [
        for subnet_name, subnet in vnet.subnets : {
          key                 = "${vnet_name}-${subnet_name}"
          location            = vnet.location
          resource_group_name = vnet.resource_group_name
          tags                = lookup(vnet, "tags", {})
          rules               = lookup(subnet, "security_rules", [])
        }
        if !contains(local.reserved_subnets, subnet_name)
      ]
    ]) : pair.key => pair
  }

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = lookup(each.value, "tags", {})

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", [])
    content {
      name                         = security_rule.value.name
      description                  = lookup(security_rule.value, "description", null)
      protocol                     = security_rule.value.protocol
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      access                       = security_rule.value.access
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = var.virtual_networks
  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space
  tags                = lookup(each.value, "tags", {})
}

resource "azurerm_subnet" "subnet" {
  for_each = {
    for pair in flatten([
      for vnet_name, vnet in var.virtual_networks : [
        for subnet_name, subnet in vnet.subnets : {
          key                 = "${vnet_name}-${subnet_name}"
          vnet_name           = vnet_name
          resource_group_name = vnet.resource_group_name
          address_prefix      = subnet.address_prefix
        }
      ]
    ]) : pair.key => pair
  }

  name                 = split("-", each.key)[1]
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_name].name
  address_prefixes     = [each.value.address_prefix]
  depends_on           = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = {
    for k, v in azurerm_subnet.subnet :
    k => v
    if contains(keys(azurerm_network_security_group.nsg), k)
    && alltrue([for reserved in local.reserved_subnets : !can(regex(reserved, k))])
  }

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
