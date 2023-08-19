variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Front Door Endpoint.
    Changing this forces a new Front Door Endpoint to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_profile_id" {
  description = <<EOD
    (Required) The ID of the Front Door Profile within which this Front Door Endpoint should exist.
    Changing this forces a new Front Door Endpoint to be created.
  EOD
  type        = string
}

variable "enabled" {
  description = <<EOD
    (Optional) Specifies if this Front Door Endpoint is enabled? Defaults to true.
  EOD
  default     = null
  type        = bool
}

variable "tags" {
  description = <<EOD
    (Optional) Specifies a mapping of tags which should be assigned to the Front Door Endpoint.
  EOD
  default     = null
  type        = map(string)
}