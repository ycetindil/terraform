resource "azurerm_firewall_policy" "fwp" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
}

module "rule_collection_groups" {
  source   = "../firewall_policy_rule_collection_group"
  for_each = var.rule_collection_groups

  name                     = each.value.name
  firewall_policy_id       = azurerm_firewall_policy.fwp.id
  priority                 = each.value.priority
  network_rule_collections = each.value.network_rule_collections
}