# Manages a Network Manager Deployment.
# NOTE on Virtual Network Peering: Using Network Manager Deployment to deploy Connectivity Configuration may modify or delete existing Virtual Network Peering. At this time you should not use Network Peering resource in conjunction with Network Manager Deployment. Doing so may cause a conflict of Peering configurations.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_deployment
resource "azurerm_network_manager_deployment" "network_manager_deployment" {
  network_manager_id = var.network_manager_id
  location           = var.deployment.location
  scope_access       = var.deployment.scope_access
  configuration_ids  = var.configuration_ids
  triggers           = var.triggers
}