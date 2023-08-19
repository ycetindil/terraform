# Manages a Front Door (standard/premium) Origin Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group
resource "azurerm_cdn_frontdoor_origin_group" "cdn_frontdoor_origin_group" {
  name                     = var.name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id

  load_balancing {
    additional_latency_in_milliseconds = var.load_balancing.additional_latency_in_milliseconds
    sample_size                        = var.load_balancing.sample_size
    successful_samples_required        = var.load_balancing.successful_samples_required
  }

  dynamic "health_probe" {
    for_each = var.health_probe != null ? [1] : []

    content {
      protocol            = var.health_probe.protocol
      interval_in_seconds = var.health_probe.interval_in_seconds
      request_type        = var.health_probe.request_type
      path                = var.health_probe.path
    }
  }

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = var.restore_traffic_time_to_healed_or_new_endpoint_in_minutes
  session_affinity_enabled                                  = var.session_affinity_enabled
}