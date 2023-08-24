# Associates a Route Table with a Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association
resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  route_table_id = azurerm_route_table.route_table.id
  subnet_id      = data.azurerm_subnet.subnets[each.key].id
}