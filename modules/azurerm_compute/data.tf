data "azurerm_key_vault_secret" "secrets" {
  name         = "santosh"
  key_vault_id = var.key_vault_id
}