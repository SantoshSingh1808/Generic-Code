output "key_vault_ids" {
  description = "Map of Key Vault IDs"
  value       = { for k, v in azurerm_key_vault.keyvault : k => v.id }
}

output "key_vault_uris" {
  description = "Map of Key Vault URIs"
  value       = { for k, v in azurerm_key_vault.keyvault : k => v.vault_uri }
}

output "key_vault_names" {
  description = "Map of Key Vault names"
  value       = { for k, v in azurerm_key_vault.keyvault : k => v.name }
}

output "secrets" {
  description = "Map of Key Vault secrets and their values"
  value = {
    for k, v in data.azurerm_key_vault_secret.existing_secret :
    k => v.value
  }
  sensitive = true
}
