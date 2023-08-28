variable "name" {
  description = <<EOD
		 - (Required) The name of the virtual network peering.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "virtual_network_name" {
  description = <<EOD
		 - (Required) The name of the virtual network.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "remote_virtual_network_id" {
  description = <<EOD
		 - (Required) The full Azure resource ID of the remote virtual network.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		 - (Required) The name of the resource group in which to create the virtual network peering.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "allow_forwarded_traffic" {
  description = <<EOD
		 - (Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed.
		Defaults to false.
	EOD
  default     = null
  type        = bool
}