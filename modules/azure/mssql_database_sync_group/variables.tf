variable "type" {
  description = <<EOD
		(Required) The resource type.
	EOD
  default     = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
  type        = string
}

variable "name" {
  description = <<EOD
		(Required) The resource name.
		Character limit: 1-150
		Valid characters: Alphanumerics, hyphens, and underscores.
	EOD
  type        = string
}

variable "parent_id" {
  description = <<EOD
		(Required) The ID of the resource that is the parent for this resource.
		ID for resource of type: databases
	EOD
  type        = string
}

variable "body" {
  description = <<EOD
		(Required) The body block supports the following:
			sku - (Required) The name and capacity of the SKU.
			- capacity - (Optional) Capacity of the particular SKU.
			- family - (Optional) If the service has different generations of hardware, for the same SKU, then that can be captured here.
			- name - (Required) The name of the SKU, typically, a letter + Number code, e.g. P3.
			- size - (Optional) Size of the particular SKU
			- tier - (Optional) The tier or edition of the particular SKU, e.g. Basic, Premium.
			properties - (Optional) Resource properties.
			- conflictLoggingRetentionInDays - (Optional) Conflict logging retention period.
			- conflictResolutionPolicy - (Optional) Conflict resolution policy of the sync group.
				Possible values are "HubWin" "MemberWin"
			- enableConflictLogging - (Optional) If conflict logging is enabled.
			- hubDatabasePassword - (Optional) Password for the sync group hub database credential.
			- hubDatabaseUserName - (Optional) User name for the sync group hub database credential.
			- interval - (Optional) Sync interval of the sync group.
			- schema - (Optional) Sync schema of the sync group.
				- masterSyncMemberName - (Optional) Name of master sync member where the schema is from.
				- tables - (Optional) List of tables in sync group schema.
					- columns - (Optional) List of columns in sync group schema.
						- dataSize - (Optional) Data size of the column.
						- dataType - (Optional) Data type of the column.
						- quotedName - (Optional) Quoted name of sync group table column.
					- quotedName - (Optional) Quoted name of sync group schema table.
			- syncDatabaseId - (Optional) ARM resource id of the sync database in the sync group.
			- usePrivateLinkConnection - (Optional) If use private link connection is enabled.
	EOD
  type = object({
    sku = object({
      capacity = optional(number)
      family   = optional(string)
      name     = string
      size     = optional(string)
      tier     = optional(string)
    })
    properties = optional(object({
      conflictLoggingRetentionInDays = optional(number)
      conflictResolutionPolicy       = optional(string)
      enableConflictLogging          = optional(bool)
      hubDatabasePassword            = optional(string)
      hubDatabaseUserName            = optional(string)
      interval                       = optional(number)
      schema = optional(object({
        masterSyncMemberName = optional(string)
        tables = optional(list(object({
          columns = optional(List(object({
            dataSize   = optional(string)
            dataType   = optional(string)
            quotedName = optional(string)
          })))
          quotedName = optional(string)
        })))
      }))
      syncDatabaseId           = optional(string)
      usePrivateLinkConnection = optional(bool)
    }))
  })
}