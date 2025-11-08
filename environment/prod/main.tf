module "azurerm_resource_group" {
  source  = "../../modules/azurerm_resource_group"
  rg_name = var.rg_details
}

module "azurerm_storage_account" {
  source           = "../../modules/azurerm_storage_account"
  storage_accounts = var.storage_details
  rg_name          = module.azurerm_resource_group.rg_data
  depends_on       = [module.azurerm_resource_group]
}

module "key_vault" {
  source     = "../../modules/azurerm_key_vault"
  password   = var.KeyVault_Secret_Value
  key_vaults = var.key_vaults_details
  depends_on = [module.azurerm_resource_group]
}

module "azurerm_virtual_network" {
  source           = "../../modules/azurerm_network"
  virtual_networks = var.networks_details
  depends_on       = [module.azurerm_resource_group]
}

module "azurerm_virtual_machine" {
  source           = "../../modules/azurerm_compute"
  virtual_machines = var.vm_details
  vnet_name        = "vnet1"
  subnet_ids       = module.azurerm_virtual_network.subnet_ids
  key_vault_id     = module.key_vault.key_vault_ids["kv1"]
  depends_on       = [module.azurerm_virtual_network]
}

module "database" {
  source       = "../../modules/azurerm_database"
  servers_dbs  = var.servers_dbs
  key_vault_id = module.key_vault.key_vault_ids["kv1"]
  depends_on   = [module.azurerm_resource_group]
}

module "azurerm_bastion" {
  source     = "../../modules/azurerm_bastion"
  bastion    = var.bastion_details
  subnet_ids = module.azurerm_virtual_network.subnet_ids
  depends_on = [module.azurerm_virtual_network]
}
