resource "azurerm_firewall" "fw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id = try(
    data.azurerm_firewall_policy.existing_firewall_policy[0].id,
    module.new_firewall_policy[0].id,
    "'try' function could not find a valid 'firewall_policy_id' for the 'firewall': ${var.name}!"
  )

  dynamic "ip_configuration" {
    for_each = var.ip_configuration != null ? [1] : []

    content {
      name = var.ip_configuration.name
      subnet_id = try(
        data.azurerm_subnet.existing_firewall_subnet[0].id,
        module.new_firewall_subnet[0].id,
        "'try' function could not find a valid 'subnet_id' for the 'ip_configuration': ${var.ip_configuration.name} of the 'firewall': ${var.name}!"
      )
      public_ip_address_id = try(
        data.azurerm_public_ip.existing_firewall_public_ip_address[0].id,
        module.new_firewall_public_ip_address[0].id,
        "'try' function could not find a valid 'public_ip_address_id' for the 'ip_configuration': ${var.ip_configuration.name} of the 'firewall': ${var.name}!"
      )
    }
  }

  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration != null ? [1] : []

    content {
      name = var.management_ip_configuration.name
      subnet_id = try(
        data.azurerm_subnet.existing_firewall_management_subnet[0].id,
        module.new_firewall_management_subnet[0].id,
        "'try' function could not find a valid 'subnet_id' for the 'management_ip_configuration': ${var.management_ip_configuration.name} of the 'firewall': ${var.name}!"
      )
      public_ip_address_id = try(
        data.azurerm_public_ip.existing_firewall_management_public_ip_address[0].id,
        module.new_firewall_management_public_ip_address[0].id,
        "'try' function could not find a valid 'public_ip_address_id' for the 'management_ip_configuration': ${var.management_ip_configuration.name} of the 'firewall': ${var.name}!"
      )
    }
  }

  dynamic "virtual_hub" {
    for_each = var.virtual_hub != null ? [1] : []

    content {
      virtual_hub_id = data.azurerm_virtual_hub.virtual_hub[0].id
    }
  }
}

module "firewall_network_rule_collections" {
  source   = "../firewall_network_rule_collection"
  for_each = var.firewall_network_rule_collections

  name                = each.value.name
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_firewall.fw.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.firewall_network_rules

    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }
}

# If 'firewall_policy' is existing, retrieve its data
data "azurerm_firewall_policy" "existing_firewall_policy" {
  count = var.firewall_policy != null && var.firewall_policy.existing != null ? 1 : 0

  name                = var.firewall_policy.existing.name
  resource_group_name = var.firewall_policy.existing.resource_group_name
}

# If 'firewall_policy' is new, create it
module "new_firewall_policy" {
  source = "../firewall_policy"
  count  = var.firewall_policy != null && var.firewall_policy.new != null ? 1 : 0

  name                   = var.firewall_policy.new.name
  location               = var.firewall_policy.new.location
  resource_group_name    = var.firewall_policy.new.resource_group_name
  sku                    = var.firewall_policy.new.sku
  rule_collection_groups = try(var.firewall_policy.new.rule_collection_groups, {})
}

# If 'firewall_subnet' is existing, retrieve its data
data "azurerm_subnet" "existing_firewall_subnet" {
  count = var.ip_configuration != null && var.ip_configuration.subnet.existing != null ? 1 : 0

  name                 = var.ip_configuration.subnet.existing.name
  virtual_network_name = var.ip_configuration.subnet.existing.virtual_network_name
  resource_group_name  = var.ip_configuration.subnet.existing.resource_group_name
}

# if 'firewall_subnet' is new, create it
module "new_firewall_subnet" {
  source = "../subnet"
  count  = var.ip_configuration != null && var.ip_configuration.subnet.new != null ? 1 : 0

  name             = var.ip_configuration.subnet.new.name
  virtual_network  = var.ip_configuration.subnet.new.virtual_network
  address_prefixes = var.ip_configuration.subnet.new.address_prefixes
}

# If 'firewall_public_ip_address' is existing, retrieve its data
data "azurerm_public_ip" "existing_firewall_public_ip_address" {
  count = var.ip_configuration != null && var.ip_configuration.public_ip_address.existing != null ? 1 : 0

  name                = var.ip_configuration.public_ip_address.existing.name
  resource_group_name = var.ip_configuration.public_ip_address.existing.resource_group_name
}

# If 'firewall_public_ip_address' is new, create it
module "new_firewall_public_ip_address" {
  source = "../public_ip_address"
  count  = var.ip_configuration != null && var.ip_configuration.public_ip_address.new != null ? 1 : 0

  name                = var.ip_configuration.public_ip_address.new.name
  location            = var.ip_configuration.public_ip_address.new.location
  resource_group_name = var.ip_configuration.public_ip_address.new.resource_group_name
  allocation_method   = var.ip_configuration.public_ip_address.new.allocation_method
  sku                 = var.ip_configuration.public_ip_address.new.sku
}

# If 'firewall_management_subnet' is existing, retrieve its data
data "azurerm_subnet" "existing_firewall_management_subnet" {
  count = var.management_ip_configuration != null && var.management_ip_configuration.subnet.existing != null ? 1 : 0

  name                 = "AzureFirewallManagementSubnet"
  virtual_network_name = var.management_ip_configuration.subnet.existing.virtual_network_name
  resource_group_name  = var.management_ip_configuration.subnet.existing.resource_group_name
}

# if 'firewall_management_subnet' is new, create it
module "new_firewall_management_subnet" {
  source = "../subnet"
  count  = var.management_ip_configuration != null && var.management_ip_configuration.subnet.new != null ? 1 : 0

  name             = var.management_ip_configuration.subnet.new.name
  virtual_network  = var.management_ip_configuration.subnet.new.virtual_network
  address_prefixes = var.management_ip_configuration.subnet.new.address_prefixes
}

# If 'firewall_management_public_ip_address' is existing, retrieve its data
data "azurerm_public_ip" "existing_firewall_management_public_ip_address" {
  count = var.management_ip_configuration != null && var.management_ip_configuration.public_ip_address.existing != null ? 1 : 0

  name                = var.management_ip_configuration.public_ip_address.existing.name
  resource_group_name = var.management_ip_configuration.public_ip_address.existing.resource_group_name
}

# If 'firewall_management_public_ip_address' is new, create it
module "new_firewall_management_public_ip_address" {
  source = "../public_ip_address"
  count  = var.management_ip_configuration != null && var.management_ip_configuration.public_ip_address.new != null ? 1 : 0

  name                = var.management_ip_configuration.public_ip_address.new.name
  location            = var.management_ip_configuration.public_ip_address.new.location
  resource_group_name = var.management_ip_configuration.public_ip_address.new.resource_group_name
  allocation_method   = var.management_ip_configuration.public_ip_address.new.allocation_method
  sku                 = var.management_ip_configuration.public_ip_address.new.sku
}

# If this firewall will be associated with a 'virtual_hub', retrieve its data
data "azurerm_virtual_hub" "virtual_hub" {
  count = var.virtual_hub != null ? 1 : 0

  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group_name
}