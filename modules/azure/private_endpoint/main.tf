data "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  resource_group_name  = var.subnet.resource_group_name
  virtual_network_name = var.subnet.virtual_network_name
}

# This block is going to give us an object.
# We need to access its attribute 'resources's first element when calling.
data "azurerm_resources" "attached_resource" {
  type                = var.attached_resource.type
  required_tags       = var.attached_resource.required_tags
  name                = var.attached_resource.name
  resource_group_name = var.attached_resource.resource_group_name
}

# This block will give an object of which attributes are private DNS zone names.
# Values will be private DNS zone data's regular output.
# Hence we need to create a for loop when calling later to access each of their ids.
data "azurerm_private_dns_zone" "private_dns_zones" {
  for_each = {
    for zone in var.private_dns_zone_group.private_dns_zones :
    zone.name => {
      name                = zone.name
      resource_group_name = zone.resource_group_name
    }
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = var.private_service_connection.name != null ? var.private_service_connection.name : "${var.name}-private-service-connection"
    private_connection_resource_id = data.azurerm_resources.attached_resource.resources[0].id
    is_manual_connection           = var.private_service_connection.is_manual_connection
    subresource_names              = var.private_service_connection.subresource_names
  }

  private_dns_zone_group {
    name = var.private_dns_zone_group.name != null ? var.private_dns_zone_group.name : "${var.name}-private-dns-zone-group"
    private_dns_zone_ids = [
      for k, zone in data.azurerm_private_dns_zone.private_dns_zones : zone.id
    ]
  }

  lifecycle {
    ignore_changes = [
      subnet_id,
      private_service_connection[0].private_connection_resource_id,
      private_dns_zone_group[0].private_dns_zone_ids
    ]
  }
}