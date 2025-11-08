variable "bastion" {
  description = "Map of Bastion Host configurations"
  type = map(object({
    location            = string
    resource_group_name = string
    enable_bastion      = bool
    vnet_name           = string
  }))
}

variable "subnet_ids" {
  description = "Nested map of subnet IDs by VNet and subnet name"
  type        = map(string)
}
