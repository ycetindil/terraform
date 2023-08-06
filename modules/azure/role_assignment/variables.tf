variable "scope" {
  description = <<EOD
    Possible 'type' values are:
    - management_group (requires 'name')
    - subscription (requires 'name')
    - client_config (requires nothing) // TODO: Principala tasi
    - resource_group (requires 'name')
    - resource (requires 'resource' block)
    'resource.name' should be entered instead of 'name' if 'type' is 'resource'.
    'resource.type' list can be found at https://learn.microsoft.com/en-us/azure/governance/resource-graph/reference/supported-tables-resources
  EOD
  type = object({
    type = string
    name = optional(string, null)
    resource = optional(object({
      name                = optional(string)
      type                = optional(string)
      resource_group_name = optional(string)
      required_tags       = optional(map(string))
    }), null)
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
      required_tags       = optional(map(string))
      os_type             = optional(string)
    }), null)
  })
}

variable "role_definition" {
  type = object({
    built_in = optional(object({
      name = string
    }), null)
    custom = optional(object({
      existing = optional(object({
        name = string
      }), null)
      new = optional(any, null) // Pass directly to the 'role_definition' module
    }))
  })
}