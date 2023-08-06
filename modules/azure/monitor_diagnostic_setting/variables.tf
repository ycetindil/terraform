variable "name" {
  default = null
  type    = string
}

variable "target_resource" {
  type = object({
    name                = optional(string, null)
    resource_group_name = optional(string, null)
    type                = optional(string, null)
    required_tags       = optional(map(string), null)
  })
}

variable "storage_resource" {
  type = object({
    log_analytics_workspace = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    storage_account = optional(object({
      name                = string
      resource_group_name = string
    }), null)
  })
}

variable "enabled_logs" {
  description = <<EOD
    possible categories are listed at https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-schema#service-specific-schemas
  EOD
  default     = {}
  type = map(object({
    category       = optional(string)
    category_group = optional(string)
    retention_policy = optional(object({
      enabled = optional(bool)
      days    = optional(number)
    }), null)
  }))
}

variable "metrics" {
  default = {}
  type = map(object({
    category = string
    retention_policy = optional(object({
      enabled = optional(bool)
      days    = optional(number)
    }), null)
  }))
}