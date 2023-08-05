variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Firewall Policy.
    Changing this forces a new Firewall Policy to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) The Azure Region where the Firewall Policy should exist.
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
    (Optional) The SKU Tier of the Firewall Policy. Possible values are:
    - Standard
    - Premium
    - Basic
    Changing this forces a new Firewall Policy to be created.
  EOD
  default     = null
  type        = string
}

variable "rule_collection_groups" {
  description = <<EOD
    (Optional) The map of the rule collection groups of this Firewall Policy.
    Passed directly to the 'firewall_policy_rule_collection_group' module.
  EOD
  default     = {}
  type        = any
}