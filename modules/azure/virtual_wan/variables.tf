variable "name" {
  description = <<EOD
		 - (Required) Specifies the name of the Virtual WAN.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		 - (Required) The name of the resource group in which to create the Virtual WAN.
		 Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		 - (Required) Specifies the supported Azure location where the resource exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}