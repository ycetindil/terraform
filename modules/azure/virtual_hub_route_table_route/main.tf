# Manages a Route in a Virtual Hub Route Table.
# Note: Route table routes can managed with this resource, or in-line with the virtual_hub_route_table resource. Using both is not supported.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_route_table_route
resource "azurerm_virtual_hub_route_table_route" "virtual_hub_route_table_route" {
  route_table_id    = var.route_table_id
  name              = var.name
  destinations      = var.destinations
  destinations_type = var.destinations_type
  next_hop_type     = var.next_hop_type
  next_hop          = var.next_hop
}