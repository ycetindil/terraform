# Use this data source to access information about an existing SSH Public Key.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/ssh_public_key
data "azurerm_ssh_public_key" "admin_ssh_keys_from_azure" {
  for_each = local.admin_ssh_keys_from_azure

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
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
data "azurerm_subnet" "network_interface_ip_configuration_subnets" {
  for_each = local.network_interface_ip_configuration_subnets

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.subnet_resource_group_name
}

# Use this data source to access information about an existing Public IP Address.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip
data "azurerm_public_ip" "network_interface_ip_configuration_public_ip_addresses" {
  for_each = local.network_interface_ip_configuration_public_ip_addresses

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Network Security Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group
data "azurerm_network_security_group" "network_interface_network_security_groups" {
  for_each = local.network_interface_network_security_groups

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}