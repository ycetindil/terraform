variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "service_plan" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "app_settings" {
  default = null
  type    = map(string)
}

variable "subnet" {
  default = null
  type = object({
    name                       = string
    virtual_network_name       = string
    subnet_resource_group_name = string
  })
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
    type = string
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

variable "service_connections" {
  default = {}
  type = map(object({
    name = string
    target_resource = object({
      name                = optional(string, null) // Resource name can only contain letters, numbers (0-9), periods ('.'), and underscores ('_'). The length must not be more than 60 characters.
      resource_group_name = optional(string, null)
      type                = optional(string, null)
      required_tags       = optional(map(string), null)
    })
    authentication = object({
      type = string
    })
    secret_store = optional(object({
      key_vault = object({
        name                = string
        resource_group_name = string
      })
    }), null)
  }))
}

variable "custom_domain" {
  default = null
  type = object({
    name                = string
    resource_group_name = string
    subdomain_name      = optional(string, null)
    certificate = optional(object({
      unmanaged = optional(object({
        name                = string
        resource_group_name = string
        location            = string
        pfx_blob            = optional(string, null)
        password            = optional(string, null)
        app_service_plan_id = optional(string, null)
        key_vault_secret = optional(object({
          name                          = string
          key_vault_name                = string
          key_vault_resource_group_name = string
        }), null)
      }), null)
    }), null)
  })
}