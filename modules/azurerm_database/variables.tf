variable "servers_dbs" {
  description = "Map of database servers and their configuration"
  type = map(object({
    resource_group_name            = string
    location                       = string
    administrator_login            = string
    version                        = string
    allow_access_to_azure_services = optional(bool, false)
    sku_name                       = optional(string)
    storage_mb                     = optional(number)
    backup_retention_days          = optional(number)
    geo_redundant_backup           = optional(string)
    tags                           = optional(map(string))
    databases = optional(list(object({
      name           = string
      charset        = optional(string)
      collation      = optional(string)
      max_size_bytes = optional(number)
      sku_name       = optional(string)
    })))
  }))
}


variable "key_vault_id" {
  type = string
}