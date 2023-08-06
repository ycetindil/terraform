resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

module "monitor_diagnostic_settings" {
  for_each = var.monitor_diagnostic_settings
  source   = "../monitor_diagnostic_setting"

  name            = try(each.value.name, null)
  target_resource = each.value.target_resource
  storage_resource = {
    log_analytics_workspace = {
      name                = var.name
      resource_group_name = var.resource_group_name
    }
  }
  enabled_logs = try(each.value.enabled_logs, {})
  metrics      = try(each.value.metrics, {})

  depends_on = [azurerm_log_analytics_workspace.log_analytics_workspace]
}