variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "security_rules" {
  default = {}
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = optional(string, null)
    destination_port_range     = optional(string, null)
    source_address_prefix      = optional(string, null)
    destination_address_prefix = optional(string, null)
  }))
}