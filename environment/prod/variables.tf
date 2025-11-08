variable "rg_details" {
  description = "Resource Group details to pass to module"
  type = map(object({
    name        = string
    location    = string
    managed_by  = optional(string)
    Environment = optional(string)
    Owner       = optional(string)
  }))
}

variable "storage_details" {
  type = map(object({
    name                     = string
    account_tier             = string
    account_replication_type = string

    account_kind                      = optional(string)
    provisioned_billing_model_version = optional(string)
    cross_tenant_replication_enabled  = optional(bool)
    access_tier                       = optional(string)
    edge_zone                         = optional(string)
    https_traffic_only_enabled        = optional(bool)
    min_tls_version                   = optional(string)
    allow_nested_items_to_be_public   = optional(bool)
    shared_access_key_enabled         = optional(bool)
    public_network_access_enabled     = optional(bool)
    default_to_oauth_authentication   = optional(bool)
    is_hns_enabled                    = optional(bool)
    nfsv3_enabled                     = optional(bool)
    large_file_share_enabled          = optional(bool)
    local_user_enabled                = optional(bool)
    queue_encryption_key_type         = optional(string)
    table_encryption_key_type         = optional(string)
    infrastructure_encryption_enabled = optional(bool)
    allowed_copy_scope                = optional(string)
    sftp_enabled                      = optional(bool)
    dns_endpoint_type                 = optional(string)
    tags                              = optional(map(string))

    network_rules = optional(map(object(
      {
        default_action = string
        bypass         = optional(list(string))
        ip_rules       = optional(list(string))
      }
    )), {})
  }))
}

variable "key_vaults_details" {
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
    tags                            = optional(map(string))
    access_policies = optional(list(object({
      tenant_id               = string
      object_id               = string
      application_id          = optional(string)
      certificate_permissions = optional(list(string))
      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      storage_permissions     = optional(list(string))
    })))
    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
  }))
}

variable "KeyVault_Secret_Value" {
  type        = string
  description = "Secret value to store in Azure Key Vault"
}

variable "networks_details" {
  description = "Map of virtual networks and their subnets & NSGs"
  type = map(object({
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnets = map(object({
      address_prefix = string
    }))
    tags = optional(map(string))
    security_rules = optional(list(object({
      name                       = string
      protocol                   = string
      access                     = string
      direction                  = string
      priority                   = number
      source_port_range           = optional(string)
      destination_port_range      = optional(string)
      source_address_prefix       = optional(string)
      destination_address_prefix  = optional(string)
      description                 = optional(string)
    })))
  }))
}

variable "vm_details" {
  description = "Map of VMs and their configuration"
  type = map(object({
    location                        = string
    resource_group_name             = string
    size                            = string
    admin_username                  = string
    disable_password_authentication = bool
    tags                            = optional(map(string))
    accelerated_networking          = optional(bool)
    ip_forwarding                   = optional(bool)
    ip_configurations = list(object({
      name                          = optional(string)
      primary                       = optional(bool)
      subnet                        = string
      private_ip_address_allocation = optional(string)
      private_ip_address_version    = optional(string)
      private_ip_address            = optional(string)
    }))
    enable_public_ip = optional(bool)
    os_disk = optional(object({
      caching              = optional(string)
      storage_account_type = optional(string)
      disk_size_gb         = optional(number)
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

variable "bastion_details" {
  description = "Map of Bastion Host configurations"
  type = map(object({
    location            = string
    resource_group_name = string
    enable_bastion      = bool
    vnet_name           = string
  }))
}