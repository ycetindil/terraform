output "name" {
  description = "The name of this Firewall Policy."
  value       = azurerm_firewall_policy.fwp.name
}

output "id" {
  description = "The ID of this Firewall Policy."
  value       = azurerm_firewall_policy.fwp.id
}

output "firewalls" {
  description = "A list of references to Azure Firewalls that this Firewall Policy is associated with."
  value       = azurerm_firewall_policy.fwp.firewalls
}

output "rule_collection_groups" {
  description = "A list of references to Firewall Policy Rule Collection Groups that belongs to this Firewall Policy."
  value       = azurerm_firewall_policy.fwp.rule_collection_groups
}