variable "name" {
  description = <<EOD
    (Required) Specifies the name of the certificate.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to create the certificate.
    Changing this forces a new resource to be created.
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

variable "app_service_plan_id" {
  description = <<EOD
    (Optional) The ID of the associated App Service plan.
    Must be specified when the certificate is used inside an App Service Environment hosted App Service.
    Changing this forces a new resource to be created.
  EOD
  default     = null
  type        = string
}

variable "key_vault_secret_id" {
  description = <<EOD
    (Optional) The ID of the Key Vault secret.
    Changing this forces a new resource to be created.
    NOTE: Either pfx_blob or key_vault_secret_id must be set - but not both.
  EOD
  default     = null
  type        = string
}