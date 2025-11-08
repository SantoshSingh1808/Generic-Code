variable "key_vaults" {
  description = "Map of key vault configurations"
  type = map(object({
    name                            = string
    location                        = string
    resource_group_name             = string
    sku_name                        = string
    enabled_for_deployment          = optional(bool)
    enabled_for_disk_encryption     = optional(bool)
    enabled_for_template_deployment = optional(bool)
    purge_protection_enabled        = optional(bool)
    public_network_access_enabled   = optional(bool)
    soft_delete_retention_days      = optional(number)
    rbac_authorization_enabled      = optional(bool)
    tags                           = optional(map(string))
    access_policies                = optional(list(object({
      tenant_id               = string
      object_id               = string
      application_id          = optional(string)
      certificate_permissions = optional(list(string))
      key_permissions        = optional(list(string))
      secret_permissions     = optional(list(string))
      storage_permissions    = optional(list(string))
    })))
    network_acls = optional(object({
      bypass                     = string
      default_action            = string
      ip_rules                  = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
  }))
}

variable "password" {
  description = "The password to store as a secret"
  type        = string
  sensitive   = true
}