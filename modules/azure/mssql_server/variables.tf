variable "name" {
  description = <<EOD
		(Required) The name of the Microsoft SQL Server. This needs to be globally unique within Azure.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) The name of the resource group in which to create the Microsoft SQL Server.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) Specifies the supported Azure location where the resource exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "version" {
  description = <<EOD
		(Required) The version for the new server.
		Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server).
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "administrator_login" {
  description = <<EOD
		(Optional) The administrator login name for the new server.
		Required unless azuread_authentication_only in the azuread_administrator block is true.
		When omitted, Azure will generate a default username which cannot be subsequently changed.
		Changing this forces a new resource to be created.
	EOD
  default     = null
  type        = string
}

variable "administrator_login_password" {
  description = <<EOD
		(Optional) The password associated with the administrator_login user.
		Needs to comply with Azure's Password Policy described at https://msdn.microsoft.com/library/ms161959.aspx.
		Required unless azuread_authentication_only in the azuread_administrator block is true.
	EOD
  sensitive   = true
  default     = null
  type        = string
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags to assign to the resource.
	EOD
  default     = null
  type        = map(string)
}