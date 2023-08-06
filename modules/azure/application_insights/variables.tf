variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Application Insights component.
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

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to create the Application Insights component.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "application_type" {
  description = <<EOD
    (Required) Specifies the type of Application Insights to create.
    Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET.
    Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "log_analytics_workspace" {
  description = <<EOD
    (Optional) Specifies a log analytics workspace resource.
  EOD
  default     = null
  type = object({
    name                = string
    resource_group_name = string
  })
}