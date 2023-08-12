variable "name" {
  description = <<EOD
    (Required) A map of zero or more ?????? blocks supports the following:
  EOD
  type = string
}

variable "name" {
  description = <<EOD
    (Required) A map of zero or more ?????? blocks supports the following:
  EOD
  type = string
}

variable "name" {
  description = <<EOD
    (Required) A map of zero or more ?????? blocks supports the following:
  EOD
  type = string
}

variable "name" {
  description = <<EOD
    (Required) A map of zero or more ?????? blocks supports the following:
  EOD
  type = string
}

variable "name" {
  description = <<EOD
    (Optional) A map of zero or more ?????? blocks supports the following:
  EOD
  type = string
}

    name                = string
    location            = string
    resource_group_name = string
    ip_configurations = map(object({
      name = string
      subnet = object({
        name                       = string
        virtual_network_name       = string
        subnet_resource_group_name = string
      })
      private_ip_address_allocation = string
      public_ip_address = optional(object({
        existing = optional(object({
          name                = string
          resource_group_name = string
        }), null)
        new = optional(any, null) // Pass directly to the 'network_security_group' module
      }), null)
    }))
    network_security_group = optional(object({
      existing = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      new = optional(any, null) // Pass directly to the 'network_security_group' module
    }), null)
  }))