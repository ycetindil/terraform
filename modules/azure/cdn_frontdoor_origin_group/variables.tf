variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Front Door Origin Group.
    Changing this forces a new Front Door Origin Group to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_profile_id" {
  description = <<EOD
    (Required) The ID of the Front Door Profile within which this Front Door Origin Group should exist.
    Changing this forces a new Front Door Origin Group to be created.
  EOD
  type        = string
}

variable "load_balancing" {
  description = <<EOD
    (Required) A load_balancing block as defined below.
    A load_balancing block supports the following:
    - additional_latency_in_milliseconds - (Optional) Specifies the additional latency in milliseconds for probes to fall into the lowest latency bucket.
      Possible values are between 0 and 1000 milliseconds (inclusive).
      Defaults to 50.
    - sample_size - (Optional) Specifies the number of samples to consider for load balancing decisions.
      Possible values are between 0 and 255 (inclusive).
      Defaults to 4.
    - successful_samples_required - (Optional) Specifies the number of samples within the sample period that must succeed.
      Possible values are between 0 and 255 (inclusive).
      Defaults to 3.
  EOD
  type = object({
    additional_latency_in_milliseconds = optional(number)
    sample_size                        = optional(number)
    successful_samples_required        = optional(number)
  })
}

variable "variable_name" {
  description = <<EOD
    health_probe - (Optional) A health_probe block as defined below.
    A health_probe block supports the following:
    - protocol - (Required) Specifies the protocol to use for health probe.
      Possible values are Http and Https.
    - interval_in_seconds - (Required) Specifies the number of seconds between health probes.
      Possible values are between 5 and 31536000 seconds (inclusive).
    - request_type - (Optional) Specifies the type of health probe request that is made.
      Possible values are GET and HEAD.
      Defaults to HEAD.
    - path - (Optional) Specifies the path relative to the origin that is used to determine the health of the origin.
      Defaults to /.
    NOTE: Health probes can only be disabled if there is a single enabled origin in a single enabled origin group. For more information about the health_probe settings please see https://docs.microsoft.com/azure/frontdoor/health-probes.
  EOD
  default     = null
  type = object({
    protocol            = string
    interval_in_seconds = number
    request_type        = optional(string)
    path                = optional(string)
  })
}

variable "restore_traffic_time_to_healed_or_new_endpoint_in_minutes" {
  description = <<EOD
    (Optional) Specifies the amount of time which should elapse before shifting traffic to another endpoint when a healthy endpoint becomes unhealthy or a new endpoint is added.
    Possible values are between 0 and 50 minutes (inclusive).
    Default is 10 minutes.
  EOD
  default     = null
  type        = number
}

variable "session_affinity_enabled" {
  description = <<EOD
    (Optional) Specifies whether session affinity should be enabled on this host.
    Defaults to true.
  EOD
  default     = null
  type        = bool
}