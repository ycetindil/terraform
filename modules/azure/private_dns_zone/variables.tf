variable "name" {
  description = "https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_links" {
  type = map(object({
    name                = string
    resource_group_name = optional(string, null)
    virtual_network = object({
      name                = string
      resource_group_name = string
    })
  }))
}
