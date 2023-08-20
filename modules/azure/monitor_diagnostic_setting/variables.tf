variable "name" {
  description = <<EOD
		(Required) Specifies the name of the Diagnostic Setting.
		Changing this forces a new resource to be created.
		NOTE: If the name is set to 'service' it will not be possible to fully delete the diagnostic setting. This is due to legacy API support.
	EOD
  type        = string
}

variable "target_resource_id" {
  description = <<EOD
		(Required) The ID of an existing Resource on which to configure Diagnostic Settings.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "eventhub_name" {
  description = <<EOD
		(Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent.
		NOTE: If this isn't specified then the default Event Hub will be used.
	EOD
  default     = null
  type        = string
}

variable "eventhub_authorization_rule_id" {
  description = <<EOD
		(Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data.
		NOTE: This can be sourced from the azurerm_eventhub_namespace_authorization_rule resource and is different from a azurerm_eventhub_authorization_rule resource.
		NOTE: At least one of eventhub_authorization_rule_id, log_analytics_workspace_id, partner_solution_id and storage_account_id must be specified.
	EOD
  default     = null
  type        = string
}

variable "enabled_logs" {
  description = <<EOD
		(Optional) One or more enabled_log blocks as defined below.
		NOTE: At least one enabled_log or metric block must be specified. At least one type of Log or Metric must be enabled.
		An enabled_log block supports the following:
		- category - (Optional) The name of a Diagnostic Log Category for this Resource.
			NOTE: The Log Categories available vary depending on the Resource being used. You may wish to use the azurerm_monitor_diagnostic_categories Data Source or list of service specific schemas to identify which categories are available for a given Resource.
		- category_group - (Optional) The name of a Diagnostic Log Category Group for this Resource.
			NOTE: Not all resources have category groups available.
		- retention_policy - (Optional) A retention_policy block as defined below.
			A retention_policy block supports the following:
			- enabled - (Required) Is this Retention Policy enabled?
			- days - (Optional) The number of days for which this Retention Policy should apply.
				NOTE: Setting this to 0 will retain the events indefinitely.
	EOD
  default     = {}
  type = map(object({
    category       = optional(string)
    category_group = optional(string)
    retention_policy = optional(object({
      enabled = bool
      days    = optional(number)
    }))
  }))
}

variable "log_analytics_workspace_id" {
  description = <<EOD
		(Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent.
		NOTE: At least one of eventhub_authorization_rule_id, log_analytics_workspace_id, partner_solution_id and storage_account_id must be specified.
	EOD
  default     = null
  type        = string
}

variable "metric" {
  description = <<EOD
		(Optional) One or more metric blocks as defined below.
		NOTE: At least one log, enabled_log or metric block must be specified.
		metric block supports the following:
		- category - (Required) The name of a Diagnostic Metric Category for this Resource.
			NOTE: The Metric Categories available vary depending on the Resource being used. You may wish to use the azurerm_monitor_diagnostic_categories Data Source to identify which categories are available for a given Resource.
		- retention_policy - (Optional) A retention_policy block as defined below.
			A retention_policy block supports the following:
			- enabled - (Required) Is this Retention Policy enabled?
			- days - (Optional) The number of days for which this Retention Policy should apply.
				NOTE: Setting this to 0 will retain the events indefinitely.
		- enabled - (Optional) Is this Diagnostic Metric enabled?
			Defaults to true.
	EOD
  default     = {}
  type = map(object({
    category = string
    retention_policy = optional(object({
      enabled = bool
      days    = optional(number)
    }))
    enabled = optional(bool)
  }))
}

variable "storage_account_id" {
  description = <<EOD
		(Optional) The ID of the Storage Account where logs should be sent.
		NOTE: At least one of eventhub_authorization_rule_id, log_analytics_workspace_id, partner_solution_id and storage_account_id must be specified.
	EOD
  default     = null
  type        = string
}

variable "log_analytics_destination_type" {
  description = <<EOD
		(Optional) Possible values are AzureDiagnostics and Dedicated.
		When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table.
		NOTE: This setting will only have an effect if a log_analytics_workspace_id is provided. For some target resource type (e.g., Key Vault), this field is unconfigurable. Please see https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics#resource-types for services that use each method. Please see https://docs.microsoft.com/azure/azure-monitor/platform/diagnostic-logs-stream-log-store#azure-diagnostics-vs-resource-specific for details on the differences between destination types.
	EOD
  default     = null
  type        = string
}

variable "partner_solution_id" {
  description = <<EOD
		(Optional) The ID of the market partner solution where Diagnostics Data should be sent. For potential partner integrations, visit https://learn.microsoft.com/en-us/azure/partner-solutions/overview to learn more about partner integration.
		NOTE: At least one of eventhub_authorization_rule_id, log_analytics_workspace_id, partner_solution_id and storage_account_id must be specified.
	EOD
  default     = null
  type        = string
}