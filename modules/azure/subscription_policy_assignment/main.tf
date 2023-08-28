# Manages a Subscription Policy Assignment.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment
resource "azurerm_subscription_policy_assignment" "subscription_policy_assignment" {
  name                 = var.name
  policy_definition_id = var.policy_definition_id
  subscription_id      = var.subscription_id
}