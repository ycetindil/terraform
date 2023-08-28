# Manages a Connection for a Virtual Hub.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection
resource "azurerm_virtual_hub_connection" "virtual_hub_connection" {
  name                      = var.name
  virtual_hub_id            = var.virtual_hub_id
  remote_virtual_network_id = var.remote_virtual_network_id

  dynamic "routing" {
    for_each = var.routing != null ? [1] : []

    content {
      associated_route_table_id = var.routing.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = var.routing.propagated_route_table != null ? [1] : []

        content {
          labels          = var.routing.propagated_route_table.labels
          route_table_ids = var.routing.propagated_route_table.route_table_ids
        }
      }

      dynamic "static_vnet_route" {
        for_each = var.routing.static_vnet_route != null ? [1] : []

        content {
          name                = var.routing.static_vnet_route.name
          address_prefixes    = var.routing.static_vnet_route.address_prefixes
          next_hop_ip_address = var.routing.static_vnet_route.next_hop_ip_address
        }
      }
    }
  }
}