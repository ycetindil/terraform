variable "name" {
  type = string
}

variable "virtual_network" {
  default = null
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "address_prefixes" {
  type = list(string)
}

variable "private_link_service_network_policies_enabled" {
  default = null
  type    = bool
}

variable "delegation" {
  description = <<EOD
    Possible values for 'service_delegation.name' are listed at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#name
    Possible values for 'service_delegation.actions' are listed at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#actions
  EOD
  default     = null
  type = object({
    name = string
    service_delegation = object({
      name    = string
      actions = optional(list(string), null)
    })
  })
}