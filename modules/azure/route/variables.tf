variable "name" {
  description = <<EOD
		(Required) The name of the route.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) The name of the resource group in which to create the route.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "route_table_name" {
  description = <<EOD
		(Required) The name of the route table within which create the route.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "address_prefix" {
  description = <<EOD
		(Required) The destination to which the route applies.
		Can be CIDR (such as 10.1.0.0/16) or Azure Service Tag (such as ApiManagement, AzureBackup or AzureMonitor) format.
	EOD
  type        = string
}

variable "next_hop_type" {
  description = <<EOD
		(Required) The type of Azure hop the packet should be sent to.
		Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None.
	EOD
  type        = string
}

variable "next_hop_in_ip_address" {
  description = <<EOD
		(Optional) Contains the IP address packets should be forwarded to.
		Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
	EOD
  default     = null
  type        = string
}