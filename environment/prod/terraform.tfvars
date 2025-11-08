rg_details = {
  rg1 = {
    name        = "rg-healthcheck-dev"
    location    = "Malaysia West"
    managed_by  = "DevOps Team"
    Environment = "dev"
    Owner       = "Santosh"
  }
}

storage_details = {
  rg1 = {
    name                             = "santustorage433"
    account_tier                     = "Standard"
    account_replication_type         = "LRS"
    account_kind                     = "BlobStorage"
    cross_tenant_replication_enabled = true
    access_tier                      = "Hot"
    network_rules = {
      rule1 = {
        default_action = "Deny"
        bypass         = ["AzureServices"]
        ip_rules       = ["152.59.142.117"]
      }
    }
  }
}

key_vaults_details = {
  kv1 = {
    name                        = "kv2-healthcheck-dev"
    location                    = "Malaysia West"
    resource_group_name         = "rg-healthcheck-dev"
    sku_name                    = "standard"
    enabled_for_disk_encryption = true
    purge_protection_enabled    = true
    rbac_authorization_enabled  = true
    soft_delete_retention_days  = 7,

    network_acls = {
      bypass                     = "AzureServices"
      default_action             = "Deny"
      ip_rules                   = ["152.59.142.117"]
      virtual_network_subnet_ids = []
    }

    tags = {
      Environment = "dev"
      Owner       = "DevOps Team"
    }
  }
}
KeyVault_Secret_Value = "Santosh@1234"

networks_details = {
  vnet1 = {
    resource_group_name = "rg-healthcheck-dev"
    location            = "Malaysia West"
    address_space       = ["10.0.0.0/16"]
    tags = {
      environment = "dev"
    }

    subnets = {
      frontend_subnet = {
        address_prefix = "10.0.1.0/24"
        security_rules = [
          {
            name                       = "allow-ssh"
            protocol                   = "Tcp"
            access                     = "Allow"
            direction                  = "Inbound"
            priority                   = 100
            source_port_range          = "*"
            destination_port_range     = "22"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
            description                = "Allow SSH"
          }
        ]
      }

      backend_subnet = {
        address_prefix = "10.0.2.0/24"
        security_rules = [
          {
            name                       = "allow-ssh"
            protocol                   = "Tcp"
            access                     = "Allow"
            direction                  = "Inbound"
            priority                   = 100
            source_port_range          = "*"
            destination_port_range     = "22"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
            description                = "Allow SSH"
          }
        ]
      }
      AzureBastionSubnet = {
        address_prefix = "10.0.3.0/24"
      }
    }
  }
}

vm_details = {
  web-vm = {
    location                        = "Malaysia West"
    resource_group_name             = "rg-healthcheck-dev"
    size                            = "Standard_D2s_v3"
    admin_username                  = "santosh"
    disable_password_authentication = false
    tags = {
      environment = "dev"
      owner       = "network-team"
    }
    accelerated_networking = false
    ip_forwarding          = false
    ip_configurations = [
      {
        name    = "web-vm-ipconfig"
        primary = true
        subnet  = "frontend_subnet"
      }
    ]
    enable_public_ip = false
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }

  app-vm = {
    location                        = "Malaysia West"
    resource_group_name             = "rg-healthcheck-dev"
    size                            = "Standard_D2s_v3"
    admin_username                  = "santosh"
    disable_password_authentication = false
    tags = {
      environment = "dev"
      owner       = "network-team"
    }
    accelerated_networking = false
    ip_forwarding          = false
    ip_configurations = [
      {
        name    = "app-vm-ipconfig"
        primary = true
        subnet  = "backend_subnet"
      }
    ]
    enable_public_ip = false
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
}

servers_dbs = {
  "todoappserver423" = {
    resource_group_name            = "rg-healthcheck-dev"
    location                       = "Malaysia West"
    version                        = "12.0"
    administrator_login            = "azureuser"
    allow_access_to_azure_services = true
    databases = [
      { name = "todoappdb" }
    ]
  }
}

bastion_details = {
  vnet1 = {
    location            = "Malaysia West"
    resource_group_name = "rg-healthcheck-dev"
    enable_bastion      = true
    vnet_name           = "vnet1"
  }
}
