# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "gateway_ip_configuration_subnets" {
  for_each = local.gateway_ip_configuration_subnets

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "frontend_ip_configuration_subnets" {
  for_each = local.frontend_ip_configuration_subnets

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

# Use this data source to access information about an existing Public IP Address.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip
data "azurerm_public_ip" "frontend_ip_configuration_public_ips" {
  for_each = local.frontend_ip_configuration_public_ips

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Network Interface.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface
data "azurerm_network_interface" "backend_address_pool_nics" {
  for_each = local.backend_address_pool_nic_resources

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Virtual Machine Scale Set.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine_scale_set
data "azurerm_virtual_machine_scale_set" "backend_address_pool_vmsses" {
  for_each = local.backend_address_pool_vmss_resources

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Public IP Address.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip
data "azurerm_public_ip" "backend_address_pool_pips" {
  for_each = local.backend_address_pool_pip_resources

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Linux Web App.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/linux_web_app
data "azurerm_linux_web_app" "backend_address_pool_lapps" {
  for_each = local.backend_address_pool_lapp_resources

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Windows Web App.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/windows_web_app
data "azurerm_windows_web_app" "backend_address_pool_wapps" {
  for_each = local.backend_address_pool_wapp_resources

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}