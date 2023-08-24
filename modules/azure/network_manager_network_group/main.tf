resource "azurerm_network_manager_network_group" "network_manager_network_group" {
  name               = var.name
  network_manager_id = var.network_manager_id
  description        = var.description
}