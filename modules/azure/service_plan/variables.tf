variable "name" {
  description = <<EOD
		(Required) The name which should be used for this Service Plan.
		Changing this forces a new AppService to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) The Azure Region where the Service Plan should exist.
		Changing this forces a new AppService to be created.
	EOD
  type        = string
}

variable "os_type" {
  description = <<EOD
		(Required) The O/S type for the App Services to be hosted in this plan.
		Possible values include Windows, Linux, and WindowsContainer.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) The name of the Resource Group where the AppService should exist.
		Changing this forces a new AppService to be created.
	EOD
  type        = string
}

variable "sku_name" {
  description = <<EOD
		(Required) The SKU for the plan.
		Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, I4v2, I5v2, I6v2, P1v2, P2v2, P3v2, P0v3, P1v3, P2v3, P3v3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1.
		NOTE: Isolated SKUs (I1, I2, I3, I1v2, I2v2, and I3v2) can only be used with App Service Environments
		NOTE: Elastic and Consumption SKUs (Y1, EP1, EP2, and EP3) are for use with Function Apps.
	EOD
  type        = string
}