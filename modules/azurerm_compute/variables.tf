variable "virtual_machines" {
  description = "Map of VMs and their configuration"
  type = map(object({
    location                        = string
    resource_group_name             = string
    size                            = string
    admin_username                  = string
    disable_password_authentication = bool
    tags                            = optional(map(string), {})
    accelerated_networking          = optional(bool, false)
    ip_forwarding                   = optional(bool, false)
    ip_configurations = list(object({
      name                          = optional(string)
      primary                       = optional(bool, true)
      subnet                        = string
      private_ip_address_allocation = optional(string, "Dynamic")
      private_ip_address_version    = optional(string, "IPv4")
      private_ip_address            = optional(string)
    }))
    enable_public_ip = optional(bool, false)
    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Standard_LRS")
      disk_size_gb         = optional(number, 30)
    }))
    source_image_reference = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string)
    }))
    computer_name                = optional(string)
    custom_data                  = optional(string)
    boot_diagnostics_storage_uri = optional(string)
  }))
}


variable "subnet_ids" {
  description = "Map of subnet names to IDs from networking module"
  type        = map(string)
}

variable "key_vault_id" {
  type = string
}

variable "vnet_name" {
  type        = string
  description = "Parent virtual network name"
}
