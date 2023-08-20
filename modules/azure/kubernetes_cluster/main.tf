# Manages a Managed Kubernetes Cluster (also known as AKS / Azure Kubernetes Service)
# Note: Due to the fast-moving nature of AKS, we recommend using the latest version of the Azure Provider when using AKS.
# Note: All arguments including the client secret will be stored in the raw state as plain-text. Read more about sensitive data in state at https://www.terraform.io/docs/state/sensitive-data.html.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  default_node_pool {
    name                = var.default_node_pool.name
    vm_size             = var.default_node_pool.vm_size
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    max_count           = var.default_node_pool.max_count
    min_count           = var.default_node_pool.min_count
    node_count          = var.default_node_pool.node_count
  }

  dns_prefix                 = var.dns_prefix
  dns_prefix_private_cluster = var.dns_prefix_private_cluster

  dynamic "identity" {
    for_each = var.identity != null ? [1] : [0]

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway != null ? [1] : []

    content {
      gateway_id   = var.ingress_application_gateway.gateway_id
      gateway_name = var.ingress_application_gateway.gateway_name
      subnet_cidr  = var.ingress_application_gateway.subnet_cidr
      subnet_id    = var.ingress_application_gateway.subnet_id
    }
  }

  dynamic "network_profile" {
    for_each = var.network_profile != null ? [1] : []

    content {
      network_plugin = var.network_profile.network_plugin
      network_policy = var.network_profile.network_policy
      dns_service_ip = var.network_profile.dns_service_ip
      outbound_type  = var.network_profile.outbound_type
      service_cidr   = var.network_profile.service_cidr
    }
  }

  node_resource_group           = var.node_resource_group
  private_cluster_enabled       = var.private_cluster_enabled
  public_network_access_enabled = var.public_network_access_enabled
}