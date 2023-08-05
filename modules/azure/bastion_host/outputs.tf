output "name" {
  description = "The name of the Bastion Host."
  value       = azurerm_bastion_host.bastion_host.name
}

output "id" {
  description = "The name of the Bastion Host."
  value       = azurerm_bastion_host.bastion_host.id
}

output "dns_name" {
  description = "The FQDN for the Bastion Host."
  value       = azurerm_bastion_host.bastion_host.dns_name
}

output "subnet_id" {
  description = "Dedicated subnet id for the Bastion."
  value       = azurerm_bastion_host.bastion_host.ip_configuration.subnet_id
}

output "public_ip_address_id" {
  description = "Dedicated public IP address id for the Bastion."
  value       = azurerm_bastion_host.bastion_host.ip_configuration.public_ip_address_id
}