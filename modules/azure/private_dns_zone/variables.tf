variable "name" {
  description = <<EOD
		(Required) The name of the Private DNS Zone.
		Must be a valid domain name.
		Changing this forces a new resource to be created.
		NOTE: If you are going to be using the Private DNS Zone with a Private Endpoint the name of the Private DNS Zone must follow the Private DNS Zone name schema in the product documentation at https://docs.microsoft.com/azure/private-link/private-endpoint-dns#virtual-network-and-on-premises-workloads-using-a-dns-forwarder in order for the two resources to be connected successfully.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) Specifies the resource group where the resource exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}