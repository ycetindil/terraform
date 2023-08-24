# Manages a Route Table
# NOTE on Route Tables and Routes: Terraform currently provides both a standalone Route resource, and allows for Routes to be defined in-line within the Route Table resource. At this time you cannot use a Route Table with in-line Routes in conjunction with any Route resources. Doing so will cause a conflict of Route configurations and will overwrite Routes.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table
resource "azurerm_route_table" "route_table" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = var.tags
}