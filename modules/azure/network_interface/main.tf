# Manages a Network Interface.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
resource "azurerm_network_interface" "nic" {
  for_each = var.network_interfaces

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name                          = ip_configuration.value.name
      subnet_id                     = data.azurerm_subnet.subnets["${each.key}_${ip_configuration.key}"].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      # If none of 'existing' or 'new' 'public_ip_address' is given, 'coalesce' will throw an error. 'Try' will catch it and return 'null'.
      public_ip_address_id = try(coalesce(
        try(data.azurerm_public_ip.existing_public_ip_addresses["${each.key}_${ip_configuration.key}"].id, ""),
        try(module.new_public_ip_addresses["${each.key}_${ip_configuration.key}"].id, "")
      ), null)
    }
  }
}