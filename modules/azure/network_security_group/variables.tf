variable "name" {
  description = <<EOD
    (Required) Specifies the name of the network security group.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) The name of the resource group in which to create the network security group.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) Specifies the supported Azure location where the resource exists.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "tags" {
  description = <<EOD
    (Optional) A mapping of tags to assign to the resource.
  EOD
  default     = null
  type        = map(string)
}

variable "network_security_rules" {
  description = <<EOD
    (Optional) Created by azurerm_network_security_rule subresource.
    A map of zero or more network_security_rule blocks supports the following:
    - name - (Required) The name of the security rule.
      This needs to be unique across all Rules in the Network Security Group.
      Changing this forces a new resource to be created.
    - resource_group_name - (Required) The name of the resource group in which to create the Network Security Rule.
      IMPORTANT: Provided by the module.
      Changing this forces a new resource to be created.
    - network_security_group_name - (Required) The name of the Network Security Group that we want to attach the rule to.
      IMPORTANT: Provided by the module.
      Changing this forces a new resource to be created.
    - description - (Optional) A description for this rule.
      Restricted to 140 characters.
    - protocol - (Required) Network protocol this rule applies to.
      Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all).
    - source_port_range - (Optional) Source Port or Range.
      Integer or range between 0 and 65535 or * to match any.
      This is required if source_port_ranges is not specified.
    - source_port_ranges - (Optional) List of source ports or port ranges.
      This is required if source_port_range is not specified.
    - destination_port_range - (Optional) Destination Port or Range.
      Integer or range between 0 and 65535 or * to match any.
      This is required if destination_port_ranges is not specified.
    - destination_port_ranges - (Optional) List of destination ports or port ranges.
      This is required if destination_port_range is not specified.
    - source_address_prefix - (Optional) CIDR or source IP range or * to match any IP.
      Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used.
      This is required if source_address_prefixes is not specified.
    - source_address_prefixes - (Optional) List of source address prefixes.
      Tags may not be used.
      This is required if source_address_prefix is not specified.
    - source_application_security_group_ids - (Optional) A List of source Application Security Group IDs.
    - destination_address_prefix - (Optional) CIDR or destination IP range or * to match any IP.
      Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used.
      Besides, it also supports all available Service Tags like 'Sql.WestEurope', 'Storage.EastUS', etc.
      You can list the available service tags with the CLI: shell az network list-service-tags --location westcentralus. For further information please see https://docs.microsoft.com/cli/azure/network?view=azure-cli-latest#az-network-list-service-tags.
      This is required if destination_address_prefixes is not specified.
    - destination_address_prefixes - (Optional) List of destination address prefixes.
      Tags may not be used.
      This is required if destination_address_prefix is not specified.
    - destination_application_security_group_ids - (Optional) A List of destination Application Security Group IDs.
    - access - (Required) Specifies whether network traffic is allowed or denied.
      Possible values are Allow and Deny.
    - priority - (Required) Specifies the priority of the rule.
      The value can be between 100 and 4096.
      The priority number must be unique for each rule in the collection.
      The lower the priority number, the higher the priority of the rule.
    - direction - (Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic.
      Possible values are Inbound and Outbound.
  EOD
  default     = {}
  type = map(object({
    name                                       = string
    description                                = optional(string, null)
    protocol                                   = string
    source_port_range                          = optional(string, null)
    source_port_ranges                         = optional(list(string), null)
    destination_port_range                     = optional(string, null)
    destination_port_ranges                    = optional(list(string), null)
    source_address_prefix                      = optional(string, null)
    source_address_prefixes                    = optional(list(string), null)
    destination_address_prefix                 = optional(string, null)
    destination_address_prefixes               = optional(list(string), null)
    destination_application_security_group_ids = optional(list(string), null)
    access                                     = string
    priority                                   = number
    direction                                  = string
  }))
}

variable "subnet_network_security_group_association_subnets" {
  description = <<EOD
    (Optional) A map of zero or more blocks supports the following:
    - name (Required) - Specifies the name of the Subnet.
    - virtual_network_name (Required) - Specifies the name of the Virtual Network this Subnet is located within.
    - resource_group_name (Required) - Specifies the name of the resource group the Virtual Network is located in.
  EOD
  default     = {}
  type = map(object({
    name                 = string
    virtual_network_name = string
    resource_group_name  = string
  }))
}

variable "network_interface_security_group_association_network_interfaces" {
  description = <<EOD
    (Optional) A map of zero or more blocks supports the following:
    - name (Required) - Specifies the name of the Network Interface.
    - resource_group_name (Required) - Specifies the name of the resource group the Network Interface is located in.
  EOD
  default     = {}
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}