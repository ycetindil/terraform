variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Front Door Rule Set.
    Changing this forces a new Front Door Rule Set to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_profile_id" {
  description = <<EOD
    (Required) The ID of the Front Door Profile.
    Changing this forces a new Front Door Rule Set to be created.
  EOD
  type        = string
}