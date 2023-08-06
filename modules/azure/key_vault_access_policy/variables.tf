variable "key_vault" {
  description = <<EOD
    (Required) Specifies the Key Vault resource.
    - name - (Required) The Name of the Key Vault
    - resource_group_name - (Required) The Name of the Resource Group of the Key Vault
  EOD
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "object" {
  description = <<EOD
    (Required) The necessary information block of the resource, or a user, service principal or security group in the Azure Active Directory tenant for the vault.
    - type - (Required) Possible values are:
      - user
      - group
      - service_principal
      - user_assigned_identity
      - system_assigned_identity
        Azure services that can use managed identities are listed at https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/managed-identities-status
      - user - (Optional) This block supports the following:
        - name - (Required) The Name of the User.
      - group - (Optional) This block supports the following:
        - name - (Required) The Name of the Group.
      - service_principal - (Optional) This block supports the following:
        - name - (Required) The Name of the Service Principal.
      - user_assigned_identity - (Optional) This block supports the following:
        - name - (Required) The Name of the User Assigned Identity.
        - resource_group_name - (Required) The Name of the Resource Group of the User Assigned Identity.
      - system_assigned_identity - (Optional) This block supports the following:
        - object_name - (Required) The Name of the System Assigned Identity Object.
        - object_resource_group_name - (Required) The Name of the Resource Group of the System Assigned Identity Object.
        - object_type - (Required) The Type of the System Assigned Identity Object.
          Possible object_type list can be found at https://learn.microsoft.com/en-us/azure/governance/resource-graph/reference/supported-tables-resources
        - object_os_type - (Optional) The OS Type of the System Assigned Identity Object.
          Required for objects such as web_apps, virtual_machines, virtual_machine_scale_sets, ...
          Possible object_os_type values are linux and windows.
  EOD
  type = object({
    type = string
    user = optional(object({
      name = string
    }), null)
    group = optional(object({
      name = string
    }), null)
    service_principal = optional(object({
      name = string
    }), null)
    user_assigned_identity = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    system_assigned_identity = optional(object({
      object_name                = string
      object_resource_group_name = string
      object_type                = string
      object_os_type             = optional(string, "") // Should not be 'null' for the lower function
    }), null)
  })
}

variable "certificate_permissions" {
  description = <<EOD
    (Optional) List of certificate permissions, must be one or more from the following: ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  EOD
  default     = null
  type        = list(string)
}

variable "key_permissions" {
  description = <<EOD
    (Optional) List of key permissions, must be one or more from the following: ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  EOD
  default     = null
  type        = list(string)
}

variable "secret_permissions" {
  description = <<EOD
    (Optional) List of secret permissions, must be one or more from the following: ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  EOD
  default     = null
  type        = list(string)
}

variable "storage_permissions" {
  description = <<EOD
    (Optional) List of storage permissions, must be one or more from the following: ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
  EOD
  default     = null
  type        = list(string)
}