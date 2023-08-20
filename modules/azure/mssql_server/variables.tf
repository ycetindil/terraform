variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "mssql_version" {
  type = string
}

variable "administrator_login" {
  default   = null
  sensitive = true
  type      = string
}

variable "administrator_login_password" {
  default   = null
  sensitive = true
  type      = string
}

variable "tags" {
  default = null
  type    = map(string)
}