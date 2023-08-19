variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Front Door Rule.
    Possible values must be between 1 and 260 characters in length, begin with a letter and may contain only letters and numbers.
    Changing this forces a new Front Door Rule to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_rule_set_id" {
  description = <<EOD
    (Required) The resource ID of the Front Door Rule Set for this Front Door Rule.
    Changing this forces a new Front Door Rule to be created.
  EOD
  type        = string
}

variable "order" {
  description = <<EOD
    (Required) The order in which the rules will be applied for the Front Door Endpoint.
    The order value should be sequential and begin at 1(e.g. 1, 2, 3…).
    A Front Door Rule with a lesser order value will be applied before a rule with a greater order value.
    NOTE: If the Front Door Rule has an order value of 0 they do not require any conditions and the actions will always be applied.
    CAUTION: order is being generated inside the module and not given through a variable.
  EOD
  type        = number
}

variable "actions" {
  description = <<EOD
    (Required) An actions block as defined below.
    An actions block supports the following:
    NOTE: You may include up to 5 separate actions in the actions block.
    Some actions support Action Server Variables which provide access to structured information about the request. For more information about Action Server Variables see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule#action-server-variables.
    - url_redirect_action - (Optional) A url_redirect_action block supports the following:
      NOTE: You may not have a url_redirect_action and a url_rewrite_action defined in the same actions block.
      - redirect_type - (Required) The response type to return to the requestor.
        Possible values include Moved, Found, TemporaryRedirect or PermanentRedirect.
      - destination_hostname - (Required) The host name you want the request to be redirected to.
        The value must be a string between 0 and 2048 characters in length.
        Leave blank to preserve the incoming host.
      - redirect_protocol - (Optional) The protocol the request will be redirected as.
        Possible values include MatchRequest, Http or Https.
        Defaults to MatchRequest.
      - destination_path - (Optional) The path to use in the redirect.
        The value must be a string and include the leading /.
        Leave blank to preserve the incoming path.
        Defaults to an empty string, i.e. "".
      - query_string - (Optional) The query string used in the redirect URL.
        The value must be in the <key>=<value> or <key>={action_server_variable} format and must not include the leading ?.
        Leave blank to preserve the incoming query string.
        Maximum allowed length for this field is 2048 characters.
        Defaults to an empty string, i.e. "".
      - destination_fragment - (Optional) The fragment to use in the redirect.
        The value must be a string between 0 and 1024 characters in length
        Leave blank to preserve the incoming fragment.
        Defaults to an empty string, i.e. "".
  EOD
  type = object({
    url_redirect_action = optional(object({
      redirect_type        = string
      destination_hostname = string
      redirect_protocol    = optional(string)
      destination_path     = optional(string)
      query_string         = optional(string)
      destination_fragment = optional(string)
    }))
  })
}

variable "behavior_on_match" {
  description = <<EOD
    (Optional) If this rule is a match should the rules engine continue processing the remaining rules or stop?
    Possible values are Continue and Stop.
    Defaults to Continue.
  EOD
  default     = null
  type        = string
}

variable "conditions" {
  description = <<EOD
    (Optional) A conditions block as defined below.
    A conditions block supports the following:
    NOTE: You may include up to 10 separate conditions in the conditions block.
    - request_scheme_condition - (Optional) A request_scheme_condition block supports the following:
      NOTE: The request_scheme_condition identifies requests that use the specified protocol.
      - operator - (Optional) Possible value Equal.
        Defaults to Equal.
      - negate_condition - (Optional) If true operator becomes the opposite of its value.
        Possible values true or false.
        Defaults to false.
      - match_values - (Optional) The requests protocol to match.
        Possible values include HTTP or HTTPS.
  EOD
  default     = null
  type = object({
    request_scheme_condition = optional(object({
      operator         = optional(string)
      negate_condition = optional(bool)
      match_values     = optional(string)
    }))
  })
}