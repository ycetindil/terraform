variable "virtual_network_xxx" {
  name     = "vnet-project101-prod-eastus-101"
  location = "eastus"
  # resource_group_name is provided by the root main.
  address_space = ["10.1.0.0/16"]
}