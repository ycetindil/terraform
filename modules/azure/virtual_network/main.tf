resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

module "subnets" {
  source   = "../subnet"
  for_each = var.subnets

  name = var.name
  virtual_network = {
    name                = azurerm_virtual_network.virtual_network.name
    resource_group_name = azurerm_virtual_network.virtual_network.resource_group_name
  }
  address_prefixes                              = var.address_prefixes
  private_link_service_network_policies_enabled = try(var.private_link_service_network_policies_enabled, null)
  delegation                                    = try(var.delegation, null)
}