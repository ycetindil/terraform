module "monitor_diagnostic_settings_xxx" {
  source = "./modules/monitor_diagnostic_setting"

  name                       = var.monitor_diagnostic_settings_xxx.name
  target_resource_id         = module.mssql_database_xxx.id
  enabled_logs               = var.monitor_diagnostic_settings_xxx.enabled_logs
  log_analytics_workspace_id = module.log_analytics_workspace_xxx.id
  metrics                    = var.monitor_diagnostic_settings_xxx.metrics
}