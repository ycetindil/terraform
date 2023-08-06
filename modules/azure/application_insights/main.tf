# Manages an Application Insights component.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
resource "azurerm_application_insights" "appi" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type
  workspace_id        = try(data.azurerm_log_analytics_workspace.log_analytics_workspace[0].id, null)

  lifecycle {
    ignore_changes = [workspace_id]
  }
}
