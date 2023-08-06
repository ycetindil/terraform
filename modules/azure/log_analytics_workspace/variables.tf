variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  default = null
  type    = string
}

variable "monitor_diagnostic_settings" {
  default = {}
  type    = any // Pass directly to the 'monitor_diagnostic_setting' module
}