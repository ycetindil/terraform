# Manages a Front Door (standard/premium) Endpoint.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint
resource "azurerm_cdn_frontdoor_endpoint" "cdn_frontdoor_endpoint" {
  name                     = var.name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
  enabled                  = var.enabled
  tags                     = var.tags
}