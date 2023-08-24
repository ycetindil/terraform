variable "name" {
  description = <<EOD
		(Required) Specifies the Name of the Private Endpoint.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) The supported Azure location where the resource exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "subnet_id" {
  description = <<EOD
		(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "custom_network_interface_name" {
  description = <<EOD
		(Optional) The custom name of the network interface attached to the private endpoint.
		Changing this forces a new resource to be created.
	EOD
  default     = null
  type        = string
}

variable "private_dns_zone_group" {
  description = <<EOD
		(Optional) A private_dns_zone_group block as defined below.
		A private_dns_zone_group block supports the following:
		- name - (Required) Specifies the Name of the Private DNS Zone Group.
		- private_dns_zone_ids - (Required) Specifies the list of Private DNS Zones to include within the private_dns_zone_group.
	EOD
  default     = null
  type = object({
    name                 = string
    private_dns_zone_ids = list(string)
  })
}

variable "private_service_connection" {
  description = <<EOD
		(Required) A private_service_connection block as defined below.
		A private_service_connection block supports the following:
		- name - (Required) Specifies the Name of the Private Service Connection.
			Changing this forces a new resource to be created.
		- is_manual_connection - (Required) Does the Private Endpoint require Manual Approval from the remote resource owner?
			Changing this forces a new resource to be created.
			NOTE: If you are trying to connect the Private Endpoint to a remote resource without having the correct RBAC permissions on the remote resource set this value to true.
		- private_connection_resource_id - (Optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to.
			One of private_connection_resource_id or private_connection_resource_alias must be specified.
			Changing this forces a new resource to be created.
			For a web app or function app slot, the parent web app should be used in this field instead of a reference to the slot itself.
		- private_connection_resource_alias - (Optional) The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to.
			One of private_connection_resource_id or private_connection_resource_alias must be specified.
			Changing this forces a new resource to be created.
		- subresource_names - (Optional) A list of subresource names which the Private Endpoint is able to connect to.
			subresource_names corresponds to group_id.
			Possible values are detailed in the product documentation at https://docs.microsoft.com/azure/private-link/private-endpoint-overview#private-link-resource in the Subresources column.
			Changing this forces a new resource to be created.
			NOTE: Some resource types (such as Storage Account) only support 1 subresource per private endpoint.
		- request_message - (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource.
			The request message can be a maximum of 140 characters in length.
			Only valid if is_manual_connection is set to true.
	EOD
  type = object({
    name                              = string
    is_manual_connection              = bool
    private_connection_resource_id    = optional(string)
    private_connection_resource_alias = optional(string)
    subresource_names                 = optional(list(string))
    request_message                   = optional(string)
  })
}

variable "ip_configurations" {
  description = <<EOD
		(Optional) One or more ip_configuration blocks as defined below.
		This allows a static IP address to be set for this Private Endpoint, otherwise an address is dynamically allocated from the Subnet.
		An ip_configuration block supports the following:
		- name - (Required) Specifies the Name of the IP Configuration. Changing this forces a new resource to be created.
		- private_ip_address - (Required) Specifies the static IP address within the private endpoint's subnet to be used. Changing this forces a new resource to be created.
		- subresource_name - (Optional) Specifies the subresource this IP address applies to. subresource_names corresponds to group_id. Changing this forces a new resource to be created.
		- member_name - (Optional) Specifies the member name this IP address applies to. If it is not specified, it will use the value of subresource_name. Changing this forces a new resource to be created.
			NOTE: member_name will be required and will not take the value of subresource_name in the next major version.
	EOD
  default     = {}
  type = map(object({
    name               = string
    private_ip_address = string
    subresource_name   = optional(string)
    member_name        = optional(string)
  }))
}