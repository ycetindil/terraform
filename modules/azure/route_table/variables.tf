variable "name" {
  description = <<EOD
		(Required) The name of the route table.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) The name of the resource group in which to create the route table.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) Specifies the supported Azure location where the resource exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "routes" {
  description = <<EOD
		(Optional) List of objects representing routes.
		IMPORTANT: Use azurerm_route resource. This map is left blank intentionally.
		NOTE: Since route can be configured both inline and via the separate azurerm_route resource, we have to explicitly set it to empty slice ([]) to remove it.
	EOD
  default     = {}
  type        = map(object({}))
}

variable "disable_bgp_route_propagation" {
  description = <<EOD
		(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table.
		True means disable.
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