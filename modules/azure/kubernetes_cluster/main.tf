data "azurerm_subnet" "subnet_aks" {
  name                 = var.subnet_aks.name
  virtual_network_name = var.subnet_aks.virtual_network_name
  resource_group_name  = var.subnet_aks.resource_group_name
}

data "azurerm_subnet" "subnet_agw" {
  name                 = var.subnet_agw.name
  virtual_network_name = var.subnet_agw.virtual_network_name
  resource_group_name  = var.subnet_agw.resource_group_name
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  dns_prefix                    = "${var.name}-dns"
  node_resource_group           = "${var.name}-node-rg"
  public_network_access_enabled = var.public_network_access_enabled
  private_cluster_enabled       = var.private_cluster_enabled

  default_node_pool {
    name           = var.default_node_pool.name
    node_count     = var.default_node_pool.node_count
    vm_size        = var.default_node_pool.vm_size
    vnet_subnet_id = data.azurerm_subnet.subnet_aks.id
  }

  identity {
    type = var.identity.type
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway.enabled ? [1] : []

    content {
      gateway_name = var.ingress_application_gateway.name
      subnet_id    = data.azurerm_subnet.subnet_agw.id
    }
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    service_cidr       = var.network_profile.service_cidr
    dns_service_ip     = var.network_profile.dns_service_ip
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    outbound_type      = var.network_profile.outbound_type
  }
}