# Use this data source to access information about an existing Firewall Policy.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/firewall_policy
data "azurerm_firewall_policy" "firewall_policy" {
  count = var.firewall_policy != null ? 1 : 0

  name                = var.firewall_policy.name
  resource_group_name = var.firewall_policy.resource_group_name
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "firewall_subnet" {
  count = var.ip_configuration != null && var.ip_configuration.subnet != null ? 1 : 0

  name                 = var.ip_configuration.subnet.name
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.ip_configuration.subnet.resource_group_name
}

# Use this data source to access information about an existing Public IP Address.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip
data "azurerm_public_ip" "firewall_public_ip_address" {
  count = var.ip_configuration != null && var.ip_configuration.public_ip_address != null ? 1 : 0

  name                = var.ip_configuration.public_ip_address.name
  resource_group_name = var.ip_configuration.public_ip_address.resource_group_name
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "firewall_management_subnet" {
  count = var.management_ip_configuration != null ? 1 : 0

  name                 = var.management_ip_configuration.subnet.name
  virtual_network_name = var.management_ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.management_ip_configuration.subnet.resource_group_name
}

# Use this data source to access information about an existing Public IP Address.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip
data "azurerm_public_ip" "firewall_management_public_ip_address" {
  count = var.management_ip_configuration != null ? 1 : 0

  name                = var.management_ip_configuration.public_ip_address.name
  resource_group_name = var.management_ip_configuration.public_ip_address.resource_group_name
}

# Use this data source to access information about an existing Virtual Hub.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_hub
data "azurerm_virtual_hub" "virtual_hub" {
  count = var.virtual_hub != null ? 1 : 0

  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group_name
}