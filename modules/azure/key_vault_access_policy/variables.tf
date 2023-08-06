variable "key_vault" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "principal" {
  description = <<EOD
    Possible 'type' values are:
    - user (needs 'name')
    - service_principal (needs 'name')
    - group (needs 'name')
    - user_assigned_identity (needs 'identity_resource')
    - system_assigned_identity (needs 'system_assigned_identity_resource')
    Azure services that can use managed identities are listed at https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/managed-identities-status
    'system_assigned_identity_resource.type' list can be found at https://learn.microsoft.com/en-us/azure/governance/resource-graph/reference/supported-tables-resources
    Possible 'system_assigned_identity_resource.os_type' values are:
    - linux
    - windows
  EOD
  type = object({
    type = string
    name = optional(string, null)
    user_assigned_identity = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    system_assigned_identity_resource = optional(object({
      name                = string
      type                = string
      resource_group_name = string
      os_type             = optional(string, "")
    }), null)
  })
}

variable "key_permissions" {
  default = null
  type    = list(string)
}

variable "secret_permissions" {
  default = null
  type    = list(string)
}

variable "certificate_permissions" {
  default = null
  type    = list(string)
}