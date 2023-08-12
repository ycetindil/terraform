# Use this data source to access information about an existing Network Interface.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface
data "azurerm_network_interface" "network_interfaces" {
  for_each = var.network_interfaces

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

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