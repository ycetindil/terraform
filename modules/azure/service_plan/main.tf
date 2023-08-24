# Manages an App Service: Service Plan.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan
resource "azurerm_service_plan" "service_plan" {
  name                = var.name
  location            = var.location
  os_type             = var.os_type
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
}