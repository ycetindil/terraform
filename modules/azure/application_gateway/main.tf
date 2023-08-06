# Manages an Application Gateway.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
resource "azurerm_application_gateway" "agw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configurations

    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = data.azurerm_subnet.gateway_ip_configuration_subnets[gateway_ip_configuration.key].id
    }
  }

  dynamic "frontend_ports" {
    for_each = var.frontend_ports

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations

    content {
      name                            = frontend_ip_configuration.value.name
      subnet_id                       = try(data.azurerm_subnet.frontend_ip_configuration_subnets[frontend_ip_configuration.key].id, null)
      private_ip_address              = frontend_ip_configuration.value.private_ip_address
      public_ip_address_id            = try(data.azurerm_public_ip.frontend_ip_configuration_public_ips[frontend_ip_configuration.key].id, null)
      private_ip_address_allocation   = frontend_ip_configuration.value.private_ip_address_allocation
      private_link_configuration_name = frontend_ip_configuration.value.private_link_configuration_name
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools

    content {
      name = backend_address_pool.value.name
      fqdns = merge(
        [
          for key, resource in each.value.resources :
          data.azurerm_linux_web_app.backend_address_pool_lapps["${backend_address_pool.key}_${key}"].default_hostname
          if resource.type == "lapp"
        ],
        [
          for key, resource in each.value.resources :
          data.azurerm_windows_web_app.backend_address_pool_wapps["${backend_address_pool.key}_${key}"].default_hostname
          if resource.type == "wapp"
        ],
        [
          for key, resource in each.value.resources :
          resource.fqdn
          if resource.type == "fqdn"
        ]
      )
      ip_addresses = merge(
        [
          for key, resource in each.value.resources :
          data.azurerm_network_interface.backend_address_pool_nics["${backend_address_pool.key}_${key}"].private_ip_address
          if resource.type == "nic"
        ],
        [
          for key, resource in each.value.resources :
          data.azurerm_virtual_machine_scale_set.backend_address_pool_vmsses["${backend_address_pool.key}_${key}"].instances.*.private_ip_address
          if resource.type == "vmss"
        ],
        [
          for key, resource in each.value.resources :
          data.azurerm_public_ip_address.backend_address_pool_pips["${backend_address_pool.key}_${key}"].ip_address
          if resource.type == "pip"
        ],
        [
          for key, resource in each.value.resources :
          resource.ip
          if resource.type == "ip"
        ]
      )
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settingses

    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      path                                = backend_http_settings.value.path
      probe_name                          = backend_http_settings.value.probe_name
      request_timeout                     = backend_http_settings.value.request_timeout
      host_name                           = backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
    }
  }

  dynamic "probe" {
    for_each = var.probes

    content {
      name                                      = probe.value.name
      host                                      = probe.value.host
      interval                                  = probe.value.interval
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      port                                      = probe.value.port
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      minimum_servers                           = probe.value.minimum_servers
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      host_name                      = http_listener.value.host_name
      host_names                     = http_listener.value.host_names
      protocol                       = http_listener.value.protocol
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
      firewall_policy_id             = http_listener.value.firewall_policy_id
      ssl_profile_name               = http_listener.value.ssl_profile_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules

    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
      url_path_map_name           = request_routing_rule.value.url_path_map_name
      priority                    = request_routing_rule.value.priority
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_maps

    content {
      name                                = url_path_map.value.name
      default_backend_address_pool_name   = url_path_map.value.default_backend_address_pool_name
      default_backend_http_settings_name  = url_path_map.value.default_backend_http_settings_name
      default_redirect_configuration_name = url_path_map.value.default_redirect_configuration_name
      default_rewrite_rule_set_name       = url_path_map.value.default_rewrite_rule_set_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules

        content {
          name                        = path_rule.value.name
          paths                       = path_rule.value.paths
          backend_address_pool_name   = path_rule.value.backend_address_pool_name
          backend_http_settings_name  = path_rule.value.backend_http_settings_name
          redirect_configuration_name = path_rule.value.redirect_configuration_name
          rewrite_rule_set_name       = path_rule.value.rewrite_rule_set_name
          firewall_policy_id          = path_rule.value.firewall_policy_id
        }
      }
    }
  }
}