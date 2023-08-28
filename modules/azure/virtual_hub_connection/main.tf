resource "azurerm_virtual_hub_connection" "virtual_hub_connection" {
  for_each = local.virtual_hub_connections

  name                      = var.name
  virtual_hub_id            = azurerm_virtual_hub.virtual_hubs[var.virtual_hub].id
  remote_virtual_network_id = data.azurerm_virtual_network.virtual_networks[each.key].id

  routing {
    associated_route_table_id = (
      var.routing.associated_route_table == "Default" ?
      azurerm_virtual_hub.virtual_hubs[var.virtual_hub].default_route_table_id :
      (
        var.routing.associated_route_table == "None" ?
        replace(azurerm_virtual_hub.virtual_hubs[var.virtual_hub].default_route_table_id, "defaultRouteTable", "noneRouteTable") :
        azurerm_virtual_hub_route_table.virtual_hub_route_tables["${var.virtual_hub}_${var.reference_name}"].id
      )
    )
    propagated_route_table {
      route_table_ids = concat(
        [
          for route_table in var.routing.propagated_route_tables :
          azurerm_virtual_hub.virtual_hubs[route_table.virtual_hub].default_route_table_id
          if route_table.name == "Default"
        ],
        [
          for route_table in var.routing.propagated_route_tables :
          replace(azurerm_virtual_hub.virtual_hubs[route_table.virtual_hub].default_route_table_id, "defaultRouteTable", "noneRouteTable")
          if route_table.name == "None"
        ],
        [
          for route_table in var.routing.propagated_route_tables :
          azurerm_virtual_hub_route_table.virtual_hub_route_tables["${route_table.virtual_hub}_${route_table.reference_name}"].id
          if route_table.name != "Default" && route_table.name != "None"
        ]
      )
    }
  }
}