variable "name" {
  description = <<EOD
		(Required) The name of the Private DNS Zone Virtual Network Link.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "private_dns_zone_name" {
  description = <<EOD
		(Required) The name of the Private DNS zone (without a terminating dot).
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) Specifies the resource group where the Private DNS Zone exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "virtual_network_id" {
  description = <<EOD
		(Required) The ID of the Virtual Network that should be linked to the DNS Zone.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "registration_enabled" {
  description = <<EOD
		(Optional) Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?
		Defaults to false.
	EOD
  default     = null
  type        = bool
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags to assign to the resource.
	EOD
  default     = null
  type        = map(string)
}