variable "name" {
  description = <<EOD
		(Required) The name of the Container which should be created within the Storage Account.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "storage_account_name" {
  description = <<EOD
		(Required) The name of the Storage Account where the Container should be created.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "container_access_type" {
  description = <<EOD
		(Optional) The Access Level configured for this Container.
		Possible values are blob, container or private.
		Defaults to private.
	EOD
  default     = null
  type        = string
}

variable "metadata" {
  description = <<EOD
		(Optional) A mapping of MetaData for this Container.
		All metadata keys should be lowercase.
	EOD
  default     = null
  type        = map(string)
}