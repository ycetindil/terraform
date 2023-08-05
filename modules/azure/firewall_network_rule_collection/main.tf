resource "azurerm_firewall_network_rule_collection" "fwnrc" {
  name                = var.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.firewall_resource_group_name
  priority            = var.priority
  action              = var.action

  dynamic "rule" {
    for_each = var.firewall_network_rules

    content {
      name                  = rule.value.name
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_addresses = rule.value.destination_addresses
      destination_ip_groups = rule.value.destination_ip_groups
      destination_fqdns     = rule.value.destination_fqdns
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}