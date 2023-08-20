variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Key Vault.
    Changing this forces a new resource to be created.
    The name must be globally unique.
    If the vault is in a recoverable state then the vault will need to be purged before reusing the name.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) Specifies the supported Azure location where the resource exists.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to create the Key Vault.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku_name" {
  description = <<EOD
    (Required) The Name of the SKU used for this Key Vault.
    Possible values are standard and premium.
  EOD
  type        = string
}

variable "tenant_id" {
  description = <<EOD
    (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
  EOD
  type = string
}

variable "tags" {
  description = <<EOD
    (Optional) A mapping of tags to assign to the resource.
  EOD
  default     = null
  type        = map(string)
}