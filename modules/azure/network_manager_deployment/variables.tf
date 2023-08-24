variable "network_manager_id" {
  description = <<EOD
		(Required) Specifies the ID of the Network Manager.
		Changing this forces a new Network Manager Deployment to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) Specifies the location which the configurations will be deployed to.
		Changing this forces a new Network Manager Deployment to be created.
	EOD
  type        = string
}

variable "scope_access" {
  description = <<EOD
		(Required) Specifies the configuration deployment type.
		Possible values are Connectivity and SecurityAdmin.
		Changing this forces a new Network Manager Deployment to be created.
	EOD
  type        = string
}

variable "configuration_ids" {
  description = <<EOD
		(Required) A list of Network Manager Configuration IDs which should be aligned with scope_access.
	EOD
  type        = list(string)
}

variable "triggers" {
  description = <<EOD
		(Optional) A mapping of key values pairs that can be used to keep the deployment up with the Network Manager configurations and rules.
	EOD
  default     = null
  type        = map(string)
}