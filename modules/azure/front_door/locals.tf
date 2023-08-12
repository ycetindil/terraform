locals {
  # Gather all 'dns_zone's from all 'custom_domain's
  cdn_frontdoor_custom_domain_dns_zones = {
    for key, domain in var.cdn_frontdoor_custom_domains : key => dns_zone
    if dns_zone != null
  }

  # Gather all 'load_balancer's from all 'origin's
  cdn_frontdoor_origin_load_balancers = {
    for key, origin in var.cdn_frontdoor_origins : key => {
      name                = origin.host.name
      resource_group_name = origin.host.resource_group_name
    }
    if origin.host.type == "Microsoft.Network/loadBalancers"
  }

  # Gather all 'private_link_service's from all 'origin's
  cdn_frontdoor_origin_private_link_services = {
    for key, origin in var.cdn_frontdoor_origins : key => {
      name                = origin.private_link.target.name
      resource_group_name = origin.private_link.target.resource_group_name
    }
    if origin.host.type == "Microsoft.Network/loadBalancers" && origin.private_link != null
  }

  # Gather all 'storage_blob's from all 'origin's
  cdn_frontdoor_origin_storage_blobs = {
    for key, origin in var.cdn_frontdoor_origins : key => {
      name                   = origin.host.name
      storage_account_name   = origin.host.storage_account_name
      storage_container_name = origin.host.storage_container_name
    }
    if origin.host.type == "Microsoft.Storage/blobs"
  }

  # Gather all 'app_service's from all 'origin's
  cdn_frontdoor_origin_app_services = {
    for key, origin in var.cdn_frontdoor_origins : key => {
      name                = origin.host.name
      resource_group_name = origin.host.resource_group_name
    }
    if origin.host.type == "Microsoft.Web/sites"
  }
}