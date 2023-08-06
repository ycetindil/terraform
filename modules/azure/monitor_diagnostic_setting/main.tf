resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name                       = var.name != null ? var.name : "${var.target_resource.name}-logs"
  target_resource_id         = data.azurerm_resources.target_resource.resources[0].id
  storage_account_id         = try(data.azurerm_storage_account.storage_account[0].id, null)
  log_analytics_workspace_id = try(data.azurerm_log_analytics_workspace.log_analytics_workspace[0].id, null)

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
    }
  }
}

// TODO: mds verilen resource icin log_analytincs_workspace'e contributor izni gerekiyorsa buraya module cagirip hallet!

data "azurerm_resources" "target_resource" {
  name                = var.target_resource.name
  resource_group_name = var.target_resource.resource_group_name
  type                = var.target_resource.type
  required_tags       = var.target_resource.required_tags
}

# data "azurerm_key_vault" "key_vault" {
#   name                = var.target_resource.name
#   resource_group_name = var.target_resource.resource_group_name
# }

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  count = var.storage_resource.log_analytics_workspace != null ? 1 : 0

  name                = var.storage_resource.log_analytics_workspace.name
  resource_group_name = var.storage_resource.log_analytics_workspace.resource_group_name
}

data "azurerm_storage_account" "storage_account" {
  count = var.storage_resource.storage_account != null ? 1 : 0

  name                = var.storage_resource.storage_account.name
  resource_group_name = var.storage_resource.storage_account.resource_group_name
}