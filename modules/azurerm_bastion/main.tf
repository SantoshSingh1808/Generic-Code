resource "azurerm_public_ip" "bastion-pip" {
  for_each            = { for k, v in var.bastion : k => v if v.enable_bastion == true }
  name                = "${each.key}-bastion-pip"
  location            = var.bastion[each.key].location
  resource_group_name = var.bastion[each.key].resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  for_each = { for k, v in var.bastion : k => v if v.enable_bastion == true }

  name                = "${each.key}-bastion"
  location            = var.bastion[each.key].location
  resource_group_name = var.bastion[each.key].resource_group_name

  ip_configuration {
    name = "configuration"
    subnet_id            = var.subnet_ids["AzureBastionSubnet"]
    public_ip_address_id = azurerm_public_ip.bastion-pip[each.key].id
  }
}
