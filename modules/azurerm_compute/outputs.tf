output "vm_private_ips" {
  description = "Private IPs of all Linux VMs"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : v.name => v.private_ip_address }
}

output "vm_public_ips" {
  description = "Public IPs of all Linux VMs"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : v.name => v.public_ip_address }
}

output "vm_nic_ids" {
  description = "NIC IDs attached to each VM"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : v.name => v.network_interface_ids[0] }
}

output "vm_ids" {
  description = "Resource IDs of all VMs"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : v.name => v.id }
}
