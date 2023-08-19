module "application_gateway_xxx" {
  name                = var.application_gateway_xxx.name
  resource_group_name = module.resource_group_xxx
  location            = var.application_gateway_xxx.location
  #   backend_address_pools = try(var.application_gateway_xxx.backend_address_pools, {})
  backend_address_pools = {
    backend_address_pool_01 = merge(
      var.application_gateway_xxx.backend_address_pools.backend_address_pool_01,
      { fqdns = [module.windows_web_app_xxx.fqdn] }
    )
  }
  #   backend_http_settingses = try(var.application_gateway_xxx.backend_http_settingses, {})
  backend_http_settingses = var.application_gateway_xxx.backend_http_settingses
  #   frontend_ip_configurations = try(var.application_gateway_xxx.frontend_ip_configurations, {})
  frontend_ip_configurations = {
    frontend_ip_configuration_01 = merge(
      var.application_gateway_xxx.frontend_ip_configurations.frontend_ip_configuration_01,
      { public_ip_address_id = module.public_ip_address_xxx.id }
    )
  }
  #   frontend_ports = try(var.application_gateway_xxx.frontend_ports, {})
  frontend_ports = var.application_gateway_xxx.frontend_ports
  #   gateway_ip_configurations = try(var.application_gateway_xxx.gateway_ip_configurations, {})
  gateway_ip_configurations = {
    gateway_ip_configuration_01 = merge(
      var.application_gateway_xxx.gateway_ip_configurations.gateway_ip_configuration_01,
      { subnet_id = module.subnet_xxx.id }
    )
  }
  #   http_listeners = try(var.application_gateway_xxx.http_listeners, {})
  http_listeners = var.application_gateway_xxx.http_listeners
  fips_enabled   = try(var.application_gateway_xxx.fips_enabled, null)
  global         = try(var.application_gateway_xxx.global, null)
  #   identity = try(var.application_gateway_xxx.identity, null)
  identity = merge(
    var.application_gateway_xxx.identity,
    { identity_ids = [module.user_assigned_identity_xxx.id] }
  )
  #   private_link_configurations = try(var.application_gateway_xxx.private_link_configurations, {})
  private_link_configurations = try(var.application_gateway_xxx.private_link_configurations, {})
  #   request_routing_rules = try(var.application_gateway_xxx.request_routing_rules, {})
  request_routing_rules = var.application_gateway_xxx.request_routing_rules
  #   sku = try(var.application_gateway_xxx.sku, null)
  sku                         = var.application_gateway_xxx.sku
  zones                       = try(var.application_gateway_xxx.zones, null)
  trusted_client_certificates = try(var.application_gateway_xxx.trusted_client_certificates, {})
  ssl_profiles                = try(var.application_gateway_xxx.ssl_profiles, {})
  authentication_certificates = try(var.application_gateway_xxx.authentication_certificates, {})
  #   trusted_root_certificates = try(var.application_gateway_xxx.trusted_root_certificates, {})
  trusted_root_certificates = {
    trusted_root_certificate_01 = merge(
      var.application_gateway_xxx.trusted_root_certificates.trusted_root_certificate_01,
      { key_vault_secret_id = data.azurerm_key_vault_secret.key_vault_secret_xxx_com_root.id }
    )
  }
  ssl_policy                        = try(var.application_gateway_xxx.ssl_policy, null)
  enable_http2                      = try(var.application_gateway_xxx.enable_http2, null)
  force_firewall_policy_association = try(var.application_gateway_xxx.force_firewall_policy_association, null)
  #   probes = try(var.application_gateway_xxx.probes, {})
  probes = var.application_gateway_xxx.probes
  #   ssl_certificates = try(var.application_gateway_xxx.ssl_certificates, {})
  ssl_certificates = {
    ssl_certificate_01 = merge(
      var.application_gateway_xxx.ssl_certificates.ssl_certificate_01,
      { key_vault_secret_id = data.azurerm_key_vault_certificate.key_vault_certificate_xxx_com.secret_id }
    )
  }
  tags                        = try(var.application_gateway_xxx.tags, null)
  url_path_maps               = try(var.application_gateway_xxx.url_path_maps, {})
  waf_configuration           = try(var.application_gateway_xxx.waf_configuration, null)
  custom_error_configurations = try(var.application_gateway_xxx.custom_error_configurations, {})
  firewall_policy_id          = try(var.application_gateway_xxx.firewall_policy_id, null)
  redirect_configurations     = var.application_gateway_xxx.redirect_configurations
  autoscale_configuration     = try(var.application_gateway_xxx.autoscale_configuration, null)
  rewrite_rule_sets           = try(var.application_gateway_xxx.rewrite_rule_sets, {})

  depends_on = [module.key_vault_access_policy_xxx]
}