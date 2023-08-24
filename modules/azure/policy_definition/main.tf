# Manages a policy rule definition on a management group or your provider subscription.
# Policy definitions do not take effect until they are assigned to a scope using a Policy Assignment.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition
resource "azurerm_policy_definition" "policy_definition" {
  name                = var.name
  policy_type         = var.policy_type
  mode                = var.mode
  display_name        = var.display_name
  description         = var.description
  management_group_id = var.management_group_id
  policy_rule         = var.policy_rule
  metadata            = var.metadata
  parameters          = var.parameters
}