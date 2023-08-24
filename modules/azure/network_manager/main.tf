# Manages a Network Manager.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager
resource "azurerm_network_manager" "network_manager" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  scope {
    management_group_ids = var.scope.management_group_ids
    subscription_ids     = var.scope.subscription_ids
  }

  scope_accesses = var.scope_accesses
  description    = var.description
  tags           = var.tags
}