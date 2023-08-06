variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "service_plan" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "app_settings" {
  default = null
  type    = map(string)
}

variable "tags" {
  default = null
  type    = map(string)
}

variable "subnet" {
  default = null
  type = object({
    name                       = string
    virtual_network_name       = string
    subnet_resource_group_name = string
  })
}

variable "identity" {
  default = null
  type = object({
    type = string
  })
}

variable "site_config" {
  type = object({
    container_registry_use_managed_identity = optional(bool, null)
    vnet_route_all_enabled                  = optional(bool, null)
    always_on                               = optional(bool, null)
  })
}