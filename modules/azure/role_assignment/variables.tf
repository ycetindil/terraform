variable "name" {
  description = <<EOD
		(Optional) A unique UUID/GUID for this Role Assignment - one will be generated if not specified.
		Changing this forces a new resource to be created.
	EOD
  default     = null
  type        = string
}

variable "scope" {
  description = <<EOD
		(Required) The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "role_definition_id" {
  description = <<EOD
		(Optional) The Scoped-ID of the Role Definition.
		Changing this forces a new resource to be created.
		Conflicts with role_definition_name.
	EOD
  default     = null
  type        = string
}

variable "role_definition_name" {
  description = <<EOD
		(Optional) The name of a built-in Role.
		Changing this forces a new resource to be created.
		Conflicts with role_definition_id.
	EOD
  default     = null
  type        = string
}

variable "principal_id" {
  description = <<EOD
		(Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to.
		Changing this forces a new resource to be created.
		NOTE: The Principal ID is also known as the Object ID (ie not the "Application ID" for applications).
	EOD
  type        = string
}