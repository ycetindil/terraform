resource "azurerm_linux_web_app" "linux_web_app" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = data.azurerm_service_plan.service_plan.id
  app_settings              = var.app_settings
  virtual_network_subnet_id = data.azurerm_subnet.subnet.id
  tags                      = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type = var.identity.type
    }
  }

  site_config {
    container_registry_use_managed_identity = var.site_config.container_registry_use_managed_identity
    vnet_route_all_enabled                  = var.site_config.vnet_route_all_enabled
    always_on                               = var.site_config.always_on
  }

  lifecycle {
    ignore_changes = [
      service_plan_id,
      virtual_network_subnet_id
    ]
  }
}

data "azurerm_service_plan" "service_plan" {
  name                = var.service_plan.name
  resource_group_name = var.service_plan.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  virtual_network_name = var.subnet.virtual_network_name
  resource_group_name  = var.subnet.subnet_resource_group_name
}