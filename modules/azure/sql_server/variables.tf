variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "mssql_version" {
  type = string
}

variable "administrator_login" {
  sensitive = true
  type = object({
    username = object({
      literal = optional(string, null)
      key_vault = optional(object({
        name                = string
        resource_group_name = string
        secret_name         = string
      }), null)
    })
    password = object({
      literal = optional(string, null)
      key_vault = optional(object({
        name                = string
        resource_group_name = string
        secret_name         = string
      }), null)
    })
  })
}

variable "tags" {
  default = null
  type    = map(string)
}

variable "mssql_databases" {
  default = null
  type = map(object({
    name                        = string
    collation                   = optional(string)
    max_size_gb                 = optional(number)
    sku_name                    = optional(string)
    min_capacity                = optional(number) ## This property is only settable for General Purpose Serverless databases.
    auto_pause_delay_in_minutes = optional(number)
    read_replica_count          = optional(number)
    read_scale                  = optional(bool)
    zone_redundant              = optional(bool) ##This property is only settable for Premium and Business Critical databases.
    tags                        = optional(map(string))
    sync_groups = optional(map(object({
      name                     = string
      conflictResolutionPolicy = string
      interval                 = number
      usePrivateLinkConnection = bool
    })), {})
    sync_group_memberships = optional(map(object({
      name = string
      sync_group = object({
        name = string
        server = object({
          name                = string
          resource_group_name = string
        })
        database = object({
          name = string
        })
      })
      own_database_type        = string
      usePrivateLinkConnection = bool
      syncDirection            = string
    })), {})
  }))
}