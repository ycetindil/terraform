variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Firewall.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) Specifies the supported Azure location where the resource exists.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to create the resource.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku_name" {
  description = <<EOD
    (Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku_tier" {
  description = <<EOD
    (Required) SKU tier of the Firewall. Possible values are Premium,Standard, and Basic.
  EOD
  type        = string
}

variable "firewall_policy" {
  description = <<EOD
    (Optional) The Firewall Policy applied to this Firewall.
    'firewall_policy.new' is passed directly to the 'firewall_policy' module.
  EOD
  default     = null
  type = object({
    existing = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    new = optional(any, null)
  })
  validation {
    condition     = var.firewall_policy == null || ((var.firewall_policy.existing != null && var.firewall_policy.new == null) || (var.firewall_policy.existing == null && var.firewall_policy.new != null))
    error_message = "'firewall_policy' should be either 'existing' or 'new', or none!"
  }
}

variable "ip_configuration" {
  description = <<EOD
    (Optional) An ip_configuration block supports the following:
    - name (required): Specifies the name of the IP Configuration.
    - subnet (required): Reference to the subnet associated with the IP Configuration.
      Changing this forces a new resource to be created.
      'subnet.new' is passed directly to the 'subnet' module.
      NOTE: The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least a /26.
      NOTE: At least one and only one ip_configuration block may contain a subnet.
    - public_ip_address (required): The Public IP Address associated with the firewall.
      'public_ip_address.new' is passed directly to the 'public_ip_address' module.
      NOTE: A public ip address is required unless a management_ip_configuration block is specified.
      NOTE: The Public IP must have a Static allocation and Standard SKU.
      NOTE: When multiple ip_configuration blocks with public_ip_address are configured, terraform apply will raise an error when one or some of these ip_configuration blocks are removed. because the public_ip_address_id is still used by the firewall resource until the firewall resource is updated. and the destruction of azurerm_public_ip happens before the update of firewall by default. to destroy of azurerm_public_ip will cause the error. The workaround is to set create_before_destroy=true to the azurerm_public_ip resource lifecycle block. See more detail: destroying.md#create-before-destroy
  EOD
  default     = null
  type = object({
    name = string
    subnet = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null)
    })
    public_ip_address = optional(object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null)
    }), null)
  })
  # Either 'ip_configuration' is null,
  # or exactly one of 'ip_configuration.subnet.existing' and 'ip_configuration.subnet.new' has a value.
  validation {
    condition = (
      var.ip_configuration == null ||
      (
        (try(var.ip_configuration.subnet.existing, null) != null && try(var.ip_configuration.subnet.new, null) == null) ||
        (try(var.ip_configuration.subnet.existing, null) == null && try(var.ip_configuration.subnet.new, null) != null)
      )
    )
    error_message = "'ip_configuration.subnet' should be either 'existing' or 'new', not both, not none!"
  }
  # Either 'ip_configuration' is null,
  # or 'ip_configuration.public_ip_address' is null,
  # or exactly one of 'ip_configuration.public_ip_address.existing' and 'ip_configuration.public_ip_address.new' has a value.
  validation {
    condition = (
      var.ip_configuration == null ||
      try(var.ip_configuration.public_ip_address, null) == null ||
      !(try(var.ip_configuration.public_ip_address.existing, null) != null && try(var.ip_configuration.public_ip_address.new, null) != null)
    )
    error_message = "'ip_configuration.public_ip_address' should be either 'existing' or 'new', or none!"
  }
}

variable "management_ip_configuration" {
  description = <<EOD
    (Optional) A management_ip_configuration block supports the following:
    - name (required): Specifies the name of the Management IP Configuration.
    - subnet (required): Reference to the subnet associated with the Management IP Configuration.
      Changing this forces a new resource to be created.
      'subnet.new' is passed directly to the 'subnet' module.
      NOTE: The Management Subnet used for the Firewall must have the name AzureFirewallManagementSubnet and the subnet mask must be at least a /26.
    - public_ip_address (required): The Public IP Address associated with the firewall.
      'public_ip_address.new' is passed directly to the 'public_ip_address' module.
      NOTE: The Public IP must have a Static allocation and Standard SKU.
  EOD
  default     = null
  type = object({
    name = string
    subnet = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null)
    })
    public_ip_address = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null)
    })
  })
  # Either 'management_ip_configuration' is null,
  # or exactly one of 'management_ip_configuration.subnet.existing' and 'management_ip_configuration.subnet.new' has a value.
  validation {
    condition = (
      var.management_ip_configuration == null ||
      (
        (try(var.management_ip_configuration.subnet.existing, null) != null && try(var.management_ip_configuration.subnet.new, null) == null) ||
        (try(var.management_ip_configuration.subnet.existing, null) == null && try(var.management_ip_configuration.subnet.new, null) != null)
      )
    )
    error_message = "'management_ip_configuration.subnet' should be either 'existing' or 'new', not both, not none!"
  }
  # Either 'management_ip_configuration' is null,
  # or exactly one of 'management_ip_configuration.public_ip_address.existing' and 'management_ip_configuration.public_ip_address.new' has a value.
  validation {
    condition = (
      var.management_ip_configuration == null ||
      (
        (try(var.management_ip_configuration.public_ip_address.existing, null) != null && try(var.management_ip_configuration.public_ip_address.new, null) == null) ||
        (try(var.management_ip_configuration.public_ip_address.existing, null) == null && try(var.management_ip_configuration.public_ip_address.new, null) != null)
      )
    )
    error_message = "'management_ip_configuration.public_ip_address' should be either 'existing' or 'new', not both, not none!"
  }
}

variable "virtual_hub" {
  description = <<EOD
    (Optional) A virtual_hub block specifies the Virtual Hub where the Firewall resides in.
  EOD
  default     = null
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "firewall_network_rule_collections" {
  description = <<EOD
    (Optional) A map of the Firewall Network Rule Collections of this firewall.
    Passed directly to the 'firewall_network_rule_collection' module.
  EOD
  default     = {}
  type        = any
}