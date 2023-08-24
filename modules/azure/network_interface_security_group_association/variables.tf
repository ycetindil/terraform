variable "network_interface_id" {
  description = <<EOD
		(Required) The ID of the Network Interface.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "network_security_group_id" {
  description = <<EOD
		(Required) The ID of the Network Security Group which should be attached to the Network Interface.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}