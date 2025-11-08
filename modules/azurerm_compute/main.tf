resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_public_ip" "pips" {
  for_each = {
    for vm_name, vm_details in var.virtual_machines :
    vm_name => vm_details if vm_details.enable_public_ip == true
  }

  name                = "${each.key}-pip"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  depends_on = [azurerm_public_ip.pips]
  for_each   = var.virtual_machines

  name                           = "${each.key}-nic"
  location                       = each.value.location
  resource_group_name            = each.value.resource_group_name
  tags                           = each.value.tags
  accelerated_networking_enabled = coalesce(each.value.accelerated_networking, false)
  ip_forwarding_enabled          = coalesce(each.value.ip_forwarding, false)

  ip_configuration {
    name                          = coalesce(each.value.ip_configurations[0].name, "${each.key}-ipconfig")
    primary                       = coalesce(each.value.ip_configurations[0].primary, true)
    subnet_id                     = local.flat_subnet_ids[each.value.ip_configurations[0].subnet]
    private_ip_address_allocation = coalesce(each.value.ip_configurations[0].private_ip_address_allocation, "Dynamic")
    private_ip_address_version    = coalesce(each.value.ip_configurations[0].private_ip_address_version, "IPv4")
    private_ip_address            = try(each.value.ip_configurations[0].private_ip_address, null)
    public_ip_address_id          = lookup(lookup(azurerm_public_ip.pips, each.key, {}), "id", null)
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.virtual_machines
  name                            = each.key
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = data.azurerm_key_vault_secret.secrets.value
  disable_password_authentication = each.value.disable_password_authentication
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    name                 = "${each.key}-osdisk-${random_string.suffix.result}"
    caching              = lookup(each.value.os_disk, "caching", "ReadWrite")
    storage_account_type = lookup(each.value.os_disk, "storage_account_type", "Standard_LRS")
    disk_size_gb         = lookup(each.value.os_disk, "disk_size_gb", 30)
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  computer_name = lookup(each.value, "computer_name", each.key)
  tags          = lookup(each.value, "tags", {})
  custom_data   = lookup(each.value, "userdata_script", null) != null ? base64encode(file("${path.module}/../../scripts/${each.value.userdata_script}")) : null

  boot_diagnostics {
    storage_account_uri = lookup(each.value, "boot_diagnostics_storage_uri", null)
  }

  lifecycle {
    ignore_changes        = [admin_password]
    create_before_destroy = true
  }
}
