variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}

variable "tags" {
  default = null
  type    = map(string)
}

variable "containers" {
  default = {}
  type = map(object({
    name                  = string
    container_access_type = string
  }))
}