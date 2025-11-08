output "bastion_public_ip" {
  value = { for k, v in azurerm_bastion_host.bastion : k => azurerm_public_ip.bastion-pip[k].ip_address }
}
