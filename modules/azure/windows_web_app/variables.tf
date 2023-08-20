variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "service_plan_id" {
  type = string
}

variable "https_only" {
  default = null
  type    = bool
}

variable "public_network_access_enabled" {
  default = null
  type    = bool
}

variable "app_settings" {
  default = null
  type    = map(string)
}

variable "connection_strings" {
  default = {}
  type = map(object({
    name  = string
    type  = string
    value = string
  }))
}

variable "virtual_network_subnet_id" {
  default = null
  type    = string
}

variable "logs" {
  default = null
  type = object({
    detailed_error_messages = optional(bool, null)
    failed_request_tracing  = optional(bool, null)
    application_logs = optional(object({
      file_system_level = string
      azure_blob_storage = optional(object({
        level             = string
        retention_in_days = number
        sas_url           = string
      }), null)
    }), null)
  })
}

variable "tags" {
  default = null
  type    = map(string)
}

variable "identity" {
  default = null
  type = object({
    type         = string
    identity_ids = optional(list(string), null)
  })
}

variable "site_config" {
  type = object({
    container_registry_use_managed_identity = optional(bool, null)
    vnet_route_all_enabled                  = optional(bool, null)
    application_stack = optional(object({
      current_stack  = optional(string, null)
      dotnet_version = optional(string, null)
    }), null)
  })
}