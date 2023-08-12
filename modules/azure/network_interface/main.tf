# Manages a Network Interface.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
resource "azurerm_network_interface" "nic" {
  for_each = var.network_interfaces

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name                                               = ip_configuration.value.name
      gateway_load_balancer_frontend_ip_configuration_id = ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id
      subnet_id                                          = try(data.azurerm_subnet.ip_configuration_subnets[ip_configuration.key].id, null)
      private_ip_address_version                         = ip_configuration.value.private_ip_address_version
      private_ip_address_allocation                      = ip_configuration.value.private_ip_address_allocation
      public_ip_address_id                               = try(data.azurerm_public_ip.ip_configuration_public_ip_addresses[ip_configuration.key].id, null)
      primary                                            = ip_configuration.value.primary
      private_ip_address                                 = ip_configuration.value.private_ip_address
    }
  }

  location                      = each.value.location
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  dns_servers                   = each.value.dns_servers
  edge_zone                     = each.value.edge_zone
  enable_ip_forwarding          = each.value.enable_ip_forwarding
  enable_accelerated_networking = each.value.enable_accelerated_networking
  internal_dns_name_label       = each.value.internal_dns_name_label
  tags                          = each.value.tags
}