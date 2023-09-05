# Manages a Front Door (standard/premium) Origin.
# IMPORTANT: If you are attempting to implement an Origin that uses its own Private Link Service with a Load Balancer the Profile resource in your configuration file must have a depends_on meta-argument which references the azurerm_private_link_service, see Example Usage With Private Link Service at below website.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin
resource "azurerm_cdn_frontdoor_origin" "cdn_frontdoor_origin" {
  name                           = var.name
  cdn_frontdoor_origin_group_id  = var.cdn_frontdoor_origin_group
  host_name                      = var.host_name
  certificate_name_check_enabled = var.certificate_name_check_enabled
  enabled                        = var.enabled
  http_port                      = var.http_port
  https_port                     = var.https_port
  origin_host_header             = var.origin_host_header
  priority                       = var.priority

  dynamic "private_link" {
    for_each = var.private_link != null ? [1] : []

    content {
      request_message        = var.private_link.request_message
      target_type            = var.private_link.target_type
      location               = var.private_link.location
      private_link_target_id = var.private_link.private_link_target_id
    }
  }
	
  weight                         = var.weight
}