variable "service_plan_xxx" {
  name     = "asp-project101-prod-eastus-001"
  location = "eastus"
  # resource_group_name is provided by the root main.
  os_type  = "Windows"
  sku_name = "S1"
}