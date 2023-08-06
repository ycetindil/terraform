data "azurerm_service_plan" "service_plan" {
  name                = var.service_plan.name
  resource_group_name = var.service_plan.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  virtual_network_name = var.subnet.virtual_network_name
  resource_group_name  = var.subnet.subnet_resource_group_name
}

resource "azurerm_windows_web_app" "windows_web_app" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = data.azurerm_service_plan.service_plan.id
  app_settings              = var.app_settings
  virtual_network_subnet_id = data.azurerm_subnet.subnet.id

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type = identity.type
    }
  }

  site_config {}

  # lifecycle {
  #   ignore_changes = [virtual_network_subnet_id]
  # }
}