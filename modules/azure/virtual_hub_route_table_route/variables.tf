variable "route_table_id" {
  description = <<EOD
		(Required) The ID of the Virtual Hub Route Table to link this route to.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "name" {
  description = <<EOD
		(Required) The name which should be used for this route.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "destinations" {
  description = <<EOD
		(Required) A list of destination addresses for this route.
	EOD
  type        = set(string)
}

variable "destinations_type" {
  description = <<EOD
		(Required) The type of destinations.
		Possible values are CIDR, ResourceId and Service.
	EOD
  type        = string
}

variable "next_hop" {
  description = <<EOD
		(Required) The next hop's resource ID.
	EOD
  type        = string
}

variable "next_hop_type" {
  description = <<EOD
		(Optional) The type of next hop.
		Currently the only possible value is ResourceId.
		Defaults to ResourceId.
	EOD
  default     = null
  type        = string
}