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