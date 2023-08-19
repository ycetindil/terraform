variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Front Door Profile.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group where this Front Door Profile should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku_name" {
  description = <<EOD
    (Required) Specifies the SKU for this Front Door Profile.
    Possible values include Standard_AzureFrontDoor and Premium_AzureFrontDoor.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "response_timeout_seconds" {
  description = <<EOD
    (Optional) Specifies the maximum response timeout in seconds.
    Possible values are between 16 and 240 seconds (inclusive).
    Defaults to 120 seconds.
  EOD
  default     = null
  type        = number
}

variable "tags" {
  description = <<EOD
    (Optional) Specifies a mapping of tags to assign to the resource.
  EOD
  default     = null
  type        = map(string)
}