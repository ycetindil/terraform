variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet" {
  type = object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
  })
}

variable "attached_resource" {
  description = "https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers"
  type = object({
    name                = optional(string, null)
    type                = optional(string, null)
    required_tags       = optional(map(string), {})
    resource_group_name = optional(string, null)
  })
}

variable "private_service_connection" {
  description = "https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview"
  type = object({
    name                 = optional(string, null)
    is_manual_connection = bool
    subresource_names    = list(string)
  })
}

variable "private_dns_zone_group" {
  type = object({
    name = optional(string, null)
    private_dns_zones = list(object({
      name                = string
      resource_group_name = string
    }))
  })
}