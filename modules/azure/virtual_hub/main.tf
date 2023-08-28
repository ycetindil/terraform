resource "azurerm_virtual_hub" "virtual_hub" {
  for_each = var.virtual_hubs

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_wan_id      = azurerm_virtual_wan.virtual_wan.id
  address_prefix      = var.address_prefix
}