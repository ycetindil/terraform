output "id" {
  description = "The ID of the Bastion Host."
  value       = azurerm_bastion_host.bastion_host.id
}

output "dns_name" {
  description = "The FQDN for the Bastion Host."
  value       = azurerm_bastion_host.bastion_host.dns_name
}