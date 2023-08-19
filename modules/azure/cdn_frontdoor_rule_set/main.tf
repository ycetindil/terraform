# Manages a Front Door (standard/premium) Rule Set.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule_set
resource "azurerm_cdn_frontdoor_rule_set" "cdn_frontdoor_rule_set" {
  name                     = var.name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
}