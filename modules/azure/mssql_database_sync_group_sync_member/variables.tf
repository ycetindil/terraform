variable "type" {
  description = <<EOD
		(Required) The resource type.
	EOD
  default     = "Microsoft.Sql/servers/databases/syncGroups/syncMembers@2022-05-01-preview"
  type        = string
}

variable "name" {
  description = <<EOD
		(Required) The resource name.
	EOD
  type        = string
}

variable "parent_id" {
  description = <<EOD
		(Required) The ID of the resource that is the parent for this resource.
		ID for resource of type: syncGroups
	EOD
  type        = string
}

variable "body" {
  description = <<EOD
		(Required) The body block supports the following:
			properties - (Required) Resource properties.
			NOTE: These properties are all about the sync_member.
			- databaseName - (Optional) Database name of the member database in the sync member.
			- databaseType - (Optional) Database type of the sync member.
				Possible values are "AzureSqlDatabase", "SqlServerDatabase".
			- password - (Optional) Password of the member database in the sync member.
			- serverName - (Optional) Server name of the member database in the sync member.
			- sqlServerDatabaseId - (Optional) SQL Server database id of the sync member.
			- syncAgentId - (Optional) ARM resource id of the sync agent in the sync member.
			- syncDirection - (Optional) Sync direction of the sync member.
				Possible values are "Bidirectional", "OneWayHubToMember", and "OneWayMemberToHub".
			- syncMemberAzureDatabaseResourceId - (Optional) ARM resource id of the sync member logical database, for sync members in Azure.
			- usePrivateLinkConnection - (Optional) Whether to use private link connection.
			- userName - (Optional) User name of the member database in the sync member.
	EOD
  type = object({
    properties = object({
      databaseName                      = optional(string)
      databaseType                      = optional(string)
      password                          = optional(string)
      serverName                        = optional(string)
      sqlServerDatabaseId               = optional(string)
      syncAgentId                       = optional(string)
      syncDirection                     = optional(string)
      syncMemberAzureDatabaseResourceId = optional(string)
      usePrivateLinkConnection          = optional(bool)
      userName                          = optional(string)
    })
  })
}