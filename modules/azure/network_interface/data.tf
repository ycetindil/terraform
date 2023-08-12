# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "ip_configuration_subnets" {
  for_each = {
    for key, configuration in var.ip_configurations :
    key => configuration.subnet
    if configuration.subnet != null
  }

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.subnet_resource_group_name
}

# Use this data source to access information about an existing Public IP Address.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip
data "azurerm_public_ip" "ip_configuration_public_ip_addresses" {
  for_each = {
    for key, configuration in var.ip_configurations :
    key => configuration.public_ip_address
    if configuration.public_ip_address != null
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}