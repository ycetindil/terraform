variable "hostname" {
  description = <<EOD
    (Required) Specifies the Custom Hostname to use for the App Service, example www.example.com.
    Changing this forces a new resource to be created.
    NOTE: A CNAME needs to be configured from this Hostname to the Azure Website - otherwise Azure will reject the Hostname Binding.
  EOD
  type        = string
}

variable "app_service_name" {
  description = <<EOD
    (Required) The name of the App Service in which to add the Custom Hostname Binding.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which the App Service exists.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "ssl_state" {
  description = <<EOD
    (Optional) The SSL type.
    Possible values are IpBasedEnabled and SniEnabled.
    Changing this forces a new resource to be created.
  EOD
  default     = null
  type        = string
}

variable "thumbprint" {
  description = <<EOD
    (Optional) The SSL certificate thumbprint.
    Changing this forces a new resource to be created.
    NOTE: thumbprint must be specified when ssl_state is set.
  EOD
  default     = null
  type        = string
}