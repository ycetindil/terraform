# Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network.
# NOTE on Virtual Networks and Subnets: Terraform currently provides both a standalone Subnet resource, and allows for Subnets to be defined in-line within the Virtual Network resource. At this time you cannot use a Virtual Network with in-line Subnets in conjunction with any Subnet resources. Doing so will cause a conflict of Subnet configurations and will overwrite Subnets.
resource "azurerm_subnet" "subnet" {
  name                 = var.name
  resource_group_name  = var.virtual_network.resource_group_name
  virtual_network_name = var.virtual_network.name
  address_prefixes     = var.address_prefixes

  dynamic "delegation" {
    for_each = var.delegations

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }

  private_endpoint_network_policies_enabled     = var.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
  service_endpoints                             = var.service_endpoints
  service_endpoint_policy_ids                   = var.service_endpoint_policy_ids
}