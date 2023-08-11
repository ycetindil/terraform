variable "location" {
  description = <<EOD
    (Required) The Azure Region where the Firewall Policy should exist.
    Changing this forces a new Firewall Policy to be created.
  EOD
  type        = string
}

variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Firewall Policy.
    Changing this forces a new Firewall Policy to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group where the Firewall Policy should exist.
    Changing this forces a new Firewall Policy to be created.
  EOD
  type        = string
}

variable "sku" {
  description = <<EOD
    (Optional) The SKU Tier of the Firewall Policy.
    Possible values are Standard, Premium, and Basic.
    Changing this forces a new Firewall Policy to be created.
  EOD
  default     = null
  type        = string
}

variable "firewall_policy_rule_collection_groups" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_firewall_policy_rule_collection_group subresource.
    A map of zero or more firewall_policy_rule_collection_group blocks supports the following:
    - name - (Required) The name which should be used for this Firewall Policy Rule Collection Group.
      Changing this forces a new Firewall Policy Rule Collection Group to be created.
    - firewall_policy_id - (Required) The ID of the Firewall Policy where the Firewall Policy Rule Collection Group should exist.
      Provided by the module.
      Changing this forces a new Firewall Policy Rule Collection Group to be created.
    - priority - (Required) The priority of the Firewall Policy Rule Collection Group.
      The range is 100-65000.
    - network_rule_collections - (Optional) A map of one or more network_rule_collection blocks supports the following:
      - name (required): The name which should be used for this network rule collection.
      - action (required): The action to take for the network rules in this collection.
        Possible values are Allow and Deny.
      - priority (required): The priority of the network rule collection. The range is 100-65000.
      - rules (required): A map of one or more rule blocks supports the following:
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
    priority = string
    network_rule_collections = optional(map(object({
      name     = string
      action   = string
      priority = number
      rules = map(object({
        name                  = string
        source_addresses      = optional(list(string), null)
        source_ip_groups      = optional(list(string), null)
        destination_addresses = optional(list(string), null)
        destination_ip_groups = optional(list(string), null)
        destination_fqdns     = optional(list(string), null)
        destination_ports     = list(string)
        protocols             = list(string)
      }))
    })), {})
  }))
}