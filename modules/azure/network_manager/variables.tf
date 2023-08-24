variable "name" {
  description = <<EOD
		(Required) Specifies the name which should be used for this Network Managers.
		Changing this forces a new Network Managers to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) Specifies the name of the Resource Group where the Network Managers should exist.
		Changing this forces a new Network Managers to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) Specifies the Azure Region where the Network Managers should exist.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "scope" {
  description = <<EOD
		(Required) A scope block as defined below.
		A scope block supports the following:
		- management_group_ids - (Optional) A list of management group IDs.
		- subscription_ids - (Optional) A list of subscription IDs.
	EOD
  type = object({
    management_group_ids = optional(list(string))
    subscription_ids     = optional(list(string))
  })
}

variable "scope_accesses" {
  description = <<EOD
		(Required) A list of configuration deployment type.
		Possible values are Connectivity and SecurityAdmin, corresponds to if Connectivity Configuration and Security Admin Configuration is allowed for the Network Manager.
	EOD
  type        = list(string)
}

variable "description" {
  description = <<EOD
		(Optional) A description of the network manager.
	EOD
  default     = null
  type        = string
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags which should be assigned to the Network Managers.
	EOD
  default     = null
  type        = map(string)
}