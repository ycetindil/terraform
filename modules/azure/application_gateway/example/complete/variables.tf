application_gateway_xxx = {
  name = "agw-project_101-prod-eastus-001"
  # resource_group_name is provided by the root main.
  location = "eastus"
  backend_address_pools = {
    backend_address_pool_01 = {
      name = "subdomain1-bap"
      # fqdns is provided by the root main.
    }
    backend_address_pool_02 = {
      name = "subdomain2-bap"
      # fqdns is provided by the root main.
    }
  }
  backend_http_settingses = {
    backend_http_settings_01 = {
      name                           = "subdomain1-https-backend-settings"
      cookie_based_affinity          = "Disabled"
      port                           = 443
      protocol                       = "Https"
      request_timeout                = 60
      probe_name                     = "subdomain1-https-probe"
      trusted_root_certificate_names = ["xxx-com-root"]
    }
    backend_http_settings_02 = {
      name                           = "subdomain2-https-backend-settings"
      cookie_based_affinity          = "Disabled"
      port                           = 443
      protocol                       = "Https"
      request_timeout                = 60
      probe_name                     = "subdomain2-https-probe"
      trusted_root_certificate_names = ["xxx-com-root"]
    }
  }
  frontend_ip_configurations = {
    frontend_ip_configuration_01 = {
      name = "FEIPConfig01"
      # public_ip_address_id is provided by the root main.
    }
  }
  frontend_ports = {
    frontend_port_01 = {
      name = "FEPort80"
      port = 80
    }
    frontend_port_02 = {
      name = "FEPort443"
      port = 443
    }
  }
  gateway_ip_configurations = {
    gateway_ip_configuration_01 = {
      name = "GWIPConfig1"
      # subnet_id is provided by the root main.
    }
  }
  http_listeners = {
    http_listener_01 = {
      name                           = "subdomain1-http-listener"
      frontend_ip_configuration_name = "FEIPConfig01"
      frontend_port_name             = "FEPort80"
      protocol                       = "Http"
      host_name                      = "subdomain1.xxx.com"
    }
    http_listener_02 = {
      name                           = "subdomain1-https-listener"
      frontend_ip_configuration_name = "FEIPConfig01"
      frontend_port_name             = "FEPort443"
      protocol                       = "Https"
      ssl_certificate_name           = "xxx-com"
      host_name                      = "subdomain1.xxx.com"
    }
    http_listener_03 = {
      name                           = "subdomain2-http-listener"
      frontend_ip_configuration_name = "FEIPConfig01"
      frontend_port_name             = "FEPort80"
      protocol                       = "Http"
      host_name                      = "subdomain2.xxx.com"
    }
    http_listener_04 = {
      name                           = "subdomain2-https-listener"
      frontend_ip_configuration_name = "FEIPConfig01"
      frontend_port_name             = "FEPort443"
      protocol                       = "Https"
      ssl_certificate_name           = "xxx-com"
      host_name                      = "subdomain2.xxx.com"
    }
  }
  identity = {
    type = "UserAssigned"
    # identity_ids is provided by the root main.
  }
  sku = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
  request_routing_rules = {
    request_routing_rule_01 = {
      name                        = "subdomain1-http-rule"
      rule_type                   = "Basic"
      http_listener_name          = "subdomain1-http-listener"
      priority                    = "100"
      redirect_configuration_name = "subdomain1-http-to-https"
    }
    request_routing_rule_02 = {
      name                       = "subdomain1-https-rule"
      rule_type                  = "Basic"
      http_listener_name         = "subdomain1-https-listener"
      backend_address_pool_name  = "subdomain1-bap"
      backend_http_settings_name = "subdomain1-https-backend-settings"
      priority                   = "110"
    }
    request_routing_rule_03 = {
      name                        = "subdomain2-http-rule"
      rule_type                   = "Basic"
      http_listener_name          = "subdomain2-http-listener"
      priority                    = "120"
      redirect_configuration_name = "subdomain2-http-to-https"
    }
    request_routing_rule_04 = {
      name                       = "subdomain2-https-rule"
      rule_type                  = "Basic"
      http_listener_name         = "subdomain2-https-listener"
      backend_address_pool_name  = "subdomain2-bap"
      backend_http_settings_name = "subdomain2-https-backend-settings"
      priority                   = "130"
    }
  }
  trusted_root_certificates = {
    trusted_root_certificate_01 = {
      name = "xxx-com-root"
      // key_vault_secret_id is provided by the root main.
    }
  }
  probes = {
    probe_01 = {
      name                = "subdomain1-https-probe"
      host                = "subdomain1.xxx.com"
      interval            = 30
      timeout             = 30
      unhealthy_threshold = 3
      protocol            = "Https"
      port                = 443
      path                = "/"
    }
    probe_02 = {
      name                = "subdomain2-https-probe"
      host                = "subdomain2.xxx.com"
      interval            = 30
      timeout             = 30
      unhealthy_threshold = 3
      protocol            = "Https"
      port                = 443
      path                = "/Auth"
      match = {
        status_code = ["200-401"]
      }
    }
  }
  ssl_certificates = {
    ssl_certificate_01 = {
      name = "xxx-com"
      # key_vault_secret_id is provided by the root main.
    }
  }
  redirect_configurations = {
    redirect_configuration_01 = {
      name                 = "subdomain1-http-to-https"
      redirect_type        = "Permanent"
      target_listener_name = "subdomain1-https-listener"
      include_path         = true
      include_query_string = true
    }
    redirect_configuration_02 = {
      name                 = "subdomain2-http-to-https"
      redirect_type        = "Permanent"
      target_listener_name = "subdomain2-https-listener"
      include_path         = true
      include_query_string = true
    }
  }
}