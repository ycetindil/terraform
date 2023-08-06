output "id" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "x" {
  value = module.monitor_diagnostic_settings
}