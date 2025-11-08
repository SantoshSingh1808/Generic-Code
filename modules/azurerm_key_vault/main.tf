resource "azurerm_key_vault" "keyvault" {
  for_each            = var.key_vaults
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = each.value.sku_name

  enabled_for_deployment          = coalesce(each.value.enabled_for_deployment, false)
  enabled_for_disk_encryption     = coalesce(each.value.enabled_for_disk_encryption, false)
  enabled_for_template_deployment = coalesce(each.value.enabled_for_template_deployment, false)

  purge_protection_enabled      = coalesce(each.value.purge_protection_enabled, false)
  public_network_access_enabled = coalesce(each.value.public_network_access_enabled, true)
  soft_delete_retention_days    = coalesce(each.value.soft_delete_retention_days, 90)
  rbac_authorization_enabled    = coalesce(each.value.rbac_authorization_enabled, false)

  tags = coalesce(each.value.tags, {})

#   dynamic "access_policy" {
#     for_each = coalesce(each.value.access_policies, [])
#     content {
#       tenant_id      = access_policy.value.tenant_id
#       object_id      = access_policy.value.object_id
#       application_id = lookup(access_policy.value, "application_id", null)

#       certificate_permissions = coalesce(access_policy.value.certificate_permissions, [])
#       key_permissions         = coalesce(access_policy.value.key_permissions, [])
#       secret_permissions      = coalesce(access_policy.value.secret_permissions, [])
#       storage_permissions     = coalesce(access_policy.value.storage_permissions, [])
#     }
#   }

  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? [each.value.network_acls] : []
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = coalesce(network_acls.value.ip_rules, [])
      virtual_network_subnet_ids = coalesce(network_acls.value.virtual_network_subnet_ids, [])
    }
  }
}

resource "azurerm_role_assignment" "kv_admin" {
  for_each             = var.key_vaults
  scope                = azurerm_key_vault.keyvault[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "time_sleep" "wait_for_rbac" {
  depends_on      = [azurerm_role_assignment.kv_admin]
  create_duration = "90s"
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each        = var.key_vaults
  name            = "santosh"
  value           = var.password
  key_vault_id    = azurerm_key_vault.keyvault[each.key].id
  content_type    = "password"
  expiration_date = "2025-12-31T23:59:59Z"
  depends_on      = [time_sleep.wait_for_rbac]
}