variable "name" {
  description = <<EOD
		(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed.
		Changing this forces a new resource to be created.
		This must be unique across the entire Azure service, not just within the resource group.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		 - (Required) The name of the resource group in which to create the storage account.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		 - (Required) Specifies the supported Azure location where the resource exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "account_kind" {
  description = <<EOD
		(Optional) Defines the Kind of account.
		Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2.
		Defaults to StorageV2.
		NOTE: Changing the account_kind value from Storage to StorageV2 will not trigger a force new on the storage account, it will only upgrade the existing storage account from Storage to StorageV2 keeping the existing storage account in place.
	EOD
  default     = null
  type        = string
}

variable "account_tier" {
  description = <<EOD
		 - (Required) Defines the Tier to use for this storage account.
		Valid options are Standard and Premium.
		For BlockBlobStorage and FileStorage accounts only Premium is valid.
		Changing this forces a new resource to be created.
		NOTE: Blobs with a tier of Premium are of account kind StorageV2.
	EOD
  type        = string
}

variable "account_replication_type" {
  description = <<EOD
		 - (Required) Defines the type of replication to use for this storage account.
		Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS.
	EOD
  type        = string
}

variable "public_network_access_enabled" {
  description = <<EOD
		(Optional) Whether the public network access is enabled?
		Defaults to true.
	EOD
  default     = null
  type        = bool
}

variable "blob_properties" {
  description = <<EOD
		(Optional) A blob_properties block as defined below.
		A blob_properties block supports the following:
		- cors_rule - (Optional) A cors_rule block as defined below.
			A cors_rule block supports the following:
			- allowed_headers - (Required) A list of headers that are allowed to be a part of the cross-origin request.
			- allowed_methods - (Required) A list of HTTP methods that are allowed to be executed by the origin.
				Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
			- allowed_origins - (Required) A list of origin domains that will be allowed by CORS.
			- exposed_headers - (Required) A list of response headers that are exposed to CORS clients.
			- max_age_in_seconds - (Required) The number of seconds the client should cache a preflight response.
		- delete_retention_policy - (Optional) A delete_retention_policy block as defined below.
			A delete_retention_policy block supports the following:
			- days - (Optional) Specifies the number of days that the blob should be retained, between 1 and 365 days.
				Defaults to 7.
		- restore_policy - (Optional) A restore_policy block as defined below.
			This must be used together with delete_retention_policy set, versioning_enabled and change_feed_enabled set to true.
			A restore_policy block supports the following:
			- days - (Required) Specifies the number of days that the blob can be restored, between 1 and 365 days.
				This must be less than the days specified for delete_retention_policy.
		- versioning_enabled - (Optional) Is versioning enabled?
			Default to false.
		- change_feed_enabled - (Optional) Is the blob service properties for change feed events enabled?
			Default to false.
		- change_feed_retention_in_days - (Optional) The duration of change feed events retention in days.
			The possible values are between 1 and 146000 days (400 years).
			Setting this to null (or omit this in the configuration file) indicates an infinite retention of the change feed.
		- default_service_version - (Optional) The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version.
		- last_access_time_enabled - (Optional) Is the last access time based tracking enabled?
			Default to false.
		- container_delete_retention_policy - (Optional) A container_delete_retention_policy block as defined below.
			A container_delete_retention_policy block supports the following:
			- days - (Optional) Specifies the number of days that the container should be retained, between 1 and 365 days.
				Defaults to 7.
	EOD
  default     = null
  type = object({
    cors_rule = optional(object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    }))
    delete_retention_policy = optional(object({
      days = optional(number)
    }))
    restore_policy = optional(object({
      days = optional(number)
    }))
    versioning_enabled            = optional(bool)
    change_feed_enabled           = optional(bool)
    change_feed_retention_in_days = optional(number)
    default_service_version       = optional(string)
    last_access_time_enabled      = optional(bool)
    container_delete_retention_policy = optional(object({
      days = optional(number)
    }))
  })
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags to assign to the resource.
	EOD
  default     = null
  type        = map(string)
}