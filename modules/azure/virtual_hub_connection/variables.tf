variable "name" {
  description = <<EOD
		 - (Required) The Name which should be used for this Connection, which must be unique within the Virtual Hub.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "virtual_hub_id" {
  description = <<EOD
		 - (Required) The ID of the Virtual Hub within which this connection should be created.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "remote_virtual_network_id" {
  description = <<EOD
		 - (Required) The ID of the Virtual Network which the Virtual Hub should be connected to.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "internet_security_enabled" {
  description = <<EOD
		 - (Optional) Should Internet Security be enabled to secure internet traffic?
		Defaults to false.
	EOD
  default     = null
  type        = bool
}

variable "routing" {
  description = <<EOD
		 - (Optional) A routing block as defined below.
		A routing block supports the following:
		- associated_route_table_id - (Optional) The ID of the route table associated with this Virtual Hub connection.
		- propagated_route_table - (Optional) A propagated_route_table block as defined below.
			A propagated_route_table block supports the following:
			- labels - (Optional) The list of labels to assign to this route table.
			- route_table_ids - (Optional) A list of Route Table IDs to associated with this Virtual Hub Connection.
		- static_vnet_route - (Optional) A static_vnet_route block as defined below.
			A static_vnet_route block supports the following:
			- name - (Optional) The name which should be used for this Static Route.
			- address_prefixes - (Optional) A list of CIDR Ranges which should be used as Address Prefixes.
			- next_hop_ip_address - (Optional) The IP Address which should be used for the Next Hop.
	EOD
  default     = null
  type = object({
    associated_route_table_id = optional(string)
    propagated_route_table = optional(object({
      labels          = optional(set(string))
      route_table_ids = optional(list(string))
    }))
    static_vnet_route = optional(object({
      name                = optional(string)
      address_prefixes    = optional(set(string))
      next_hop_ip_address = optional(string)
    }))
  })
}