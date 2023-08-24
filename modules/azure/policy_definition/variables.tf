variable "name" {
  description = <<EOD
		(Required) The name of the policy definition.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "policy_type" {
  description = <<EOD
		(Required) The policy type.
		Possible values are BuiltIn, Custom, NotSpecified and Static.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "mode" {
  description = <<EOD
		(Required) The policy resource manager mode that allows you to specify which resource types will be evaluated.
		Possible values are All, Indexed, Microsoft.ContainerService.Data, Microsoft.CustomerLockbox.Data, Microsoft.DataCatalog.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, Microsoft.MachineLearningServices.Data, Microsoft.Network.Data and Microsoft.Synapse.Data.
		Note: Other resource provider modes only support built-in policy definitions but may later become available in custom definitions, these include; Microsoft.ContainerService.Data, Microsoft.CustomerLockbox.Data, Microsoft.DataCatalog.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, Microsoft.MachineLearningServices.Data, Microsoft.Network.Data and Microsoft.Synapse.Data. See https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure#resource-provider-modes for more details.
	EOD
  type        = string
}

variable "display_name" {
  description = <<EOD
		(Required) The display name of the policy definition.
	EOD
  type        = string
}

variable "description" {
  description = <<EOD
		(Optional) The description of the policy definition.
	EOD
  default     = null
  type        = string
}

variable "management_group_id" {
  description = <<EOD
		(Optional) The id of the Management Group where this policy should be defined.
		Changing this forces a new resource to be created.
	EOD
  default     = null
  type        = string
}

variable "policy_rule" {
  description = <<EOD
		(Optional) The policy rule for the policy definition.
		This is a JSON string representing the rule that contains an if and a then block.
	EOD
  default     = null
  type        = string
}

variable "metadata" {
  description = <<EOD
		(Optional) The metadata for the policy definition.
		This is a JSON string representing additional metadata that should be stored with the policy definition.
	EOD
  default     = null
  type        = string
}

variable "parameters" {
  description = <<EOD
		(Optional) Parameters for the policy definition.
		This field is a JSON string that allows you to parameterize your policy definition.
	EOD
  default     = null
  type        = string
}