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
    (Required) SKU name of the Firewall.
    Possible values are AZFW_Hub and AZFW_VNet.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku_tier" {
  description = <<EOD
    (Required) SKU tier of the Firewall.
    Possible values are Premium,Standard, and Basic.
  EOD
  type        = string
}

variable "firewall_policy" {
  description = <<EOD
    (Optional) The existing Firewall Policy applied to this Firewall.
  EOD
  default     = null
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "ip_configuration" {
  description = <<EOD
    (Optional) An ip_configuration block as documented below.
    An ip_configuration block supports the following:
    - name - (Required) Specifies the name of the IP Configuration.
    - subnet - (Optional) Reference to the existing subnet associated with the IP Configuration.
      Changing this forces a new resource to be created.
      NOTE: The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least a /26.
      NOTE: At least one and only one ip_configuration block may contain a subnet.
    - public_ip_address - (Optional) Reference to the existing Public IP Address associated with the firewall.
      NOTE: A public ip address is required unless a management_ip_configuration block is specified.
      NOTE: The Public IP must have a Static allocation and Standard SKU.
      NOTE: When multiple ip_configuration blocks with public_ip_address are configured, terraform apply will raise an error when one or some of these ip_configuration blocks are removed. because the public_ip_address_id is still used by the firewall resource until the firewall resource is updated. and the destruction of azurerm_public_ip happens before the update of firewall by default. to destroy of azurerm_public_ip will cause the error. The workaround is to set create_before_destroy=true to the azurerm_public_ip resource lifecycle block. See more detail: destroying.md#create-before-destroy
  EOD
  default     = null
  type = object({
    name = string
    subnet = optional(object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    }), null)
    public_ip_address = optional(object({
      name                = string
      resource_group_name = string
    }), null)
  })
}

variable "management_ip_configuration" {
  description = <<EOD
    (Optional) A management_ip_configuration block as documented below, which allows force-tunnelling of traffic to be performed by the firewall.
    Adding or removing this block or changing the subnet_id in an existing block forces a new resource to be created.
    Changing this forces a new resource to be created.
    A management_ip_configuration block supports the following:
    - name - (Required) Specifies the name of the IP Configuration.
    - subnet - (Required) Reference to the existing subnet associated with the IP Configuration.
      Changing this forces a new resource to be created.
      NOTE: The Management Subnet used for the Firewall must have the name AzureFirewallManagementSubnet and the subnet mask must be at least a /26.
    - public_ip_address - (Required) Reference to the existing Public IP Address associated with the firewall.
      NOTE: The Public IP must have a Static allocation and Standard SKU.
  EOD
  default     = null
  type = object({
    name = string
    subnet = object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    })
    public_ip_address = object({
      name                = string
      resource_group_name = string
    })
  })
}

variable "virtual_hub" {
  description = <<EOD
    (Optional) Reference to the existing virtual_hub to ssociate with this firewall.
  EOD
  default     = null
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "firewall_network_rule_collections" {
  description = <<EOD
    (Optional) Created by azurerm_firewall_network_rule_collection subresource.
    A map of one or more firewall_network_rule_collections supports the following:
    - name - (Required) Specifies the name of the Network Rule Collection which must be unique within the Firewall.
      Changing this forces a new resource to be created.
    - firewall_name - (Required) Specifies the name of the Firewall in which the Network Rule Collection should be created.
      Provided by the module.
      Changing this forces a new resource to be created.
    - firewall_resource_group_name - (Required) Specifies the name of the Resource Group in which the Firewall exists.
      Provided by the module.
      Changing this forces a new resource to be created.
    - priority - (Required) Specifies the priority of the rule collection.
      Possible values are between 100-65000.
    - action - (Required) Specifies the action the rule will apply to matching traffic.
      Possible values are Allow and Deny.
    - rules - (Required) A map of one or more rule blocks supports the following:
      - name (required): Specifies the name of the rule.
      - description (optional): Specifies a description for the rule.
      - source_addresses (optional): A list of source IP addresses and/or IP ranges.
      - source_ip_groups (optional): A list of IP Group IDs for the rule.
      NOTE: At least one of source_addresses and source_ip_groups must be specified for a rule.
      - destination_addresses (optional): Either a list of destination IP addresses and/or IP ranges, or a list of destination Service Tags.
      - destination_ip_groups (optional): A list of destination IP Group IDs for the rule.
      - destination_fqdns (optional): A list of destination FQDNS for the rule.
        NOTE: You must enable DNS Proxy to use FQDNs in your network rules.
      NOTE: At least one of destination_addresses, destination_ip_groups and destination_fqdns must be specified for a rule.
      - destination_ports (required): A list of destination ports.
      - protocols (required): A list of protocols. Possible values are Any, ICMP, TCP and UDP.
  EOD
  default     = {}
  type = map(object({
    name     = string
    priority = number
    action   = string
    rules = map(object({
      name                  = string
      description           = optional(string, null)
      source_addresses      = optional(list(string), null)
      source_ip_groups      = optional(list(string), null)
      destination_addresses = optional(list(string), null)
      destination_ip_groups = optional(list(string), null)
      destination_fqdns     = optional(list(string), null)
      destination_ports     = list(string)
      protocols             = list(string)
    }))
  }))
}