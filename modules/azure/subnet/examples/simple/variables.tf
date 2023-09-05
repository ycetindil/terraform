variable "snet_project102_prod_eastus_001" { // aks
	name             = "snet-project102-prod-eastus-001"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.1.1.0/24"]
}