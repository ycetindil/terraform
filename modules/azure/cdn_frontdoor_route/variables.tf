variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Front Door Route.
    Valid values must begin with a letter or number, end with a letter or number and may only contain letters, numbers and hyphens with a maximum length of 90 characters.
    Changing this forces a new Front Door Route to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_endpoint_id" {
  description = <<EOD
    (Required) The resource ID of the Front Door Endpoint where this Front Door Route should exist.
    Changing this forces a new Front Door Route to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_origin_group_id" {
  description = <<EOD
    (Required) The resource ID of the Front Door Origin Group where this Front Door Route should be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_origin_ids" {
  description = <<EOD
    (Required) One or more Front Door Origin resource IDs that this Front Door Route will link to.
  EOD
  type        = string
}

variable "forwarding_protocol" {
  description = <<EOD
    (Optional) The Protocol that will be use when forwarding traffic to backends.
    Possible values are HttpOnly, HttpsOnly or MatchRequest.
  EOD
  default     = null
  type        = string
}

variable "patterns_to_match" {
  description = <<EOD
    (Required) The route patterns of the rule.
  EOD
  type        = string
}

variable "supported_protocols" {
  description = <<EOD
    (Required) One or more Protocols supported by this Front Door Route.
    Possible values are Http or Https.
    NOTE: If https_redirect_enabled is set to true the supported_protocols field must contain both Http and Https values.
  EOD
  type        = string
}

variable "cache" {
  description = <<EOD
    (Optional) A cache block as defined below.
    A cache block supports the following:
    - query_string_caching_behavior - (Optional) Defines how the Front Door Route will cache requests that include query strings.
      Possible values include IgnoreQueryString, IgnoreSpecifiedQueryStrings, IncludeSpecifiedQueryStrings or UseQueryString.
      Defaults it IgnoreQueryString.
      NOTE: The value of the query_string_caching_behavior determines if the query_strings field will be used as an include list or an ignore list.
    - query_strings - (Optional) Query strings to include or ignore.
    - compression_enabled - (Optional) Is content compression enabled?
      Possible values are true or false.
      Defaults to false.
      NOTE: Content won't be compressed when the requested content is smaller than 1 KB or larger than 8 MB(inclusive).
    - content_types_to_compress - (Optional) A list of one or more Content types (formerly known as MIME types) to compress.
      Possible values include application/eot, application/font, application/font-sfnt, application/javascript, application/json, application/opentype, application/otf, application/pkcs7-mime, application/truetype, application/ttf, application/vnd.ms-fontobject, application/xhtml+xml, application/xml, application/xml+rss, application/x-font-opentype, application/x-font-truetype, application/x-font-ttf, application/x-httpd-cgi, application/x-mpegurl, application/x-opentype, application/x-otf, application/x-perl, application/x-ttf, application/x-javascript, font/eot, font/ttf, font/otf, font/opentype, image/svg+xml, text/css, text/csv, text/html, text/javascript, text/js, text/plain, text/richtext, text/tab-separated-values, text/xml, text/x-script, text/x-component or text/x-java-source.
  EOD
  default     = null
  type = object({
    query_string_caching_behavior = optional(string)
    query_strings                 = optional(list(string))
    compression_enabled           = optional(bool)
    content_types_to_compress     = optional(list(string))
  })
}

variable "cdn_frontdoor_custom_domain_ids" {
  description = <<EOD
    (Optional) The IDs of the Front Door Custom Domains which are associated with this Front Door Route.
  EOD
  default     = null
  type        = set(string)
}

variable "cdn_frontdoor_origin_path" {
  description = <<EOD
    (Optional) A directory path on the Front Door Origin that can be used to retrieve content (e.g. contoso.cloudapp.net/originpath).
  EOD
  default     = null
  type        = string
}

variable "cdn_frontdoor_rule_set_ids" {
  description = <<EOD
    (Optional) A list of the Front Door Rule Set IDs which should be assigned to this Front Door Route.
  EOD
  default     = null
  type        = set(string)
}

variable "enabled" {
  description = <<EOD
    (Optional) Is this Front Door Route enabled?
    Possible values are true or false.
    Defaults to true.
  EOD
  default     = null
  type        = bool
}

variable "https_redirect_enabled" {
  description = <<EOD
    (Optional) Automatically redirect HTTP traffic to HTTPS traffic?
    Possible values are true or false.
    Defaults to true.
    NOTE: The https_redirect_enabled rule is the first rule that will be executed.
  EOD
  default     = null
  type        = bool
}

variable "link_to_default_domain" {
  description = <<EOD
    (Optional) Should this Front Door Route be linked to the default endpoint?
    Possible values include true or false.
    Defaults to true.
  EOD
  default     = null
  type        = bool
}