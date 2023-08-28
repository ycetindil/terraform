# Associates a Route Table with a Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association
resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  route_table_id = var.route_table_id
  subnet_id      = var.subnet_id
}