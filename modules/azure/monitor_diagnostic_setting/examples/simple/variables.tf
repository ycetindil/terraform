monitor_diagnostic_settings_xxx = {
  name = "sqldb-project101-prod-eastus-logs"
  # target_resource_id is provided by the root main.
  enabled_logs = {
    enabled_log_01 = {
      category_group = "allLogs"
    }
  }
  # log_analytics_workspace_id is provided by the root main.
  metrics = {
    metric_01 = {
      category = "Basic"
    }
    metric_02 = {
      category = "InstanceAndAppAdvanced"
    }
    metric_03 = {
      category = "WorkloadManagement"
    }
  }
}