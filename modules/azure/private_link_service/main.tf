# Manages a Private Link Service.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_link_service
resource "azurerm_private_link_service" "private_link_service" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "nat_ip_configuration" {
    for_each = var.nat_ip_configurations

    content {
      name                       = nat_ip_configuration.value.name
      subnet_id                  = nat_ip_configuration.value.subnet_id
      primary                    = nat_ip_configuration.value.primary
      private_ip_address         = nat_ip_configuration.value.private_ip_address
      private_ip_address_version = nat_ip_configuration.value.private_ip_address_version
    }
  }

  load_balancer_frontend_ip_configuration_ids = var.load_balancer_frontend_ip_configuration_ids
  auto_approval_subscription_ids              = var.auto_approval_subscription_ids
  enable_proxy_protocol                       = var.enable_proxy_protocol
  fqdns                                       = var.fqdns
  tags                                        = var.tags
  visibility_subscription_ids                 = var.visibility_subscription_ids
}