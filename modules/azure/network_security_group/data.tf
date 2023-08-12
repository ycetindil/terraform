# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "subnet_network_security_group_association_subnets" {
  for_each = var.subnet_network_security_group_association_subnets

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

# Use this data source to access information about an existing Network Interface.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface
data "azurerm_network_interface" "network_interface_security_group_association_network_interfaces" {
  for_each = var.network_interface_security_group_association_network_interfaces

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}