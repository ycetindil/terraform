# Manages a Network Manager Connectivity Configuration.
# Note: The azurerm_network_manager_connectivity_configuration deployment may modify or delete existing Network Peering resource.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_connectivity_configuration
resource "azurerm_network_manager_connectivity_configuration" "network_manager_connectivity_configuration" {
  name               = var.name
  network_manager_id = var.network_manager_id

  applies_to_group {
    group_connectivity  = var.applies_to_group.group_connectivity
    network_group_id    = var.applies_to_group.network_group_id
    global_mesh_enabled = var.applies_to_group.global_mesh_enabled
    use_hub_gateway     = var.applies_to_group.use_hub_gateway
  }

  connectivity_topology           = var.connectivity_topology
  delete_existing_peering_enabled = var.delete_existing_peering_enabled
  description                     = var.description
  global_mesh_enabled             = var.global_mesh_enabled

  dynamic "hub" {
    for_each = var.hub != null ? [1] : []

    content {
      resource_id   = var.hub.resource_id
      resource_type = var.hub.resource_type
    }
  }
}