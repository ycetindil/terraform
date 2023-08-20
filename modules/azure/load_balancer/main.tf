# Manages a Load Balancer Resource.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb
resource "azurerm_lb" "lb" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  edge_zone           = var.edge_zone

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations

    content {
      name                          = frontend_ip_configuration.value.name
      zones                         = frontend_ip_configuration.value.zones
      subnet_id                     = frontend_ip_configuration.value.subnet_id
      private_ip_address            = frontend_ip_configuration.value.private_ip_address
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
      private_ip_address_version    = frontend_ip_configuration.value.private_ip_address_version
      public_ip_address_id          = frontend_ip_configuration.value.public_ip_address_id
      public_ip_prefix_id           = frontend_ip_configuration.value.public_ip_prefix_id
    }
  }

  sku      = var.sku
  sku_tier = var.sku_tier
  tags     = var.tags
}