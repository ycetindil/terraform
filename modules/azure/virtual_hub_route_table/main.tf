# CYCLE ALERT! Letting the route tables create their own routes causes a cycle because the routes can refer to the connections and connections already refer to the route tables. Hence the 'rooute_table_routes' are created in the next block along with the 'Default table' routes.
resource "azurerm_virtual_hub_route_table" "virtual_hub_route_table" {
  for_each = local.route_tables

  name           = var.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hubs[var.virtual_hub].id
}