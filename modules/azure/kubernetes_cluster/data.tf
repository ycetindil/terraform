# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "default_node_pool_subnet" {
  count = var.default_node_pool.vnet_subnet != null ? 1 : 0

  name                 = var.default_node_pool.vnet_subnet.name
  virtual_network_name = var.default_node_pool.vnet_subnet.virtual_network_name
  resource_group_name  = var.default_node_pool.vnet_subnet.resource_group_name
}

# Use this data source to access information about an existing User Assigned Identity.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity
data "azurerm_user_assigned_identity" "user_assigned_identities" {
  count = try(var.identity.user_assigned_identities, null) != null ? length(var.identity.user_assigned_identities) : 0

  name                = var.identity.user_assigned_identities[count.index].name
  resource_group_name = var.identity.user_assigned_identities[count.index].resource_group_name
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "ingress_application_gateway_subnet" {
  count = try(var.ingress_application_gateway.subnet, null) != null ? 1 : 0

  name                 = var.ingress_application_gateway.subnet.name
  virtual_network_name = var.ingress_application_gateway.subnet.virtual_network_name
  resource_group_name  = var.ingress_application_gateway.subnet.resource_group_name
}