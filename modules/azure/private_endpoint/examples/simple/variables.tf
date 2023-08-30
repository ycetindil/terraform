variable "private_endpoint_xxx" {
  location = "eastus"
  private_service_connection = {
    is_manual_connection = false
    subresource_names    = ["sqlServer"]
  }
  private_dns_zone_group = {
    name = "privatelink.database.windows.net"
  }
}