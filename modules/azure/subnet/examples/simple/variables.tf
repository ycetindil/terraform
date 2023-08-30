variable "subnet_xxx" {
  name = "snet-project101-prod-eastus-001"
  # resource_group_name is provided by the root main.
  # virtual_network_name is provided by the root main.
  address_prefixes = ["10.1.1.0/24"]
}