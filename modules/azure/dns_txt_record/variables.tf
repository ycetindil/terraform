variable "name" {
  description = <<EOD
    (Required) The name of the DNS TXT Record.
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
    (Required) A list of values that make up the txt record. Each record block supports fields documented below.
    The record block supports:
    - value - (Required) The value of the record.
      Max length: 1024 characters
  EOD
  type = object({
    value = string
  })
}

variable "tags" {
  description = <<EOD
    (Optional) A mapping of tags to assign to the resource.
  EOD
  default = null
  type = map(string)
}