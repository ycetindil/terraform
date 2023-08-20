variable "key_vault_id" {
  description = <<EOD
    (Required) Specifies the id of the Key Vault resource. Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "tenant_id" {
  description = <<EOD
    (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "object_id" {
  description = <<EOD
    (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.
    The object ID of a service principal can be fetched from azuread_service_principal.object_id.
    The object ID must be unique for the list of access policies.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "certificate_permissions" {
  description = <<EOD
    (Optional) List of certificate permissions.
    Must be one or more from the following: ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  EOD
  default     = null
  type        = list(string)
}

variable "key_permissions" {
  description = <<EOD
    (Optional) List of key permissions.
    Must be one or more from the following: ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  EOD
  default     = null
  type        = list(string)
}

variable "secret_permissions" {
  description = <<EOD
    (Optional) List of secret permissions.
    Must be one or more from the following: ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  EOD
  default     = null
  type        = list(string)
}

variable "storage_permissions" {
  description = <<EOD
    (Optional) List of storage permissions.
    Must be one or more from the following: ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
  EOD
  default     = null
  type        = list(string)
}