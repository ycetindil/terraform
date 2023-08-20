variable "name" {
  description = <<EOD
		(Required) Specifies the name of the Log Analytics Workspace.
		Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) The name of the resource group in which the Log Analytics workspace is created.
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

variable "sku" {
  description = <<EOD
		(Optional) Specifies the SKU of the Log Analytics Workspace.
		Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03).
		Defaults to PerGB2018.
		NOTE: A new pricing model took effect on 2018-04-03, which requires the SKU PerGB2018. If you're provisioned resources before this date you have the option of remaining with the previous Pricing SKU and using the other SKUs defined above. More information about the Pricing SKUs is available at the following URI.
		NOTE: Changing sku forces a new Log Analytics Workspace to be created, except when changing between PerGB2018 and CapacityReservation. However, changing sku to CapacityReservation or changing reservation_capacity_in_gb_per_day to a higher tier will lead to a 31-days commitment period, during which the SKU cannot be changed to a lower one. Please refer to official documentation for further information.
		NOTE: The Free SKU has a default daily_quota_gb value of 0.5 (GB).
	EOD
  default     = null
  type        = string
}