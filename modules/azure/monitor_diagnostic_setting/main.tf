# Manages a Diagnostic Setting for an existing Resource.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name                           = var.name
  target_resource_id             = var.target_resource_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

  dynamic "enabled_log" {
    for_each = var.enabled_logs

    content {
      category       = enabled_log.value.category
      category_group = enabled_log.value.category_group

      dynamic "retention_policy" {
        for_each = enabled_log.value.retention_policy != null ? [1] : []

        content {
          enabled = enabled_log.value.retention_policy.enabled
          days    = enabled_log.value.retention_policy.days
        }
      }
    }
  }

  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "metric" {
    for_each = var.metrics

    content {
      category = metric.value.category

      dynamic "retention_policy" {
        for_each = metric.value.retention_policy != null ? [1] : []

        content {
          enabled = metric.value.retention_policy.enabled
          days    = metric.value.retention_policy.days
        }
      }

      enabled = metric.value.enabled
    }
  }

  storage_account_id             = var.storage_account_id
  log_analytics_destination_type = var.log_analytics_destination_type
  partner_solution_id            = var.partner_solution_id
}