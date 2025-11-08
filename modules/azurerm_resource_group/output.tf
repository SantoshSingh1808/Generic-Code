output "rg_data" {
  description = "Data of all rg groups"
  value = {
    for key, rg in azurerm_resource_group.rg :
    key => {
      name     = rg.name
      location = rg.location
      id       = rg.id
    }
  }
}
