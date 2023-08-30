variable "public_ip_address_xxx" {
  name     = "pip-project101-prod-eastus-001"
  location = "eastus"
  # resource_group_name is provided by the root main.
  allocation_method = "Static"
  sku               = "Standard"
}