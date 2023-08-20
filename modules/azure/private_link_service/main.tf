resource "azurerm_private_link_service" "private_link_service" {
  count = var.private_link_service != null ? 1 : 0

  name                = var.private_link_service.name
  resource_group_name = var.resource_group_name
  location            = var.location

  auto_approval_subscription_ids              = [data.azurerm_client_config.client_config.subscription_id]
  visibility_subscription_ids                 = [data.azurerm_client_config.client_config.subscription_id]
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.lb.frontend_ip_configuration[0].id]

  dynamic "nat_ip_configuration" {
    for_each = var.private_link_service.nat_ip_configurations

    content {
      name      = nat_ip_configuration.value.name
      subnet_id = data.azurerm_subnet.subnets_pls[nat_ip_configuration.key].id
      primary   = nat_ip_configuration.value.primary
    }
  }
}