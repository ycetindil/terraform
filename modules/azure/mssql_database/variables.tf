variable "name" {
  description = <<EOD
		(Required) The name of the MS SQL Database.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "server_id" {
  description = <<EOD
		(Required) The id of the MS SQL Server on which to create the database.
		Changing this forces a new resource to be created.
		Note: This setting is still required for "Serverless" SKUs
	EOD
  type        = string
}

variable "collation" {
  description = <<EOD
		(Optional) Specifies the collation of the database.
		Changing this forces a new resource to be created.
	EOD
  default     = null
  type        = string
}

variable "geo_backup_enabled" {
  description = <<EOD
		(Optional) A boolean that specifies if the Geo Backup Policy is enabled.
		Defaults to true.
		Note: geo_backup_enabled is only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs.
	EOD
  default     = null
  type        = bool
}

variable "long_term_retention_policy" {
  description = <<EOD
		(Optional) A long_term_retention_policy block as defined below.
		A long_term_retention_policy block supports the following:
		- weekly_retention - (Optional) The weekly retention policy for an LTR backup in an ISO 8601 format.
			Valid value is between 1 to 520 weeks. e.g. P1Y, P1M, P1W or P7D.
		- monthly_retention - (Optional) The monthly retention policy for an LTR backup in an ISO 8601 format.
			Valid value is between 1 to 120 months. e.g. P1Y, P1M, P4W or P30D.
		- yearly_retention - (Optional) The yearly retention policy for an LTR backup in an ISO 8601 format.
			Valid value is between 1 to 10 years. e.g. P1Y, P12M, P52W or P365D.
		- week_of_year - (Optional) The week of year to take the yearly backup.
			Value has to be between 1 and 52.
	EOD
  default     = null
  type = object({
    weekly_retention  = optional(string)
    monthly_retention = optional(string)
    yearly_retention  = optional(string)
    week_of_year      = optional(number)
  })
}

variable "max_size_gb" {
  description = <<EOD
		(Optional) The max size of the database in gigabytes.
		Note: This value should not be configured when the create_mode is Secondary or OnlineSecondary, as the sizing of the primary is then used as per https://docs.microsoft.com/azure/azure-sql/database/single-database-scale#geo-replicated-database.
	EOD
  default     = null
  type        = number
}

variable "min_capacity" {
  description = <<EOD
		(Optional) Minimal capacity that database will always have allocated, if not paused.
		This property is only settable for General Purpose Serverless databases.
	EOD
  default     = null
  type        = string
}

variable "read_scale" {
  description = <<EOD
		(Optional) If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica.
		This property is only settable for Premium and Business Critical databases.
	EOD
  default     = null
  type        = bool
}

variable "short_term_retention_policy" {
  description = <<EOD
		(Optional) A short_term_retention_policy block as defined below.
		A short_term_retention_policy block supports the following:
		- retention_days - (Required) Point In Time Restore configuration.
			Value has to be between 7 and 35.
		- backup_interval_in_hours - (Optional) The hours between each differential backup.
			This is only applicable to live databases but not dropped databases.
			Value has to be 12 or 24.
			Defaults to 12 hours.
	EOD
  default     = null
  type = object({
    retention_days           = number
    backup_interval_in_hours = optional(number)
  })
}

variable "sku_name" {
  description = <<EOD
		(Optional) Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100.
		Changing this from the HyperScale service tier to another service tier will create a new resource.
		Note: The default sku_name value may differ between Azure locations depending on local availability of Gen4/Gen5 capacity. When databases are replicated using the creation_source_database_id property, the source (primary) database cannot have a higher SKU service tier than any secondary databases. When changing the sku_name of a database having one or more secondary databases, this resource will first update any secondary databases as necessary. In such cases it's recommended to use the same sku_name in your configuration for all related databases, as not doing so may cause an unresolvable diff during subsequent plans.
	EOD
  default     = null
  type        = string
}

variable "storage_account_type" {
  description = <<EOD
		(Optional) Specifies the storage account type used to store backups for this database.
		Possible values are Geo, Local and Zone.
		The default value is Geo.
	EOD
  default     = null
  type        = string
}

variable "zone_redundant" {
  description = <<EOD
		(Optional) Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones.
		This property is only settable for Premium and Business Critical databases.
	EOD
  default     = null
  type        = bool
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags to assign to the resource.
	EOD
  default     = null
  type        = map(string)
}