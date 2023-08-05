variable "name" {
  description = <<EOD
    The name which should be used for this Firewall Policy Rule Collection Group.
	Changing this forces a new Firewall Policy Rule Collection Group to be created.
  EOD
  type        = string
}

variable "firewall_policy_id" {
  description = <<EOD
    The ID of the Firewall Policy where the Firewall Policy Rule Collection Group should exist.
	Changing this forces a new Firewall Policy Rule Collection Group to be created.
  EOD
  type        = string
}

variable "priority" {
  description = <<EOD
    The priority of the Firewall Policy Rule Collection Group.
	The range is 100-65000.
  EOD
  type        = number
}

variable "network_rule_collections" {
  description = <<EOD
    A network_rule_collection block supports the following:
	- name: The name which should be used for this network rule collection.
	- action: The action to take for the network rules in this collection. Possible values are Allow and Deny.
	- priority: The priority of the network rule collection. The range is 100-65000.
	- rule: One or more network_rule (network rule) blocks support the following:
		- name The name which should be used for this rule.
		- protocols: Specifies a list of network protocols this rule applies to. Possible values are Any, TCP, UDP, ICMP.
		- destination_ports: Specifies a list of destination ports.
		- source_addresses: Specifies a list of source IP addresses (including CIDR, IP range and *).
		- source_ip_groups: Specifies a list of source IP groups.
		- destination_addresses: Specifies a list of destination IP addresses (including CIDR, IP range and *) or Service Tags.
		- destination_ip_groups: Specifies a list of destination IP groups.
		- destination_fqdns: Specifies a list of destination FQDNs.
  EOD
  default     = {}
  type = map(object({
    name     = string
    action   = string
    priority = number
    rules = optional(map(object({
      name                  = string
      protocols             = list(string)
      destination_ports     = list(string)
      source_addresses      = optional(list(string), null)
      source_ip_groups      = optional(list(string), null)
      destination_addresses = optional(list(string), null)
      destination_ip_groups = optional(list(string), null)
      destination_fqdns     = optional(list(string), null)
    })), {})
  }))
}