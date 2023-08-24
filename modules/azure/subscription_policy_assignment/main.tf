resource "azurerm_subscription_policy_assignment" "subscription_policy_assignment" {
  for_each = local.network_group_policies

  name                 = "${var.name}-policy-assignment"
  policy_definition_id = azurerm_policy_definition.custom_policies[each.key].id
  subscription_id = coalesce(
    var.subscription.is_current ? data.azurerm_subscription.current_subscription.id : "",
    var.subscription.id
  )
}