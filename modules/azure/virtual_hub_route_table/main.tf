# Manages a Virtual Hub Route Table.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_route_table
# CYCLE ALERT! Letting the route tables create their own routes causes a cycle because the routes can refer to the connections and connections already refer to the route tables. Hence the 'rooute_table_routes' are created in the next block along with the 'Default table' routes.
resource "azurerm_virtual_hub_route_table" "virtual_hub_route_table" {
  name           = var.name
  virtual_hub_id = var.virtual_hub_id
  labels         = var.labels
}