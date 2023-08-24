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

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags to assign to the resource.
	EOD
  default     = null
  type        = map(string)
}