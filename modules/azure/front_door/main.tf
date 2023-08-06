# Manages a Front Door (standard/premium) Profile which contains a collection of endpoints and origin groups.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile
resource "azurerm_cdn_frontdoor_profile" "afdp" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tags                = var.tags
}

# Manages a Front Door (standard/premium) Custom Domain.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain
resource "azurerm_cdn_frontdoor_custom_domain" "afdcdS" {
  for_each = var.cdn_frontdoor_custom_domains

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afdp.id
  dns_zone_id              = try(data.azurerm_dns_zone.cdn_frontdoor_custom_domain_dns_zones[each.key].id, null)
  host_name                = each.value.host_name

  tls {
    certificate_type        = each.value.tls.certificate_type
    minimum_tls_version     = each.value.tls.minimum_tls_version
    cdn_frontdoor_secret_id = each.value.tls.cdn_frontdoor_secret_id
  }

  depends_on = [azurerm_cdn_frontdoor_profile.afdp]
}

# Manages a Front Door (standard/premium) Endpoint.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint
resource "azurerm_cdn_frontdoor_endpoint" "afdepS" {
  for_each = var.cdn_frontdoor_endpoints

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afdp.id
}

# Manages a Front Door (standard/premium) Origin Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group
resource "azurerm_cdn_frontdoor_origin_group" "afdogS" {
  for_each = var.cdn_frontdoor_origin_groups

  name                                                      = each.value.name
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.afdp.id
  session_affinity_enabled                                  = each.value.session_affinity_enabled
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }

  dynamic "health_probe" {
    for_each = each.value.health_probes

    content {
      protocol            = health_probe.value.protocol
      interval_in_seconds = health_probe.value.interval_in_seconds
      request_type        = health_probe.value.request_type
      path                = health_probe.value.path
    }
  }

  depends_on = [azurerm_cdn_frontdoor_profile.afdp]
}

# Manages a Front Door (standard/premium) Origin.
# IMPORTANT: If you are attempting to implement an Origin that uses its own Private Link Service with a Load Balancer the Profile resource in your configuration file must have a depends_on meta-argument which references the azurerm_private_link_service, see Example Usage With Private Link Service at below website.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin
resource "azurerm_cdn_frontdoor_origin" "afdoS" {
  for_each = var.cdn_frontdoor_origins

  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.afdogS[each.value.cdn_frontdoor_origin_group].id
  enabled                        = each.value.enabled
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  # Host is either a 'load_balancer', or a 'storage_blob', or an 'app_service'
  host_name = try(
    data.azurerm_lb.cdn_frontdoor_origin_load_balancers[each.key].private_ip_address,
    data.azurerm_storage_blob.cdn_frontdoor_origin_storage_blobs[each.key].url,
    data.azurerm_linux_web_app.cdn_frontdoor_origin_app_services[each.key].default_hostname,
    "'try' function could not find a valid 'host_name' for the 'cdn_frontdoor_origin': ${each.value.name}!"
  )
  http_port          = each.value.http_port
  https_port         = each.value.https_port
  origin_host_header = each.value.origin_host_header
  priority           = each.value.priority
  weight             = each.value.weight

  dynamic "private_link" {
    for_each = each.value.private_link != null ? [1] : []

    content {
      request_message = each.value.private_link.request_message
      location        = each.value.private_link.location
      # Target is either a 'private_link_service', or a 'load_balancer', or a 'storage_blob', or an 'app_service'
      private_link_target_id = try(
        data.azurerm_private_link_service.cdn_frontdoor_origin_private_link_services[each.value.key].id,
        data.azurerm_lb.cdn_frontdoor_origin_load_balancers[each.key].id,
        data.azurerm_storage_blob.cdn_frontdoor_origin_storage_blobs[each.key].id,
        data.azurerm_linux_web_app.cdn_frontdoor_origin_app_services[each.key].id,
        "'try' function could not find a valid 'private_link_target_id' for the 'cdn_frontdoor_origin': ${each.value.name}!"
      )
    }
  }

  depends_on = [
    azurerm_cdn_frontdoor_profile.afdp,
    azurerm_cdn_frontdoor_origin_group.afdogS,
    data.azurerm_lb.cdn_frontdoor_origin_load_balancers,
    data.azurerm_private_link_service.cdn_frontdoor_origin_private_link_services,
    data.azurerm_linux_web_app.cdn_frontdoor_origin_app_services,
    data.azurerm_storage_blob.cdn_frontdoor_origin_storage_blobs
  ]
}

# Manages a Front Door (standard/premium) Route.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route
resource "azurerm_cdn_frontdoor_route" "afdrtS" {
  for_each = var.cdn_frontdoor_routes

  name                          = each.value.name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afdepS[each.value.cdn_frontdoor_endpoint].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afdogS[each.value.cdn_frontdoor_origin_group].id
  cdn_frontdoor_origin_ids = [
    for key, origin in each.value.origins :
    azurerm_cdn_frontdoor_origin.afdoS[origin].id
  ]
  forwarding_protocol = each.value.forwarding_protocol
  patterns_to_match   = each.value.patterns_to_match
  supported_protocols = each.value.supported_protocols
  cdn_frontdoor_custom_domain_ids = [
    for domain in each.value.custom_domains :
    azurerm_cdn_frontdoor_custom_domain.afdcdS[domain].id
  ]
  cdn_frontdoor_origin_path = each.value.cdn_frontdoor_origin_path
  cdn_frontdoor_rule_set_ids = [
    for rule_set in each.value.cdn_frontdoor_rule_sets :
    azurerm_cdn_frontdoor_rule_set.afdrsS[rule_set].id
  ]
  enabled                = each.value.enabled
  https_redirect_enabled = each.value.https_redirect_enabled
  link_to_default_domain = each.value.link_to_default_domain

  depends_on = [
    azurerm_cdn_frontdoor_profile.afdp,
    azurerm_cdn_frontdoor_endpoint.afdepS,
    azurerm_cdn_frontdoor_origin_group.afdogS,
    azurerm_cdn_frontdoor_origin.afdoS,
    azurerm_cdn_frontdoor_rule_set.afdrsS
  ]
}

# Manages a Front Door (standard/premium) Rule Set.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule_set
resource "azurerm_cdn_frontdoor_rule_set" "afdrsS" {
  for_each = var.cdn_frontdoor_rule_sets

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afdp.id

  depends_on = [azurerm_cdn_frontdoor_profile.afdp]
}

# Manages a Front Door (standard/premium) Rule.
# IMPORTANT: The Rules resource must include a depends_on meta-argument which references the azurerm_cdn_frontdoor_origin and the azurerm_cdn_frontdoor_origin_group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule
resource "azurerm_cdn_frontdoor_rule" "afdrlS" {
  for_each = var.cdn_frontdoor_rules

  name                      = each.value.name
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.afdrsS[each.value.rule_set].id
  order                     = index(keys(var.rules), each.key) + 1

  dynamic "conditions" {
    for_each = each.value.conditions != null ? [1] : []

    dynamic "request_scheme_condition" {
      for_each = conditions.request_scheme_condition != null ? [1] : []

      content {
        operator     = request_scheme_condition.value.operator
        match_values = request_scheme_condition.value.match_values
      }
    }
  }

  actions {
    dynamic "url_redirect_action" {
      for_each = each.value.actions.url_redirect_action != null ? [1] : []

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

  depends_on = [
    azurerm_cdn_frontdoor_profile.afdp,
    azurerm_cdn_frontdoor_origin_group.afdogS,
    azurerm_cdn_frontdoor_origin.afdoS
  ]
}