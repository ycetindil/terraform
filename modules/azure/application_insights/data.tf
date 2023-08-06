# Use this data source to access information about an existing Log Analytics (formally Operational Insights) Workspace.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace
data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  count = var.log_analytics_workspace != null ? 1 : 0

  name                = var.log_analytics_workspace.name
  resource_group_name = var.log_analytics_workspace.resource_group_name
}