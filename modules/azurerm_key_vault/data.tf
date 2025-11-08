data "azurerm_client_config" "current" {}

data "azurerm_key_vault_secret" "existing_secret" {
  for_each     = var.key_vaults
  name         = "santosh"
  key_vault_id = azurerm_key_vault.keyvault[each.key].id

  depends_on = [
    azurerm_key_vault_secret.secrets,
    time_sleep.wait_for_rbac
  ]
}
