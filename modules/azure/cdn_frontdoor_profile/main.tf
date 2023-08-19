# Manages a Front Door (standard/premium) Profile which contains a collection of endpoints and origin groups.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile
resource "azurerm_cdn_frontdoor_profile" "cdn_frontdoor_profile" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = var.response_timeout_seconds
  tags                     = var.tags
}