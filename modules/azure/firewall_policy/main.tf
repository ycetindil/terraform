# Manages a Firewall Policy.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy
resource "azurerm_firewall_policy" "fwp" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

# Manages a Firewall Policy Rule Collection Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group
resource "azurerm_firewall_policy_rule_collection_group" "fwprcgS" {
  for_each = var.firewall_policy_rule_collection_groups

  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.fwp.id
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = each.value.network_rule_collections

    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.value.name
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
  }
}