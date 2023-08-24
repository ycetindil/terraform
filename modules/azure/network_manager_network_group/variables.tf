variable "name" {
  description = <<EOD
		(Required) Specifies the name which should be used for this Network Manager Network Group.
		Changing this forces a new Network Manager Network Group to be created.
	EOD
  type        = string
}

variable "network_manager_id" {
  description = <<EOD
		(Required) Specifies the ID of the Network Manager.
		Changing this forces a new Network Manager Network Group to be created.
	EOD
  type        = string
}

variable "description" {
  description = <<EOD
		(Optional) A description of the Network Manager Network Group.
	EOD
  default     = null
  type        = string
}