# Manages a virtual network peering which allows resources to access other resources in the linked virtual network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
resource "azurerm_virtual_network_peering" "vnet_peering" {
  name                      = var.name
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = var.remote_virtual_network_id
  resource_group_name       = var.resource_group_name
  allow_forwarded_traffic   = var.allow_forwarded_traffic
}