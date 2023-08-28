# Manages a Virtual Hub within a Virtual WAN.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub
resource "azurerm_virtual_hub" "virtual_hub" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  address_prefix         = var.address_prefix
  hub_routing_preference = var.hub_routing_preference
  sku                    = var.sku
  virtual_wan_id         = var.virtual_wan_id
  tags                   = var.tags
}