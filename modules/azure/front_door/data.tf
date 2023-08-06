# Use this data source to access information about an existing DNS Zone.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone.html
data "azurerm_dns_zone" "cdn_frontdoor_custom_domain_dns_zones" {
  for_each = local.cdn_frontdoor_custom_domain_dns_zones

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Manages a Load Balancer Resource.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb
data "azurerm_lb" "cdn_frontdoor_origin_load_balancers" {
  for_each = local.cdn_frontdoor_origin_load_balancers

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Manages a Private Link Service.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_link_service.html
data "azurerm_private_link_service" "cdn_frontdoor_origin_private_link_services" {
  for_each = local.cdn_frontdoor_origin_private_link_services

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Use this data source to access information about an existing Storage Blob.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_blob
data "azurerm_storage_blob" "cdn_frontdoor_origin_storage_blobs" {
  for_each = local.cdn_frontdoor_origin_storage_blobs

  name                   = each.value.name
  storage_account_name   = each.value.storage_account_name
  storage_container_name = each.value.storage_container_name
}

# Use this data source to access information about an existing Linux Web App.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/linux_web_app
data "azurerm_linux_web_app" "cdn_frontdoor_origin_app_services" {
  for_each = local.cdn_frontdoor_origin_app_services

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}