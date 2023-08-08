variable "name" {
  description = <<EOD
    (Required) The name of the Managed Kubernetes Cluster to create.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) The location where the Managed Kubernetes Cluster should be created.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "dns_prefix" {
  description = <<EOD
    (Optional) DNS prefix specified when creating the managed cluster.
    Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length.
    Changing this forces a new resource to be created.
    NOTE: You must define either a dns_prefix or a dns_prefix_private_cluster field.
  EOD
  default     = null
  type        = string
}

variable "dns_prefix_private_cluster" {
  description = <<EOD
    (Optional) DNS prefix specified when creating the managed cluster.
    Possible values must begin and end with a letter or number, contain only letters, numbers, and hyphens and be between 1 and 54 characters in length.
    Changing this forces a new resource to be created.
    NOTE: You must define either a dns_prefix or a dns_prefix_private_cluster field.
  EOD
  default     = null
  type        = string
}

variable "node_resource_group" {
  description = <<EOD
    node_resource_group - (Optional) The name of the Resource Group where the Kubernetes Nodes should exist.
    Changing this forces a new resource to be created.
    NOTE: Azure requires that a new, non-existent Resource Group is used, as otherwise, the provisioning of the Kubernetes Service will fail.
  EOD
  default     = null
  type        = string
}

variable "private_cluster_enabled" {
  description = <<EOD
    (Optional) Should this Kubernetes Cluster have its API server only exposed on internal IP addresses?
    This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located.
    Defaults to false.
    Changing this forces a new resource to be created.
  EOD
  default     = null
  type        = bool
}

variable "public_network_access_enabled" {
  description = <<EOD
    (Optional) Whether public network access is allowed for this Kubernetes Cluster.
    Defaults to true.
    Changing this forces a new resource to be created.
  EOD
  default     = null
  type        = bool
}

variable "default_node_pool" {
  description = <<EOD
    (Required) A default_node_pool block supports the following:
    - name - (Required) The name which should be used for the default Kubernetes Node Pool.
      Changing this forces a new resource to be created.
    - vm_size - (Required) The size of the Virtual Machine, such as Standard_DS2_v2.
      temporary_name_for_rotation must be specified when attempting a resize.
    - vnet_subnet - (Optional) The existing Subnet where the Kubernetes Node Pool should exist.
      Changing this forces a new resource to be created.
      NOTE: A Route Table must be configured on this Subnet.
    - node_count - (Optional) The initial number of nodes which should exist in this Node Pool.
      If specified this must be between 1 and 1000 and between min_count and max_count.
    NOTE: Changing certain properties of the default_node_pool is done by cycling the system node pool of the cluster.
    temporary_name_for_rotation must be specified when changing any of the following properties: enable_host_encryption, enable_node_public_ip, kubelet_config, linux_os_config, max_pods, node_taints, only_critical_addons_enabled, os_disk_size_gb, os_disk_type, os_sku, pod_subnet_id, ultra_ssd_enabled, vnet_subnet_id, vm_size, zones.
  EOD
  type = object({
    name    = string
    vm_size = string
    vnet_subnet = optional(object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    }), null)
    node_count = optional(number, null)
  })
}

variable "identity" {
  description = <<EOD
    (Optional) An identity block supports the following:
    - type - (Required) Specifies the type of Managed Service Identity that should be configured on this Kubernetes Cluster.
      Possible values are SystemAssigned or UserAssigned.
    - identity_ids - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster.
      Gathered by the module by requesting the references to the User Assigned Managed Identity list.
      NOTE: This is required when type is set to UserAssigned.
    NOTE: One of either identity or service_principal must be specified.
  EOD
  default     = null
  type = object({
    type = string
    user_assigned_identities = optional(list(object({
      name                = string
      resource_group_name = string
    })), null)
  })
}

variable "network_profile" {
  description = <<EOD
    (Optional) A network_profile block supports the following:
    - network_plugin - (Required) Network plugin to use for networking.
      Currently supported values are azure, kubenet and none.
      Changing this forces a new resource to be created.
      NOTE: When network_plugin is set to azure - the pod_cidr field must not be set.
    - network_policy - (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods.
      Currently supported values are calico and azure.
      Changing this forces a new resource to be created.
      NOTE: When network_policy is set to azure, the network_plugin field can only be set to azure.
    - dns_service_ip - (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns).
      Changing this forces a new resource to be created.
    - outbound_type - (Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster.
      Possible values are loadBalancer, userDefinedRouting, managedNATGateway and userAssignedNATGateway.
      Defaults to loadBalancer.
      Changing this forces a new resource to be created.
    - service_cidr - (Optional) The Network Range used by the Kubernetes service.
      Changing this forces a new resource to be created.
    Changing this forces a new resource to be created.
    NOTE: If network_profile is not defined, kubenet profile will be used by default.
  EOD
  default     = null
  type = object({
    network_plugin = string
    network_policy = optional(string, null)
    dns_service_ip = optional(string, null)
    outbound_type  = optional(string, null)
    service_cidr   = optional(string, null)
  })
}

variable "ingress_application_gateway" {
  description = <<EOD
    (Optional) A ingress_application_gateway block supports the following:
    - gateway_id - (Optional) The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster. See https://docs.microsoft.com/azure/application-gateway/tutorial-ingress-controller-add-on-existing for further details.
    - gateway_name - (Optional) The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. See https://docs.microsoft.com/azure/application-gateway/tutorial-ingress-controller-add-on-new for further details.
    - subnet_cidr - (Optional) The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. See https://docs.microsoft.com/azure/application-gateway/tutorial-ingress-controller-add-on-new for further details.
    - subnet - (Optional) The existing subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. See https://docs.microsoft.com/azure/application-gateway/tutorial-ingress-controller-add-on-new for further details.
    NOTE: If specifying ingress_application_gateway in conjunction with only_critical_addons_enabled, the AGIC pod will fail to start. A separate azurerm_kubernetes_cluster_node_pool is required to run the AGIC pod successfully. This is because AGIC is classed as a "non-critical addon".
  EOD
  default     = null
  type = object({
    gateway_id   = optional(string, null)
    gateway_name = optional(string, null)
    subnet_cidr  = optional(string, null)
    subnet = optional(object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    }), null)
  })
}