variable "name" {
  description = <<EOD
		(Required) Specifies the name which should be used for this Network Manager Connectivity Configuration.
		Changing this forces a new Network Manager Connectivity Configuration to be created.
	EOD
  type        = string
}

variable "network_manager_id" {
  description = <<EOD
		(Required) Specifies the ID of the Network Manager.
		Changing this forces a new Network Manager Connectivity Configuration to be created.
	EOD
  type        = string
}

variable "applies_to_group" {
  description = <<EOD
		(Required) An applies_to_group block as defined below.
		- group_connectivity - (Required) Specifies the group connectivity type.
			Possible values are None and DirectlyConnected.
		- network_group_id - (Required) Specifies the resource ID of Network Group which the configuration applies to.
		- global_mesh_enabled - (Optional) Indicates whether to global mesh is supported for this group.
			Possible values are true and false.
			NOTE: A group can be global only if the group_connectivity is DirectlyConnected.
		- use_hub_gateway - (Optional) Indicates whether the hub gateway is used.
			Possible values are true and false.
	EOD
  type = object({
    group_connectivity  = string
    network_group_id    = string
    global_mesh_enabled = optional(bool)
    use_hub_gateway     = optional(bool)
  })
}

variable "connectivity_topology" {
  description = <<EOD
		(Required) Specifies the connectivity topology type.
		Possible values are HubAndSpoke and Mesh.
	EOD
  type        = string
}

variable "delete_existing_peering_enabled" {
  description = <<EOD
		(Optional) Indicates whether to remove current existing Virtual Network Peering in the Connectivity Configuration affected scope.
		Possible values are true and false.
	EOD
  default     = null
  type        = bool
}

variable "description" {
  description = <<EOD
		(Optional) A description of the Connectivity Configuration.
	EOD
  default     = null
  type        = string
}

variable "global_mesh_enabled" {
  description = <<EOD
		(Optional) Indicates whether to global mesh is supported.
		Possible values are true and false.
	EOD
  default     = null
  type        = bool
}

variable "hub" {
  description = <<EOD
		(Optional) A hub block as defined below.
		A hub block supports the following:
		- resource_id - (Required) Specifies the resource ID used as hub in Hub And Spoke topology.
		- resource_type - (Required) Specifies the resource Type used as hub in Hub And Spoke topology.
	EOD
  default     = null
  type = object({
    resource_id   = string
    resource_type = string
  })
}