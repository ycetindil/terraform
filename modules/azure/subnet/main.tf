resource "azurerm_subnet" "subnet" {
  name                                          = var.name
  resource_group_name                           = var.virtual_network.resource_group_name
  virtual_network_name                          = var.virtual_network.name
  address_prefixes                              = var.address_prefixes
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = var.delegation != null ? [1] : []

    content {
      name = var.delegation.name
      service_delegation {
        name    = var.delegation.service_delegation.name
        actions = var.delegation.service_delegation.actions
      }
    }
  }
  lifecycle {
    ignore_changes = [delegation[0].service_delegation[0].actions]
  }
}