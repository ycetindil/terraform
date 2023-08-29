variable "name" {
  description = <<EOD
		(Required) The name which should be used for Virtual Hub Route Table.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "virtual_hub_id" {
  description = <<EOD
		(Required) The ID of the Virtual Hub within which this route table should be created.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "labels" {
  description = <<EOD
		(Optional) List of labels associated with this route table.
	EOD
  default     = null
  type        = set(string)
}

# routes are omitted since they are created with virtual_hub_route_table_route resource.