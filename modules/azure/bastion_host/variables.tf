variable "name" {
  description = <<EOD
    Specifies the name of the Bastion Host.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    Specifies the supported Azure location where the resource exists.
    Changing this forces a new resource to be created.
    Review https://learn.microsoft.com/en-us/azure/bastion/bastion-faq for supported locations.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    The name of the resource group in which to create the Bastion Host.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "ip_configuration" {
  description = <<EOD
    A ip_configuration block supports the following:
    - name: The name of the IP configuration.
      Changing this forces a new resource to be created.
    - subnet: Reference to a subnet in which this Bastion Host has been created.
      Changing this forces a new resource to be created.
      Note: The Subnet used for the Bastion Host must have the name AzureBastionSubnet and the subnet mask must be at least a /26.
    - public_ip_address: Reference to a Public IP Address to associate with this Bastion Host.
      Changing this forces a new resource to be created.
    Changing ip_configuration block forces a new resource to be created.
  EOD
  type = object({
    name = string
    subnet = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any) // Pass directly to the 'subnet' module.
    })
    public_ip_address = object({
      existing = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      new = optional(any) // Pass directly to the 'public_ip_address' module.
    })
  })
  validation {
    condition = (
      (var.ip_configuration.subnet.existing != null && var.ip_configuration.subnet.new == null) ||
      (var.ip_configuration.subnet.existing == null && var.ip_configuration.subnet.new != null)
    )
    error_message = "'subnet' should be either 'existing' or 'new', not both, not none!"
  }
  validation {
    condition = (
      (var.ip_configuration.public_ip_address.existing != null && var.ip_configuration.public_ip_address.new == null) ||
      (var.ip_configuration.public_ip_address.existing == null && var.ip_configuration.public_ip_address.new != null)
    )
    error_message = "'public_ip_address' should be either 'existing' or 'new', not both, not none!"
  }
}