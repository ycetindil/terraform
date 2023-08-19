variable "name" {
  description = <<EOD
    (Required) The name of the DNS CNAME Record.
    Changing this forces a new resource to be created.
  EOD
  type = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) Specifies the resource group where the DNS Zone (parent resource) exists.
    Changing this forces a new resource to be created.
  EOD
  type = string
}

variable "zone_name" {
  description = <<EOD
    (Required) Specifies the DNS Zone where the resource exists.
    Changing this forces a new resource to be created.
  EOD
  type = string
}

variable "ttl" {
  description = <<EOD
    (Required) The Time To Live (TTL) of the DNS record in seconds.
  EOD
  type = number
}

variable "record" {
  description = <<EOD
    (Optional) The target of the CNAME.
    NOTE: either record OR target_resource_id must be specified, but not both.
  EOD
  default = null
  type = string
}