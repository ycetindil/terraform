variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Firewall Policy Rule Collection Group.
    Changing this forces a new Firewall Policy Rule Collection Group to be created.
  EOD
  type        = string
}

variable "firewall_policy_id" {
  description = <<EOD
    (Required) The ID of the Firewall Policy where the Firewall Policy Rule Collection Group should exist.
    Changing this forces a new Firewall Policy Rule Collection Group to be created.
  EOD
  type        = string
}

variable "priority" {
  description = <<EOD
    (Required) The priority of the Firewall Policy Rule Collection Group.
    The range is 100-65000.
  EOD
  type        = number
}

variable "network_rule_collections" {
  description = <<EOD
    (Optional) One or more network_rule_collection blocks as defined below.
    A network_rule_collection block supports the following:
    - name (required): The name which should be used for this network rule collection.
    - action (required): The action to take for the network rules in this collection.
      Possible values are Allow and Deny.
    - priority (required): The priority of the network rule collection.
      The range is 100-65000.
    - rules (Required) One or more network_rule (network rule) blocks as defined below.
      A network_rule (network rule) block supports the following:
      - name (required): The name which should be used for this rule.
      - protocols (required): Specifies a list of network protocols this rule applies to.
        Possible values are Any, TCP, UDP, ICMP.
      - destination_ports (required): Specifies a list of destination ports.
      - source_addresses (optional): Specifies a list of source IP addresses (including CIDR, IP range and *).
      - source_ip_groups (optional): Specifies a list of source IP groups.
      - destination_addresses (optional): Specifies a list of destination IP addresses (including CIDR, IP range and *) or Service Tags.
      - destination_ip_groups (optional): Specifies a list of destination IP groups.
      - destination_fqdns (optional): Specifies a list of destination FQDNs.
  EOD
  default     = {}
  type = map(object({
    name     = string
    action   = string
    priority = number
    rules = map(object({
      name                  = string
      protocols             = list(string)
      destination_ports     = list(string)
      source_addresses      = optional(list(string), null)
      source_ip_groups      = optional(list(string), null)
      destination_addresses = optional(list(string), null)
      destination_ip_groups = optional(list(string), null)
      destination_fqdns     = optional(list(string), null)
    }))
  }))
}