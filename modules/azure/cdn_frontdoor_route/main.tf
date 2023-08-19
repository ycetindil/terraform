# Manages a Front Door (standard/premium) Route.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route
resource "azurerm_cdn_frontdoor_route" "cdn_frontdoor_route" {
  name                          = var.name
  cdn_frontdoor_endpoint_id     = var.cdn_frontdoor_endpoint_id
  cdn_frontdoor_origin_group_id = var.cdn_frontdoor_origin_group_id
  cdn_frontdoor_origin_ids      = var.cdn_frontdoor_origin_ids
  forwarding_protocol           = var.forwarding_protocol
  patterns_to_match             = var.patterns_to_match
  supported_protocols           = var.supported_protocols

  dynamic "cache" {
    for_each = var.cache != null ? [1] : []

    content {
      query_string_caching_behavior = var.cache.query_string_caching_behavior
      query_strings                 = var.cache.query_strings
      compression_enabled           = var.cache.compression_enabled
      content_types_to_compress     = var.cache.content_types_to_compress
    }
  }

  cdn_frontdoor_custom_domain_ids = var.cdn_frontdoor_custom_domain_ids
  cdn_frontdoor_origin_path       = var.cdn_frontdoor_origin_path
  cdn_frontdoor_rule_set_ids      = var.cdn_frontdoor_rule_set_ids
  enabled                         = var.enabled
  https_redirect_enabled          = var.https_redirect_enabled
  link_to_default_domain          = var.link_to_default_domain
}