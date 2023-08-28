resource "azurerm_virtual_hub_route_table_route" "virtual_hub_route_table_route" {
  for_each = local.route_table_routes

  route_table_id = azurerm_virtual_hub.virtual_hubs[var.virtual_hub].default_route_table_id

  name              = var.name
  destinations_type = var.destinations_type
  destinations      = var.destinations
  next_hop_type     = var.next_hop_type
  # We need the connection's reference name rather than its name, hence the 'replace' function
  next_hop = (
    var.next_hop.firewall != {} ?
    data.azurerm_firewall.route_table_route_firewalls[each.key].id :
    azurerm_virtual_hub_connection.virtual_hub_connections["${var.virtual_hub}_${replace(var.next_hop.connection_name, "-", "_")}"].id
  )
}