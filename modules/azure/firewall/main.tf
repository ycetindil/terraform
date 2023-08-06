resource "azurerm_firewall" "fw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id = try(data.azurerm_firewall_policy.firewall_policy[0].id, null)

  dynamic "ip_configuration" {
    for_each = var.ip_configuration != null ? [1] : []

    content {
      name = var.ip_configuration.name
      subnet_id = try(data.azurerm_subnet.firewall_subnet[0].id, null)
      public_ip_address_id = try(data.azurerm_public_ip.firewall_public_ip_address[0].id, null)
    }
  }

  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration != null ? [1] : []

    content {
      name = var.management_ip_configuration.name
      subnet_id = data.azurerm_subnet.existing_firewall_management_subnet[0].id
      public_ip_address_id = data.azurerm_public_ip.firewall_management_public_ip_address[0].id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.virtual_hub != null ? [1] : []

    content {
      virtual_hub_id = data.azurerm_virtual_hub.virtual_hub[0].id
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "fwnrcs" {
  for_each = var.firewall_network_rule_collections

  name                = each.value.name
  azure_firewall_name = each.value.firewall_name
  resource_group_name = each.value.firewall_resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules

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

data "azurerm_firewall_policy" "firewall_policy" {
  count = var.firewall_policy != null ? 1 : 0

  name                = var.firewall_policy.name
  resource_group_name = var.firewall_policy.resource_group_name
}

data "azurerm_subnet" "firewall_subnet" {
  count = var.ip_configuration != null && var.ip_configuration.subnet != null ? 1 : 0

  name                 = var.ip_configuration.subnet.name
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.ip_configuration.subnet.resource_group_name
}

data "azurerm_public_ip" "firewall_public_ip_address" {
  count = var.ip_configuration != null && var.ip_configuration.public_ip_address != null ? 1 : 0

  name                = var.ip_configuration.public_ip_address.name
  resource_group_name = var.ip_configuration.public_ip_address.resource_group_name
}


data "azurerm_subnet" "firewall_management_subnet" {
  count = var.management_ip_configuration != null ? 1 : 0

  name                 = var.management_ip_configuration.subnet.name
  virtual_network_name = var.management_ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.management_ip_configuration.subnet.resource_group_name
}

data "azurerm_public_ip" "firewall_management_public_ip_address" {
  count = var.management_ip_configuration != null ? 1 : 0

  name                = var.management_ip_configuration.public_ip_address.name
  resource_group_name = var.management_ip_configuration.public_ip_address.resource_group_name
}

data "azurerm_virtual_hub" "virtual_hub" {
  count = var.virtual_hub != null ? 1 : 0

  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group_name
}