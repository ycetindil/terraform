variable "name" {
  description = <<EOD
		(Required) The name of the Virtual Hub.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) Specifies the name of the Resource Group where the Virtual Hub should exist.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) Specifies the supported Azure location where the Virtual Hub should exist.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "address_prefix" {
  description = <<EOD
		(Required) The Address Prefix which should be used for this Virtual Hub.
		Changing this forces a new resource to be created.
		The address prefix subnet cannot be smaller than a /24. Azure recommends using a /23.
	EOD
  type        = string
}

variable "hub_routing_preference" {
  description = <<EOD
		(Optional) The hub routing preference.
		Possible values are ExpressRoute, ASPath and VpnGateway.
		Defaults to ExpressRoute.
	EOD
  default     = null
  type        = string
}

# Routes are omitted since they are created by the virtual_hub_route_table_route resource.

variable "sku" {
  description = <<EOD
		(Optional) The SKU of the Virtual Hub.
		Possible values are Basic and Standard.
		Changing this forces a new resource to be created.
	EOD
  default     = null
  type        = string
}

variable "virtual_wan_id" {
  description = <<EOD
		(Optional) The ID of a Virtual WAN within which the Virtual Hub should be created.
		Changing this forces a new resource to be created.
	EOD
  default     = null
  type        = string
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags to assign to the Virtual Hub.
	EOD
  default     = null
  type        = map(string)
}