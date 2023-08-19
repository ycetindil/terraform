# Manages a Front Door (standard/premium) Rule.
# IMPORTANT: The Rules resource must include a depends_on meta-argument which references the azurerm_cdn_frontdoor_origin and the azurerm_cdn_frontdoor_origin_group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule
resource "azurerm_cdn_frontdoor_rule" "cdn_frontdoor_rule" {
  name                      = var.name
  cdn_frontdoor_rule_set_id = var.cdn_frontdoor_rule_set_id
  order                     = var.order

  actions {
    dynamic "url_redirect_action" {
      for_each = var.actions.url_redirect_action != null ? [1] : []

      content {
        redirect_type        = url_redirect_action.value.redirect_type
        destination_hostname = url_redirect_action.value.destination_hostname
        redirect_protocol    = url_redirect_action.value.redirect_protocol
        destination_path     = url_redirect_action.value.destination_path
        query_string         = url_redirect_action.value.query_string
        destination_fragment = url_redirect_action.value.destination_fragment
      }
    }
  }

  behavior_on_match = var.behavior_on_match

  dynamic "conditions" {
    for_each = var.conditions != null ? [1] : []

    dynamic "request_scheme_condition" {
      for_each = conditions.request_scheme_condition != null ? [1] : []

      content {
        operator         = request_scheme_condition.value.operator
        negate_condition = request_scheme_condition.value.negate_condition
        match_values     = request_scheme_condition.value.match_values
      }
    }
  }
}