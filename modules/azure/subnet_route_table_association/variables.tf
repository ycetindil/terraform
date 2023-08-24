variable "route_table_id" {
  description = <<EOD
		 - (Required) The ID of the Route Table which should be associated with the Subnet.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "subnet_id" {
  description = <<EOD
		 - (Required) The ID of the Subnet.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}