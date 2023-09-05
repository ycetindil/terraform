variable "vnet_project102_prod_eastus_001" { // app
  name                = "vnet-project102-prod-eastus-001"
  # resource_group_name is provided by the root 'main.tf'.
  address_space       = ["10.1.0.0/16"]
  location            = "East US"
}