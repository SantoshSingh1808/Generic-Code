resource "azurerm_mssql_server" "servers" {
  for_each                     = var.servers_dbs
  name                         = each.key
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = data.azurerm_key_vault_secret.secrets.value
}

resource "azurerm_mssql_database" "dbs" {
for_each = transpose({
  for k, v in var.servers_dbs :
  k => [for db in lookup(v, "databases", []) : db.name]
})

  name                 = each.key
  server_id            = azurerm_mssql_server.servers[each.value[0]].id
  sku_name             = try(each.value[1].sku_name, "Basic")
  max_size_gb          = try(each.value[1].max_size_bytes, 2)
  collation            = try(each.value[1].collation, "SQL_Latin1_General_CP1_CI_AS")
  zone_redundant       = false
  geo_backup_enabled   = true
  storage_account_type = "Local"

  tags = try(each.value[1].tags, null)
}

resource "azurerm_mssql_firewall_rule" "allow_access_to_azure_services" {
  for_each = {
    for db_server_name, db_server_details in var.servers_dbs :
    db_server_name => db_server_details
    if lookup(db_server_details, "allow_access_to_azure_services", false)
  }

  name             = "allow_access_to_azure_services"
  server_id        = azurerm_mssql_server.servers[each.key].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

output "db_connection_strings" {
  value = {
    for db_name, server_list in transpose({
      for server_key, server_value in var.servers_dbs :
      server_key => [for db in lookup(server_value, "databases", []) : db.name]
    }) :
    db_name => "Driver={ODBC Driver 17 for SQL Server};Server=tcp:${server_list[0]}.database.windows.net,1433;Database=${db_name};Uid=${var.servers_dbs[server_list[0]].administrator_login};Pwd=${data.azurerm_key_vault_secret.secrets.value};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
  }
}
