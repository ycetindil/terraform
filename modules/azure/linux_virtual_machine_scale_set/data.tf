# Use this data source to access information about an existing Application Gateway.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_gateway
data "azurerm_application_gateway" "network_interface_ip_configuration_application_gateways" {
  for_each = local.network_interface_ip_configuration_application_gateways

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Application Security Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_security_group
data "azurerm_application_security_group" "network_interface_ip_configuration_application_security_groups" {
  for_each = local.network_interface_ip_configuration_application_security_groups

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Load Balancer
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb
data "azurerm_lb" "network_interface_ip_configuration_load_balancers" {
  for_each = local.network_interface_ip_configuration_load_balancers

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Load Balancer's Backend Address Pool.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb_backend_address_pool
data "azurerm_lb_backend_address_pool" "network_interface_ip_configuration_load_balancer_backend_address_pools" {
  for_each = local.network_interface_ip_configuration_load_balancer_backend_address_pools

  name            = each.value
  loadbalancer_id = data.azurerm_lb.network_interface_ip_configuration_load_balancers[???].id
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "network_interface_ip_configuration_subnets" {
  for_each = local.network_interface_ip_configuration_subnets

  name                 = each.value.subnet.name
  virtual_network_name = each.value.subnet.virtual_network_name
  resource_group_name  = each.value.subnet.resource_group_name
}

# Use this data source to access information about an existing Network Security Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group
data "azurerm_network_security_group" "network_security_group" {
  for_each = local.network_interface_network_security_groups
  
  name                = var.network_interface.network_security_group.name
  resource_group_name = var.network_interface.network_security_group.resource_group_name
}

# This resource can access any existing Azure resource manager resource.
# https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/azapi_resource
# For there is no Terraform data resource readily available for 'lb_health_probe', we need to use the azapi data.
data "azapi_resource" "health_probe" {
  type      = "Microsoft.Network/loadBalancers/probes@2023-02-01"
  name      = var.health_probe_name
  parent_id = data.azurerm_lb.lb.id
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

# Use this data source to access information about an existing Shared Image within a Shared Image Gallery.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image
data "azurerm_shared_image" "source_image" {
  count = var.source_image != null ? 1 : 0

  name                = var.source_image.name
  gallery_name        = var.source_image.gallery_name
  resource_group_name = var.source_image.resource_group_name
}