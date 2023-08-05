variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Network Rule Collection which must be unique within the Firewall.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "firewall_name" {
  description = <<EOD
    (Required) Specifies the name of the Firewall in which the Network Rule Collection should be created.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "firewall_resource_group_name" {
  description = <<EOD
    (Required) Specifies the name of the Resource Group in which the Firewall exists.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "priority" {
  description = <<EOD
    (Required) Specifies the priority of the rule collection.
    Possible values are between 100-65000.
  EOD
  type        = number
}

variable "action" {
  description = <<EOD
    (Required) Specifies the action the rule will apply to matching traffic.
    Possible values are Allow and Deny.
  EOD
  type        = string
}

variable "rules" {
  description = <<EOD
    (Required) One or more rule blocks support the following:
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
  type = map(object({
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
}